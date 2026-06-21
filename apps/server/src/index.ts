import { devToolsMiddleware } from "@ai-sdk/devtools";
import { google } from "@ai-sdk/google";
import fastifyCors from "@fastify/cors";
import { createContext } from "@llm-workflow-test/api/context";
import { appRouter, type AppRouter } from "@llm-workflow-test/api/routers/index";
import { auth } from "@llm-workflow-test/auth";
import { env } from "@llm-workflow-test/env/server";
import { fastifyTRPCPlugin, type FastifyTRPCPluginOptions } from "@trpc/server/adapters/fastify";
import { streamText, type UIMessage, convertToModelMessages, wrapLanguageModel } from "ai";
import Fastify from "fastify";

const baseCorsConfig = {
  origin: env.CORS_ORIGIN,
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization", "X-Requested-With"],
  credentials: true,
  maxAge: 86400,
};

const fastify = Fastify({
  logger: true,
});

fastify.register(fastifyCors, baseCorsConfig);

const nativeAppUrl = "llm-workflow-test://";
const allowedNativeProtocols = new Set(["exp:", new URL(nativeAppUrl).protocol]);

fastify.get("/polar/success", async (request, reply) => {
  const requestUrl = new URL(request.url, env.BETTER_AUTH_URL);
  const returnUrl = requestUrl.searchParams.get("returnUrl") || nativeAppUrl;

  let redirectUrl: URL;
  try {
    redirectUrl = new URL(returnUrl);
  } catch {
    reply.status(400).send("Invalid return URL");
    return;
  }

  if (!allowedNativeProtocols.has(redirectUrl.protocol)) {
    reply.status(400).send("Invalid return URL");
    return;
  }

  reply.status(302).header("Location", redirectUrl.toString()).send();
});

fastify.route({
  method: ["GET", "POST"],
  url: "/api/auth/*",
  async handler(request, reply) {
    try {
      const url = new URL(request.url, `http://${request.headers.host}`);
      const headers = new Headers();
      Object.entries(request.headers).forEach(([key, value]) => {
        if (value) headers.append(key, value.toString());
      });
      const req = new Request(url.toString(), {
        method: request.method,
        headers,
        body: request.body ? JSON.stringify(request.body) : undefined,
      });
      const response = await auth.handler(req);
      reply.status(response.status);
      response.headers.forEach((value, key) => reply.header(key, value));
      reply.send(response.body ? await response.text() : null);
    } catch (error) {
      fastify.log.error({ err: error }, "Authentication Error:");
      reply.status(500).send({
        error: "Internal authentication error",
        code: "AUTH_FAILURE",
      });
    }
  },
});

fastify.register(fastifyTRPCPlugin, {
  prefix: "/trpc",
  trpcOptions: {
    router: appRouter,
    createContext,
    onError({ path, error }) {
      console.error(`Error in tRPC handler on path '${path}':`, error);
    },
  } satisfies FastifyTRPCPluginOptions<AppRouter>["trpcOptions"],
});

interface AiRequestBody {
  id?: string;
  messages: UIMessage[];
}

fastify.post("/ai", async function (request) {
  const { messages } = request.body as AiRequestBody;
  const model = wrapLanguageModel({
    model: google("gemini-2.5-flash"),
    middleware: devToolsMiddleware(),
  });
  const result = streamText({
    model,
    messages: await convertToModelMessages(messages),
  });

  return result.toUIMessageStreamResponse();
});

fastify.get("/", async () => {
  return "OK";
});

fastify.listen({ port: 3000 }, (err) => {
  if (err) {
    fastify.log.error(err);
    process.exit(1);
  }
  console.log("Server running on port 3000");
});
