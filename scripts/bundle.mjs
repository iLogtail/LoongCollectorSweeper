#!/usr/bin/env node
/**
 * 使用 esbuild 将 dist/loongsweeper.js 打包为单文件 bundle。
 * 包含所有 npm 依赖（如 dotenv）与资源文件（prompts、schema）的内联。
 * 输出: dist/loongsweeper.bundle.js
 */
import { build } from "esbuild";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(__dirname, "..");

// Read resource files to inline
const reviewPrompt = fs.readFileSync(path.join(root, "prompts", "review-item.md"), "utf8");
const decisionSchema = fs.readFileSync(
  path.join(root, "schema", "loongsweeper-decision.schema.json"),
  "utf8",
);

// Create a virtual module that exports the inlined resources
// Use esbuild plugin to strip original shebang and inject resources
const stripShebangPlugin = {
  name: "strip-shebang",
  setup(build) {
    build.onLoad({ filter: /loongsweeper\.js$/ }, async (args) => {
      let contents = fs.readFileSync(args.path, "utf8");
      if (contents.startsWith("#!")) {
        contents = contents.replace(/^#!.*\n/, "");
      }
      return { contents, loader: "js" };
    });
  },
};
const banner = `
// --- Inlined resources (injected by bundle.mjs) ---
import { createRequire as __bundleCR } from "node:module";
const require = __bundleCR(import.meta.url);

const __inlinedResources = new Map();
__inlinedResources.set("review-item.md", ${JSON.stringify(reviewPrompt)});
__inlinedResources.set("loongsweeper-decision.schema.json", ${JSON.stringify(decisionSchema)});
// --- End inlined resources ---
`;

await build({
  entryPoints: [path.join(root, "dist", "loongsweeper.js")],
  bundle: true,
  platform: "node",
  format: "esm",
  target: "node24",
  outfile: path.join(root, "dist", "loongsweeper.bundle.js"),
  plugins: [stripShebangPlugin],
  banner: {
    js: `#!/usr/bin/env node\n${banner}`,
  },
  // Mark node built-ins as external
  external: [],
  // Don't externalize npm packages - bundle them
  // Use banner to provide CJS compat for dotenv which uses require('fs') etc.
  minify: false,
  sourcemap: false,
  logLevel: "info",
});

console.log("Bundle created: dist/loongsweeper.bundle.js");
