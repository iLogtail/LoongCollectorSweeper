#!/usr/bin/env node
/**
 * 读取 full-sweep 的 plan JSON，打印将执行的 review 命令（每行一条）。
 * 用法: node scripts/print-sweep-review-commands.mjs <plan.json> <hot 0|1> <batch> <maxPages> <timeoutMs>
 */
import fs from "node:fs";

const planPath = process.argv[2] ?? ".artifacts/full-sweep-plan.json";
const hot = process.argv[3] === "1";
const batch = process.argv[4] ?? "5";
const maxPages = process.argv[5] ?? "250";
const timeout = process.argv[6] ?? "600000";

const j = JSON.parse(fs.readFileSync(planPath, "utf8"));
const matrix = j.matrix ?? [];
const hotArg = hot ? "--hot-intake " : "";

for (const row of matrix) {
  const nums = row.item_numbers === "none" ? "" : String(row.item_numbers).trim();
  const extra = nums ? `--item-numbers ${nums} ` : "";
  const line = [
    "node dist/loongsweeper.js review",
    `--artifact-dir artifacts/review-shard-${row.shard}`,
    `--batch-size ${batch}`,
    `--max-pages ${maxPages}`,
    hotArg.trim(),
    "--readonly-loongcollector",
    `--bailian-timeout-ms ${timeout}`,
    `--shard-index ${row.shard}`,
    `--shard-count ${matrix.length}`,
    extra.trim(),
  ]
    .filter(Boolean)
    .join(" ");
  console.log(line.replace(/ +/g, " ").trim());
}
