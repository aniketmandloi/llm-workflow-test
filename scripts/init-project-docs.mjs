import { mkdirSync, existsSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";

const root = process.cwd();
const templateDir = resolve(root, "_templates");
const docsDir = resolve(root, "_docs");

const projectFiles = [
  ["project-brief.md", "project-brief.md"],
  ["mvp.md", "mvp.md"],
  ["features.md", "features.md"],
  ["roadmap.md", "roadmap.md"],
];

const args = new Set(process.argv.slice(2));
const force = args.has("--force");

mkdirSync(docsDir, { recursive: true });

const created = [];
const skipped = [];

for (const [fileName, templateName] of projectFiles) {
  const target = join(docsDir, fileName);
  const template = join(templateDir, templateName);

  if (existsSync(target) && !force) {
    skipped.push(fileName);
    continue;
  }

  mkdirSync(dirname(target), { recursive: true });
  writeFileSync(target, readFileSync(template, "utf8"));
  created.push(fileName);
}

console.log(JSON.stringify({ docsDir, created, skipped, force }, null, 2));
