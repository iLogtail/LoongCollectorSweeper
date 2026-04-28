#!/usr/bin/env bash
# 本地一键：规划 → 按分片 review → 合并产物 → apply-artifacts（更新 items/closed + README 仪表盘）
# 可选：对上游执行 apply-decisions（写评论/关单，须权限与团队授权）
#
# 用法（在仓库根目录）：
#   npm run sweep:local
#   npm run sweep:local -- --dry-run
#   npm run sweep:local -- --hot-intake --max-pages 5
#   npm run sweep:local -- --apply-remote --apply-limit 10
#
# 环境变量（可选，与命令行二选一）：
#   SWEEP_BATCH_SIZE  SWEEP_SHARD_COUNT  SWEEP_MAX_PAGES  SWEEP_HOT_INTAKE=1  SWEEP_DRY_RUN=1
#   SWEEP_APPLY_REMOTE=1  SWEEP_APPLY_LIMIT=20  SWEEP_APPLY_SYNC_ONLY=1

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ -f .env ]]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

BATCH_SIZE="${SWEEP_BATCH_SIZE:-5}"
SHARD_COUNT="${SWEEP_SHARD_COUNT:-4}"
MAX_PAGES="${SWEEP_MAX_PAGES:-250}"
BAILIAN_TIMEOUT_MS="${SWEEP_BAILIAN_TIMEOUT_MS:-600000}"
DRY_RUN="${SWEEP_DRY_RUN:-0}"
HOT_INTAKE="${SWEEP_HOT_INTAKE:-0}"
APPLY_REMOTE="${SWEEP_APPLY_REMOTE:-0}"
APPLY_LIMIT="${SWEEP_APPLY_LIMIT:-20}"
APPLY_SYNC_ONLY="${SWEEP_APPLY_SYNC_ONLY:-0}"

usage() {
  sed -n '1,13p' "$0" | tail -n +2
  cat <<'EOF'

选项：
  --batch-size N             plan/review 的 batch-size（默认 5）
  --shard-count N            分片数（默认 4）
  --max-pages N              扫描开放列表最大页数（默认 250）
  --bailian-timeout-ms N     单条百炼超时毫秒（默认 600000）
  --hot-intake               启用热点 intake 选人
  --dry-run                  只跑 plan 并打印将执行的 review 命令，不执行审查
  --skip-build               不执行 npm run build
  --apply-remote             结束后执行 apply-decisions（会改 alibaba/loongcollector）
  --apply-sync-only          与 --apply-remote 合用：只同步评论，不关单
  --apply-limit N            apply-decisions 的 --limit（默认 20）
  -h, --help                 本说明

默认不执行 apply-decisions；请确认权限与 AGENTS.md 流程后再加 --apply-remote。
EOF
}

SKIP_BUILD=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    --batch-size)
      BATCH_SIZE="$2"
      shift 2
      ;;
    --shard-count)
      SHARD_COUNT="$2"
      shift 2
      ;;
    --max-pages)
      MAX_PAGES="$2"
      shift 2
      ;;
    --bailian-timeout-ms)
      BAILIAN_TIMEOUT_MS="$2"
      shift 2
      ;;
    --hot-intake)
      HOT_INTAKE=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --skip-build)
      SKIP_BUILD=1
      shift
      ;;
    --apply-remote)
      APPLY_REMOTE=1
      shift
      ;;
    --apply-sync-only)
      APPLY_SYNC_ONLY=1
      shift
      ;;
    --apply-limit)
      APPLY_LIMIT="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "未知参数: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if [[ "${APPLY_SYNC_ONLY}" -eq 1 && "${APPLY_REMOTE}" -eq 0 ]]; then
  echo "提示: --apply-sync-only 将同时启用 --apply-remote（仅同步评论，不关单）。"
  APPLY_REMOTE=1
fi

if [[ -z "${DASHSCOPE_API_KEY:-}" ]]; then
  echo "错误: 未设置 DASHSCOPE_API_KEY（可在 .env 或环境中配置）。" >&2
  exit 1
fi

mkdir -p .artifacts artifacts

PLAN_JSON=".artifacts/full-sweep-plan.json"
MERGED_DIR="artifacts/full-sweep-merged"
rm -rf artifacts/review-shard-* "${MERGED_DIR}"
mkdir -p "${MERGED_DIR}"

if [[ "${SKIP_BUILD}" -eq 0 ]]; then
  echo "==> npm run build"
  npm run build
fi

if [[ ! -f dist/loongsweeper.js ]]; then
  echo "错误: dist/loongsweeper.js 不存在，请先 npm run build。" >&2
  exit 1
fi

HOT_ARGS=()
[[ "${HOT_INTAKE}" -eq 1 ]] && HOT_ARGS+=(--hot-intake)

echo "==> plan → ${PLAN_JSON}"
node dist/loongsweeper.js plan \
  --batch-size "${BATCH_SIZE}" \
  --shard-count "${SHARD_COUNT}" \
  --max-pages "${MAX_PAGES}" \
  ${HOT_ARGS[@]+"${HOT_ARGS[@]}"} >"${PLAN_JSON}"

PLANNED="$(node -e "const j=JSON.parse(require('fs').readFileSync('${PLAN_JSON}','utf8'));console.log(j.candidates?.length??0)")"
echo "    本轮规划候选数: ${PLANNED}"

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "==> dry-run: 将执行的 review 命令（未实际运行）"
  node scripts/print-sweep-review-commands.mjs "${PLAN_JSON}" "${HOT_INTAKE}" "${BATCH_SIZE}" "${MAX_PAGES}" "${BAILIAN_TIMEOUT_MS}"
  echo "（未执行 review / apply-artifacts）"
  exit 0
fi

MATRIX_LEN="$(node -e "const j=JSON.parse(require('fs').readFileSync('${PLAN_JSON}','utf8'));console.log((j.matrix||[]).length)")"
if [[ "${MATRIX_LEN}" -lt 1 ]]; then
  echo "错误: plan 结果中 matrix 为空。" >&2
  exit 1
fi

echo "==> review 分片（共 ${MATRIX_LEN} 片，串行）"
while IFS=$'\t' read -r shard nums; do
  if [[ -z "${nums}" || "${nums}" == "none" ]]; then
    echo "    跳过空分片 shard=${shard}"
    continue
  fi
  out="artifacts/review-shard-${shard}"
  mkdir -p "${out}"
  echo "    shard=${shard} items=${nums}"
  node dist/loongsweeper.js review \
    --artifact-dir "${out}" \
    --batch-size "${BATCH_SIZE}" \
    --max-pages "${MAX_PAGES}" \
    ${HOT_ARGS[@]+"${HOT_ARGS[@]}"} \
    --readonly-loongcollector \
    --bailian-timeout-ms "${BAILIAN_TIMEOUT_MS}" \
    --shard-index "${shard}" \
    --shard-count "${MATRIX_LEN}" \
    --item-numbers "${nums}"
done < <(node -e "
const fs = require('fs');
const j = JSON.parse(fs.readFileSync('${PLAN_JSON}', 'utf8'));
for (const row of j.matrix || []) {
  const nums = row.item_numbers === 'none' ? '' : String(row.item_numbers).trim();
  console.log(row.shard + '\\t' + nums);
}
")

echo "==> 合并 *.md → ${MERGED_DIR}"
shopt -s nullglob
for d in artifacts/review-shard-*; do
  [[ -d "$d" ]] || continue
  for f in "$d"/*.md; do
    [[ -f "$f" ]] || continue
    base="$(basename "$f")"
    if [[ "$base" =~ ^[0-9]+\.md$ ]]; then
      cp "$f" "${MERGED_DIR}/"
    fi
  done
done
shopt -u nullglob

COUNT="$(find "${MERGED_DIR}" -maxdepth 1 -name '[0-9]*.md' 2>/dev/null | wc -l | tr -d ' ')"
echo "    已合并报告数: ${COUNT}"
if [[ "${COUNT}" -eq 0 ]]; then
  echo "警告: 合并目录无数字 .md，跳过 apply-artifacts。"
  exit 0
fi

echo "==> apply-artifacts（写入 items/closed + reconcile + dashboard）"
node dist/loongsweeper.js apply-artifacts --artifact-dir "${MERGED_DIR}"

echo "==> 完成本地落盘。请检查: git status"
if [[ "${APPLY_REMOTE}" -eq 1 ]]; then
  echo ""
  echo "!!! --apply-remote：即将对 alibaba/loongcollector 执行 apply-decisions（limit=${APPLY_LIMIT}）"
  sleep 2
  SYNC_ARGS=()
  [[ "${APPLY_SYNC_ONLY}" -eq 1 ]] && SYNC_ARGS+=(--sync-comments-only)
  node dist/loongsweeper.js apply-decisions \
    --limit "${APPLY_LIMIT}" \
    --apply-kind all \
    --min-age-days 0 \
    --close-delay-ms 2000 \
    --progress-every 1 \
    ${SYNC_ARGS[@]+"${SYNC_ARGS[@]}"}
  echo "==> apply-decisions 已执行。"
fi
