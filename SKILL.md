---
name: loongsweeper
description: >-
  Automate conservative maintenance of alibaba/loongcollector: scan open Issues/PRs,
  generate structured AI review reports via Alibaba Cloud Bailian, propose closures
  with evidence, and sync review comments to GitHub. Use when the user wants to
  triage, review, audit, or close stale issues in the loongcollector repository.
when_to_use:
  - User asks to review or triage loongcollector issues
  - User wants to scan and close stale issues/PRs
  - User needs to audit issue status or refresh the dashboard
  - User wants to sync AI review comments to GitHub
allowed-tools:
  - Bash
  - Read
  - Grep
  - Write
argument-hint: "<issue-number | 'all'> [--batch-size N] [--max-pages N]"
---

# LoongSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化 CLI。为每个待处理 Issue/PR 调用阿里云百炼生成结构化审查报告，在证据充分时提议关闭，并可同步持久化审查评论。

> **`loongsweeper.js` 是单文件 bundle，已内联所有依赖、schema 和 prompts，无需 `npm install`、无需额外文件。**
> `schema/` 和 `prompts/` 目录仅作参考文档，运行时不需要。

## 快速开始（Agent 自动化流程）

> **重要**：首次运行前必须完成环境配置（步骤 1-2），否则所有命令都会失败。
>
> **沙盒环境注意**：本 skill 运行在沙盒中，**无法继承宿主机的 `gh auth` 登录状态**。
> 必须向用户索要两个凭证，由你写入 `.env` 文件。

### 步骤 1：向用户索要凭证（首次运行前必须完成）

检查 `.env` 文件是否已存在且包含有效值。若不存在或缺少必需项，**立即向用户提问索要**以下两个值：

1. **`DASHSCOPE_API_KEY`** — 阿里云百炼 API Key（必需，用于 AI 审查）
2. **`GH_TOKEN`** — GitHub Personal Access Token（必需，沙盒无法继承宿主 `gh` 登录）
   - PAT 最低权限：`public_repo`（只读审查）；若需关单/评论：`repo`
   - 创建地址：https://github.com/settings/tokens

收到用户提供的值后，执行以下操作生成 `.env`：

```bash
cp .env.example .env
```

然后将用户给的值写入 `.env` 文件中对应的字段（替换占位内容）：
- `DASHSCOPE_API_KEY=<用户提供的值>`
- `GH_TOKEN=<用户提供的值>`

> **注意**：不要在聊天中回显用户的密钥值。写入文件后用 `grep -c '=' .env` 确认行数即可。

### 步骤 2-7：执行审查

按以下步骤顺序执行。每步都是一条 shell 命令，**在 `loongsweeper.js` 所在目录执行**。

```bash
# 2. 前置检查
node --version                          # 需要 >= 24

# 3. 克隆上游仓库（首次使用时）
git clone https://github.com/alibaba/loongcollector.git ../loongcollector

# 4. 验证环境
node loongsweeper.js check              # 应输出 "ok"

# 5. 审查单个 Issue（示例：#2084）
node loongsweeper.js review \
  --item-number 2084 \
  --loongcollector-dir ../loongcollector \
  --readonly-loongcollector \
  --artifact-dir ./artifacts \
  --shard-index 0 --shard-count 1

# 6. 合并审查产物
node loongsweeper.js apply-artifacts --artifact-dir ./artifacts

# 7. 查看结果
cat items/2084.md                       # 审查报告
```

### 监控长时间运行的命令

review 命令可能耗时数分钟（每条 Issue 需调用百炼 AI）。运行期间可读取日志判断进度：

```bash
tail -5 loongsweeper.log.jsonl
```

若最后一行的 `elapsed_ms` 在持续增长且 `event` 不是 `"finish"`，说明命令仍在正常执行，**不要中断**。

## 前置条件

| 项目 | 要求 |
| --- | --- |
| **Node.js** | >= 24 |
| **GitHub CLI `gh`** | 已安装；**沙盒环境下须通过 `GH_TOKEN` 环境变量传入 PAT**（宿主 `gh auth` 不可用） |
| **百炼 API Key** | 环境变量 `DASHSCOPE_API_KEY` 已配置 |
| **上游源码** | 本地克隆 `alibaba/loongcollector`（默认路径 `../loongcollector`） |

## 目录结构

```
loongsweeper/
├── SKILL.md                                    # 本文件
├── loongsweeper.js                             # 单文件 bundle，直接 node 运行
├── .env.example                                # 环境变量模板
├── schema/loongsweeper-decision.schema.json    # 审查决策 JSON Schema（参考）
└── prompts/review-item.md                      # 审查提示词（参考）
```

## 环境变量

复制 `.env.example` 为 `.env` 并填写，或 `export` 到 shell：

| 变量 | 说明 |
| --- | --- |
| `DASHSCOPE_API_KEY` | 百炼/灵积 API Key（**必需**） |
| `GH_TOKEN` | GitHub Personal Access Token（**沙盒环境必需**；`gh` CLI 会自动读取此变量进行认证。最低权限：`public_repo`；若需关单/评论：`repo`） |
| `DASHSCOPE_MODEL` | 模型名，默认 `qwen3.6-max-preview` |
| `DASHSCOPE_HTTP_BASE_URL` | 可选；兼容模式 API 根 |
| `LOONGSWEEPER_TARGET_REPO_DIR` | 可选；上游克隆路径，默认 `../loongcollector` |
| `LOONGSWEEPER_LOG_FILE` | 可选；日志文件路径，默认 `loongsweeper.log.jsonl` |
| `LOONGCOLLECTOR_GH_READ_TOKEN` | 可选；上游只读 token |
| `LOONGCOLLECTOR_GH_WRITE_TOKEN` | 可选；上游读写 token（关单/评论） |

## 子命令

### check — 验证环境
```bash
node loongsweeper.js check
```

### plan — 规划审查候选
```bash
node loongsweeper.js plan --batch-size 5 --shard-count 1 --max-pages 10
```
输出 JSON，包含分片矩阵和候选 Issue/PR 列表。

### review — AI 审查
```bash
# 审查单个
node loongsweeper.js review --item-number 12345 \
  --loongcollector-dir ../loongcollector --readonly-loongcollector \
  --artifact-dir ./artifacts --shard-index 0 --shard-count 1

# 批量审查（按 plan 输出的分片）
node loongsweeper.js review --item-numbers 111,222,333 \
  --loongcollector-dir ../loongcollector --readonly-loongcollector \
  --artifact-dir ./artifacts --shard-index 0 --shard-count 1
```
产物输出到 `--artifact-dir`，每个 Issue/PR 一份 `.md` 报告。

### apply-artifacts — 合并审查产物到本仓库
```bash
node loongsweeper.js apply-artifacts --artifact-dir ./artifacts
```

### reconcile / dashboard — 对账与仪表盘
```bash
node loongsweeper.js reconcile
node loongsweeper.js dashboard
```

### audit — 审计一致性
```bash
node loongsweeper.js audit --max-pages 50
```

### apply-decisions — 同步评论/关单到 GitHub（需写权限）
```bash
node loongsweeper.js apply-decisions --sync-comments-only --item-numbers 12345 --limit 5
```
**警告**：此命令会写 GitHub。未经明确授权，禁止执行。

## 实时日志

每次运行自动生成 `loongsweeper.log.jsonl`（JSONL 格式，逐条追加）。每行一条 JSON：

```json
{"ts":"2026-04-28T12:00:00.000Z","elapsed_ms":1234,"phase":"review","event":"item_done","item":2084,"progress":"3/5","detail":{"decision":"keep_open","confidence":"high"}}
```

| 字段 | 说明 |
| --- | --- |
| `ts` | ISO 8601 时间戳 |
| `elapsed_ms` | 从命令启动到本条日志的毫秒数 |
| `phase` | 当前阶段（`plan`/`review`/`apply`/`gh` 等） |
| `event` | 事件（`start`/`finish`/`item_start`/`llm_call_start`/`llm_call_done`/`item_done`/`retry` 等） |
| `progress` | 进度，如 `3/5` 或 `closed=2/20 processed=10/50` |
| `item` | 正在处理的 Issue/PR 编号 |
| `detail` | 操作详情（决策结果、模型参数、重试信息等） |

**判断是否卡住**：读取最后一行，若 `elapsed_ms` 仍在增长且 `event` 非 `"finish"`，说明正常运行中。

## 安全规则

- **未经明确授权，禁止执行 `apply-decisions` 关单命令**
- 维护者撰写或带保护标签（`security`/`beta-blocker`/`release-blocker`/`maintainer`）的条目不可自动关闭
- 审查对上游目录只读（`--readonly-loongcollector`）
- 建议先用 `--sync-comments-only` 小批量验证

## 故障排查

| 现象 | 解决 |
| --- | --- |
| `gh` 报错未认证 | 沙盒中无法用 `gh auth login`，须在 `.env` 中设置 `GH_TOKEN=ghp_xxx`（PAT），或 `export GH_TOKEN=ghp_xxx` |
| 百炼报错 | 检查 `DASHSCOPE_API_KEY` 和网络 |
| 找不到上游路径 | 传入 `--loongcollector-dir` 指向克隆目录 |
| 命令似乎卡住 | `tail -1 loongsweeper.log.jsonl` 查看最新日志 |
| Node 版本不够 | 需要 Node.js >= 24 |
