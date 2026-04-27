# 本地运行指南

本文说明如何在机器上构建并运行 LoongCollectorSweeper，以及如何向各子命令传递参数。

## 前置条件

| 项 | 说明 |
| --- | --- |
| **Node.js** | 本仓库要求 **Node ≥ 24**（见根目录 `package.json` 的 `engines`）。 |
| **GitHub CLI `gh`** | 需已安装并登录，能访问 `alibaba/loongcollector`（读 Issue/PR、时间线等）。 |
| **上游源码目录** | 审查会读取本地克隆的 LoongCollector 树；默认路径为 **与 Sweeper 仓库同级** 的 `../loongcollector`。 |
| **百炼** | 执行 `review` 时需要 **`DASHSCOPE_API_KEY`**，推荐写在仓库根目录的 **`.env`** 中。 |

### `.env` 文件（推荐）

1. 复制模板：`cp .env.example .env`（或手动新建 `.env`）。
2. 在 `.env` 中填写 `DASHSCOPE_API_KEY` 等；**勿将 `.env` 提交到 Git**（已列入 `.gitignore`）。
3. 程序会从 **Sweeper 仓库根目录** 读取 `.env`（与 `package.json` 同级），不依赖你当前 shell 的 `cd` 目录。
4. 与 CLI 冲突时，**`--loongcollector-dir` 等命令行参数优先**于 `.env` 中的路径类变量。

模板说明见仓库根目录 [`.env.example`](../.env.example)。

建议先在本仓库根目录执行：

```bash
npm install
npm run build
```

完整质量检查（与 `AGENTS.md` 一致）：

```bash
npm run check
```

## 如何传参（重要）

通过 `npm run <脚本名>` 调用时，**子命令的参数必须写在 `--` 之后**，否则会被 npm 吞掉。

```bash
# 正确：参数交给 node dist/clawsweeper.js review
npm run review -- --item-number 12345 --shard-index 0 --shard-count 1

# 错误：--item-number 不会传给 review
npm run review --item-number 12345
```

也可以先 `npm run build` 后直接调用入口（此时不需要中间的 `--`）：

```bash
node dist/clawsweeper.js review --item-number 12345 --shard-index 0 --shard-count 1
```

## 环境变量（`.env` 与 shell 均可）

以下均可写入 **`.env`**，也可在运行前用 `export` 注入（**同一键名时，通常后写入的 `process.env` 生效**；本程序在启动时先加载 `.env`）。

| 变量 | 说明 |
| --- | --- |
| `DASHSCOPE_API_KEY` | 百炼/灵积 API Key，**审查必需**。 |
| `DASHSCOPE_MODEL` | 模型名；不设时默认 `qwen-plus`。 |
| `DASHSCOPE_HTTP_BASE_URL` | 可选；兼容模式 API 根，不设则用代码内默认 DashScope 兼容地址。 |
| `LOONGSWEEPER_DOCS_URL` | 可选；审查里生成文档链接时的「公开文档根」。 |
| `LOONGSWEEPER_TARGET_REPO_DIR` 或 `LOONGCOLLECTOR_LOCAL_DIR` | 可选；本机上游克隆绝对或相对路径；**CLI 路径参数优先**。 |
| `LOONGCOLLECTOR_GH_READ_TOKEN` / `LOONGCOLLECTOR_GH_WRITE_TOKEN` | 可选；与 CI 命名一致；`gh` 无登录时可配合使用。 |

**仅用 `.env` 的示例：**

```ini
# .env
DASHSCOPE_API_KEY=你的Key
DASHSCOPE_MODEL=qwen-plus
# LOONGSWEEPER_TARGET_REPO_DIR=../loongcollector
```

**或临时在 shell 中：**

```bash
export DASHSCOPE_API_KEY="你的Key"
export DASHSCOPE_MODEL="qwen-plus"
```

## 子命令一览

入口为 `dist/clawsweeper.js`（由 `npm run build` 生成），第一个参数为子命令：

| 子命令 | npm 脚本 | 作用简述 |
| --- | --- | --- |
| `plan` | `npm run plan` | 规划待审查候选与分片矩阵（输出 JSON，CI 常用）。 |
| `review` | `npm run review` | 拉取 GitHub 上下文、调用百炼、写出审查 Markdown 产物。 |
| `apply-artifacts` | `npm run apply-artifacts` | 将审查产物目录合并进本仓库的 `items/` 等。 |
| `apply-decisions` | `npm run apply-decisions` | 按 `items/` 报告在 GitHub 上同步评论或关单（**会改远程**）。 |
| `reconcile` | `npm run reconcile` | 根据线上开放/关闭状态整理 `items/` 与 `closed/`。 |
| `dashboard` | `npm run dashboard` | 根据本地报告刷新 README 仪表盘表格。 |
| `status` | `npm run status` | 更新 README 中工作流状态块（`--state`、`--detail` 等）。 |
| `audit` | `npm run audit` | 对比线上与本地 `items/`、`closed/` 一致性；可写回 README 审计健康区块。 |

## 路径与只读相关参数

| 参数 | 说明 |
| --- | --- |
| `--loongcollector-dir` | 上游仓库本地路径（推荐）。 |
| `--target-repo-dir` | 与上者等价。 |
| `--openclaw-dir` | 旧名兼容，语义同上。 |
| 以上皆不传 | 使用默认 **`../loongcollector`**（相对当前工作目录，一般为 Sweeper 根目录）。 |
| `--readonly-loongcollector` | 审查前将上游树设为只读，防止误改。 |
| `--readonly-openclaw` | 旧开关名，效果同上。 |

## `review` 常用参数

| 参数 | 说明 |
| --- | --- |
| `--item-number` | 只审查单个 Issue/PR 编号。 |
| `--item-numbers` | 逗号分隔多个编号。 |
| `--batch-size` | 本分片内批大小，默认 `5`。 |
| `--max-pages` | 列举开放条目时的最大页数，默认 `250`。 |
| `--shard-index` / `--shard-count` | 分片索引与总分片数；本机单跑通常 `0` 和 `1`。 |
| `--hot-intake` | 启用热点 intake 选人逻辑（与线上一致）。 |
| `--bailian-model` / `--llm-model` | 模型名；也可用环境变量 `DASHSCOPE_MODEL`。 |
| `--codex-model` | 旧名，仍映射为模型名。 |
| `--bailian-timeout-ms` / `--llm-timeout-ms` / `--codex-timeout-ms` | 单条百炼请求超时（毫秒），默认约 `600000`。 |
| `--artifact-dir` | 输出目录，默认 `artifacts/reviews`（相对当前工作目录）。 |
| `--items-dir` | 报告目录，默认仓库内 `items/`。 |

### 示例：本机只审一条 Issue（产物进临时目录）

```bash
export DASHSCOPE_API_KEY="你的Key"

cd /path/to/LoongCollectorSweeper
npm run build

npm run review -- \
  --item-number 12345 \
  --loongcollector-dir /path/to/loongcollector \
  --readonly-loongcollector \
  --artifact-dir ./tmp-review \
  --shard-index 0 \
  --shard-count 1
```

审查生成的 `.md` 一般在 `--artifact-dir` 下；若要更新本仓库 `items/` 与仪表盘，需再执行 `apply-artifacts`、`reconcile`、`dashboard` 等（顺序与 CI 中 `publish` 类似）。

## `plan` 常用参数

与 `review` 部分参数重叠，用于输出规划 JSON，例如：

```bash
npm run plan -- \
  --batch-size 5 \
  --shard-count 4 \
  --max-pages 10
```

定向规划可加 `--item-number` 或 `--item-numbers`；热点可加 `--hot-intake`。

## `apply-decisions` 常用参数（会改 GitHub）

**仅在确认 token 权限与影响范围后再执行。** 常用项：

| 参数 | 说明 |
| --- | --- |
| `--limit` | 本 run 最多执行多少条「新关闭」类操作等（默认 `20`，以代码为准）。 |
| `--apply-kind` | `issue`、`pull_request` 或 `all`。 |
| `--item-numbers` | 只处理指定编号。 |
| `--sync-comments-only` | 仅同步持久化审查评论，不关单。 |
| `--skip-dashboard` | 跳过写 README 仪表盘（本地试跑可减少改动）。 |
| `--min-age-days`、`--close-delay-ms` 等 | 与线上一致，见 `src/clawsweeper.ts` 中 `applyDecisionsCommand`。 |

## `reconcile` / `dashboard` / `status`

```bash
npm run reconcile -- --dry-run          # 先看会动哪些文件（若支持 dry-run）
npm run reconcile
npm run dashboard
npm run status -- --state "本地调试" --detail "说明文字" --run-url "https://..."
```

## `audit` 常用参数

```bash
npm run audit -- --max-pages 50 --sample-limit 25
npm run audit -- --max-pages 250 --output /tmp/audit.json --update-dashboard
npm run audit -- --strict   # 严格失败时非零退出
```

## 故障排查

- **`gh` 报错未认证**：执行 `gh auth login`，并确认能 `gh issue list --repo alibaba/loongcollector --limit 1`。
- **百炼报错**：检查 `DASHSCOPE_API_KEY`、`DASHSCOPE_MODEL` 与网络；必要时设置 `DASHSCOPE_HTTP_BASE_URL`。
- **找不到上游默认路径**：显式传入 `--loongcollector-dir`（或 `--target-repo-dir`）指向你的克隆目录。

更细的实现以 [`src/clawsweeper.ts`](../src/clawsweeper.ts) 中各 `*Command` 函数为准。

**相关：** 希望「规划 → 多片审查 → 合并进本仓库 → 可选对上游关单/评论」的**完整顺序**，见 [**全量工作流**](full-sweep-workflow.md)。
