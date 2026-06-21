import { mkdirSync, existsSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join, resolve } from "node:path";

function slugify(input) {
  return input
    .trim()
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .replace(/--+/g, "-");
}

const rawName = process.argv[2];
if (!rawName) {
  console.error("Usage: node scripts/init-feature-spec.mjs <feature-name> [--force]");
  process.exit(1);
}

const args = new Set(process.argv.slice(3));
const force = args.has("--force");

const featureName = slugify(rawName);
if (!featureName) {
  console.error("Feature name resolved to an empty slug.");
  process.exit(1);
}

const root = process.cwd();
const templateDir = resolve(root, "_templates");
const specsDir = resolve(root, "_specs");
const featureDir = join(specsDir, featureName);

const specFiles = [
  ["spec.md", "spec.md"],
  ["plan.md", "plan.md"],
  ["tasks.md", "tasks.md"],
  ["sanity-check.md", "sanity-check.md"],
  ["testing.md", "testing.md"],
  ["review.md", "review.md"],
  ["final.md", "final.md"],
];

mkdirSync(featureDir, { recursive: true });

const created = [];
const skipped = [];

for (const [fileName, templateName] of specFiles) {
  const target = join(featureDir, fileName);
  const template = join(templateDir, templateName);

  if (existsSync(target) && !force) {
    skipped.push(fileName);
    continue;
  }

  mkdirSync(dirname(target), { recursive: true });
  writeFileSync(target, readFileSync(template, "utf8"));
  created.push(fileName);
}

console.log(JSON.stringify({ featureName, featureDir, created, skipped, force }, null, 2));
