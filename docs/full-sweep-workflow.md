# 全量审查与本地落盘工作流

本文描述一条**从规划 → 多轮审查 → 合并进本仓库 → 可选同步/关单上游**的完整顺序，适合「尽可能覆盖当前开放 Issue/PR，并更新本仓库的 `items/`、`closed/` 与 README 仪表盘」。

> **原则**  
> - **审查（`review`）** 只产生 Markdown 与「提议」；不直接关 GitHub 上的单。  
> - **落盘与仪表盘** 通过 `apply-artifacts` / `reconcile` / `dashboard` 更新**本仓库**文件。  
> - **对 `alibaba/loongcollector` 写评论、关单** 在 **`apply-decisions`**；须具备 token 权限，且请遵守 [AGENTS.md](../AGENTS.md) 中关于授权与风险的要求。

---

## 0. 开始前检查

1. **环境**  
   - 已 [本地运行](local-run.md) 所述：`node`、`gh auth`、**`.env`** 中 `DASHSCOPE_API_KEY` 等。  
   - 上游仓库已克隆（默认 `../loongcollector` 或 `.env` 里 `LOONGSWEEPER_TARGET_REPO_DIR`）。

2. **工作区**  
   - 在 **LoongCollectorSweeper** 根目录操作；`git status` 尽量干净，便于你后续单独提交 `items/`、`closed/`、`README.md`。

3. **心理预期**  
   - 全量 = 对**每个候选开放条目**调一次百炼，**耗时长、占用 API 配额**。`--max-pages` 会限制扫描页数，可按需先缩小验证流程。

---

## 一键脚本（推荐）

仓库提供 **`scripts/full-sweep.sh`**，在根目录自动执行：**`plan` → 各分片 `review`（串行）→ 合并 `*.md` → `apply-artifacts`**（含 reconcile 与 README 仪表盘）。脚本会 **`source .env`**（若存在），请事先配置 **`DASHSCOPE_API_KEY`**。

```bash
npm install
# 先演练（只跑 plan，打印将执行的 review 命令）：
npm run sweep:local -- --dry-run --max-pages 3

# 正式跑一小批页数试通路：
npm run sweep:local -- --max-pages 3 --shard-count 2

# 默认参数全量（慎用：耗时长、占配额）：
npm run sweep:local
```

常用参数：`--hot-intake`、`--batch-size`、`--shard-count`、`--max-pages`、`--bailian-timeout-ms`、`--skip-build`。  
**对上游写 GitHub** 默认关闭；必须显式加 **`--apply-remote`**（可选 **`--apply-sync-only`** 只同步评论不关单、**`--apply-limit N`**）。详见脚本内 `usage` 或执行：

```bash
bash scripts/full-sweep.sh --help
```

等价环境变量：`SWEEP_BATCH_SIZE`、`SWEEP_SHARD_COUNT`、`SWEEP_MAX_PAGES`、`SWEEP_HOT_INTAKE=1`、`SWEEP_DRY_RUN=1`、`SWEEP_APPLY_REMOTE=1`、`SWEEP_APPLY_LIMIT`、`SWEEP_APPLY_SYNC_ONLY=1`。

---

## 1. 规划：看清要审多少、怎么分片

用 `plan` 看本轮会选中多少条、分几个 shard（与 CI 一致，输出含 `matrix`）：

```bash
npm run build
npm run plan -- \
  --batch-size 5 \
  --shard-count 4 \
  --max-pages 250
```

- 想先看少量页：把 `--max-pages` 改小（例如 `3`）试跑。  
- **热点优先**：加 `--hot-intake`（与线上「热点车道」类似）。  
- 只补审若干号：`--item-numbers 101,202,303`。

把输出里 **`planned_count`、分片与 `item_numbers`** 记下，供下一步按分片跑 `review`。

---

## 2. 全量审查：按分片跑 `review`、汇总产物

`review` 在**每个分片**内会顺序处理多号；**分片之间**在本机可串行可并行（多开终端时注意不要共用同一 `artifact-dir` 以免互相覆盖）。

### 2.1 推荐：每片一个输出目录，最后合并

与 CI 类似，片 `K` 写到例如 `artifacts/shard-K`：

```bash
# 将 SHARD 与 SHARD_COUNT 换成 plan 里的数值；示例：第 0 片，共 4 片
export SHARD=0
export SHARD_COUNT=4
npm run review -- \
  --artifact-dir "artifacts/review-shard-${SHARD}" \
  --batch-size 5 \
  --max-pages 250 \
  --readonly-loongcollector \
  --bailian-timeout-ms 600000 \
  --shard-index "${SHARD}" \
  --shard-count "${SHARD_COUNT}"
```

对 **每一个分片** 执行一次（`SHARD=0,1,…,SHARD_COUNT-1`）。**单机串行**最省事；机器与配额允许时可多进程并行，但每片**独立目录**。

### 2.2 合并所有 `*.md` 到一个目录

`apply-artifacts` 会递归搜目录下的 `数字.md`，把文件放到 `items/` 或 `closed/` 并再 reconcile + 写仪表盘。先合并分片输出（只要拷到一个目录即可，**编号不重复**）：

```bash
mkdir -p artifacts/merged
# 将各分片目录（如 artifacts/review-shard-0、…）里生成的 12345.md 等全部拷入（编号不重复即可）
cp artifacts/review-shard-0/*.md artifacts/merged/ 2>/dev/null || true
cp artifacts/review-shard-1/*.md artifacts/merged/ 2>/dev/null || true
# …依分片数继续；或用手动 / 脚本按你的目录名合并
```

若只有一片，可直接用该片目录作为「合并目录」。

### 2.3（可选）单进程「一片包揽」

若 `plan` 里只有 **1 个分片**（`shard_count=1` 或候选很少），可一次：

```bash
npm run review -- \
  --artifact-dir artifacts/merged \
  --batch-size 5 \
  --max-pages 250 \
  --readonly-loongcollector \
  --shard-index 0 \
  --shard-count 1
```

全仓库开放条目很多时，仍可能**一次跑不完**（受 `batch_size`、计划上限等影响），多轮重复执行 `plan`+`review` 或**提高 `shard_count` 多分片**更稳。

---

## 3. 写入本仓库：合并报告 + 对账 + 仪表盘

`apply-artifacts` 会：

- 将合并目录里审查生成的 `N.md` 归位到 **`items/`** 或 **`closed/`**；  
- 除非加 **`--skip-reconcile`**，否则会 **`reconcile`**；  
- 并 **更新 `README` 仪表盘**（`updateDashboard`）。

```bash
npm run apply-artifacts -- --artifact-dir artifacts/merged
```

若你只想**先**合并文件、**暂不**对账/仪表盘，可用：

```bash
npm run apply-artifacts -- --artifact-dir artifacts/merged --skip-reconcile
# 再手动
npm run reconcile
npm run dashboard
```

**仅对账**（根据 GitHub 状态整理 `items/` / `closed/`，不先应用 artifacts 时）：

```bash
npm run reconcile
npm run dashboard
```

查看 reconcile 会动什么（不写入）：

```bash
npm run reconcile -- --dry-run
```

---

## 4. 本地结果自检

- 浏览 `items/*.md`：看 `decision`、`action_taken`、`summary` 是否合理。  
- 运行（可选，会读 GitHub 并可能改 README 审计区）：

```bash
npm run audit -- --max-pages 250 --sample-limit 50
```

  需要时加 `--update-dashboard` 把审计健康写回 README。  
- 用 `git diff` 检查 `items/`、`closed/`、`README.md` 的变更，合适再提交：

```bash
git add items closed README.md
git status
git commit -m "chore: refresh sweeper item reports and dashboard"
```

（是否 `git push` 到 `iLogtail/LoongCollectorSweeper` 由你团队流程决定。）

---

## 5. 对上游「解决」Issue/PR：评论 + 关单（可选、高权限）

本地文件更新**不等于**已关 GitHub。要对 **`alibaba/loongcollector`** 同步**持久化审查评论**、并对「未变更且高置信的提议关单」执行**关单**：

1. 配置/导出具备 **`issues:write` / `pull_requests:write`** 的凭据（与 [README](../README.md) 中读写字段、或你司 CI 的 Secret 一致）。  
2. **先以同步评论为主**、小批量验证：

```bash
# 仅同步评论、不关单，限制处理条数，避免误伤
npm run apply-decisions -- \
  --sync-comments-only \
  --limit 5 \
  --item-numbers 具体编号,逗号分隔
```

3. 确认无问题后，再按仓库策略跑正式 apply（关单、checkpoint 等，参数见 `src/loongsweeper.ts` 的 `applyDecisionsCommand` 与 [local-run 中说明](local-run.md)）。  
4. 每次对上游有写操作后，建议再 `npm run reconcile` + `npm run dashboard` 与线上一致。

> **再次提醒**：[AGENTS.md](../AGENTS.md) 要求**未经明确授权**不要随意对生产仓库执行会关单的命令；在团队有流程前，可先只做步骤 0～4，把报告留在本仓库做人工跟进。

---

## 6. 建议顺序一览（速查）

| 顺序 | 动作 | 命令/说明 |
| ---: | --- | --- |
| 0 | 配置、构建 | `npm install`、`.env`、`npm run build` |
| 1 | 规划 | `npm run plan -- …` |
| 2 | 多片 `review` | 每片 `--artifact-dir` + `--shard-index` / `--shard-count` |
| 2b | 合并 | `cp` 各片 `N.md` 到 `artifacts/merged` |
| 3 | 落盘 + 仪表盘 | `npm run apply-artifacts -- --artifact-dir artifacts/merged` |
| 4 | 自检/审计 | `audit`、或至少 `git diff` |
| 5 | 提交本仓库 | `git add` / `git commit` |
| 6 | 上游（可选） | `apply-decisions`，严格按权限与流程 |

更细的参数与故障排查见 **[本地运行指南](local-run.md)**。若你希望和 CI 完全一致，可对齐 [.github/workflows/sweep.yml](../.github/workflows/sweep.yml) 中的 `plan` → `review` → `apply-artifacts` 参数。
