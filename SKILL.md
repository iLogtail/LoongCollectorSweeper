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
---

# LoongSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化工具：为每个待处理 Issue/PR 生成结构化审查报告，在证据充分时提议关闭，并可同步持久化审查评论。

## 能力概述

- **plan**：扫描上游仓库开放 Issue/PR，规划审查候选与分片矩阵
- **review**：拉取 GitHub 上下文、调用阿里云百炼 AI 模型生成结构化审查报告
- **apply-artifacts**：将审查产物合并进本仓库的 `items/` 与 `closed/`
- **apply-decisions**：按报告在 GitHub 上同步评论或关单（会改远程，需授权）
- **reconcile**：根据线上开放/关闭状态整理本地记录
- **dashboard**：根据本地报告刷新 README 仪表盘
- **status**：更新 README 中的工作流状态块
- **audit**：对比线上与本地记录一致性
- **check**：快速验证环境配置是否就绪

## 前置条件

| 项目 | 要求 |
| --- | --- |
| **Node.js** | ≥ 24 |
| **GitHub CLI `gh`** | 已安装并登录，能访问 `alibaba/loongcollector` |
| **百炼 API Key** | 环境变量 `DASHSCOPE_API_KEY` 已配置 |
| **上游源码** | 本地克隆 `alibaba/loongcollector`（默认路径 `../loongcollector`） |

## 安装

从 [GitHub Release](https://github.com/iLogtail/LoongCollectorSweeper/releases) 下载最新 `loongsweeper-<version>.zip`，解压即可使用：

```bash
unzip loongsweeper-<version>.zip
cd loongsweeper
```

目录结构：
```
loongsweeper/
├── SKILL.md          # 本文件
├── loongsweeper.js   # 单文件 bundle，无需 npm install
└── .env.example      # 环境变量模板
```

## 环境配置

复制 `.env.example` 为 `.env` 并填写：

```ini
DASHSCOPE_API_KEY=你的百炼API_Key
DASHSCOPE_MODEL=qwen3.6-max-preview
# LOONGSWEEPER_TARGET_REPO_DIR=../loongcollector
```

或通过环境变量导出：

```bash
export DASHSCOPE_API_KEY="你的Key"
```

### 环境变量一览

| 变量 | 说明 |
| --- | --- |
| `DASHSCOPE_API_KEY` | 百炼/灵积 API Key（**必需**） |
| `DASHSCOPE_MODEL` | 模型名，默认 `qwen3.6-max-preview` |
| `DASHSCOPE_HTTP_BASE_URL` | 可选；兼容模式 API 根 |
| `LOONGSWEEPER_TARGET_REPO_DIR` | 可选；上游克隆路径，默认 `../loongcollector` |
| `LOONGSWEEPER_DOCS_URL` | 可选；公开文档根 |
| `LOONGSWEEPER_LOG_FILE` | 可选；日志文件路径，默认 `loongsweeper.log.jsonl` |
| `LOONGCOLLECTOR_GH_READ_TOKEN` | 可选；上游只读 token |
| `LOONGCOLLECTOR_GH_WRITE_TOKEN` | 可选；上游读写 token（关单/评论） |

## 子命令一览

```bash
# 验证环境
node loongsweeper.js check

# 规划审查候选
node loongsweeper.js plan --batch-size 5 --shard-count 4 --max-pages 250

# 审查单个 Issue（产物输出到临时目录）
node loongsweeper.js review \
  --item-number 12345 \
  --loongcollector-dir ../loongcollector \
  --readonly-loongcollector \
  --artifact-dir ./tmp-review \
  --shard-index 0 \
  --shard-count 1

# 合并审查产物到本仓库
node loongsweeper.js apply-artifacts --artifact-dir ./tmp-review

# 对账与仪表盘
node loongsweeper.js reconcile
node loongsweeper.js dashboard

# 审计一致性
node loongsweeper.js audit --max-pages 50

# 同步评论到 GitHub（需写权限）
node loongsweeper.js apply-decisions \
  --sync-comments-only \
  --item-numbers 12345 \
  --limit 5
```

## 本地完整工作流

推荐顺序：

1. **配置环境**：确保 `gh auth login` 已完成、`.env` 已填写
2. **克隆上游**：`git clone https://github.com/alibaba/loongcollector.git ../loongcollector`
3. **规划**：`node loongsweeper.js plan --batch-size 5 --shard-count 1 --max-pages 10`
4. **审查**：`node loongsweeper.js review --shard-index 0 --shard-count 1 --artifact-dir ./artifacts --readonly-loongcollector`
5. **合并产物**：`node loongsweeper.js apply-artifacts --artifact-dir ./artifacts`
6. **对账**：`node loongsweeper.js reconcile && node loongsweeper.js dashboard`
7. **自检**：查看 `items/*.md` 中的 decision 与 summary

如需对上游写评论/关单，使用 `apply-decisions`（需配置写权限 token）。

## 常用参数

| 参数 | 说明 |
| --- | --- |
| `--item-number` | 只处理单个 Issue/PR 编号 |
| `--item-numbers` | 逗号分隔多个编号 |
| `--batch-size` | 批大小（默认 5） |
| `--shard-index` / `--shard-count` | 分片索引与总数 |
| `--max-pages` | 扫描开放列表最大页数（默认 250） |
| `--hot-intake` | 启用热点快速审查 |
| `--loongcollector-dir` / `--target-repo-dir` | 上游仓库路径 |
| `--readonly-loongcollector` | 将上游目录设为只读 |
| `--artifact-dir` | 审查产物输出目录 |
| `--log-file` | 结构化日志文件路径（默认 `loongsweeper.log.jsonl`） |
| `--bailian-timeout-ms` | 单条百炼请求超时（默认 600000ms） |

## 实时日志（审计 & 进度监控）

每次运行会在工作目录生成 `loongsweeper.log.jsonl`（可通过 `--log-file` 或 `LOONGSWEEPER_LOG_FILE` 自定义路径）。每行一条 JSON 记录，格式：

```json
{"ts":"2026-04-28T12:00:00.000Z","elapsed_ms":1234,"phase":"review","event":"item_done","item":2084,"progress":"3/5","detail":{"decision":"keep_open","confidence":"high","action":"kept_open"}}
```

| 字段 | 说明 |
| --- | --- |
| `ts` | ISO 8601 时间戳 |
| `elapsed_ms` | 从命令启动到本条日志的毫秒数 |
| `phase` | 当前阶段（`plan`/`review`/`apply`/`apply-artifacts`/`audit`/`reconcile`/`gh`） |
| `event` | 事件类型（`start`/`finish`/`candidates_selected`/`item_start`/`llm_call_start`/`llm_call_done`/`llm_call_error`/`item_done`/`complete`/`retry` 等） |
| `progress` | 进度字符串，如 `3/5` 或 `closed=2/20 processed=10/50` |
| `item` | 正在处理的 Issue/PR 编号（如适用） |
| `detail` | 操作详情（决策结果、模型参数、重试信息等） |

**实时读取进度**：日志是逐条追加的，可在运行过程中用 `tail -f loongsweeper.log.jsonl` 或读取文件最后几行来获取最新进度，判断命令是否仍在正常执行。

## 安全规则

- **未经明确授权，禁止执行会写 GitHub 的 apply/close 命令**
- 维护者撰写或带保护标签的条目视为**不可自动关闭**
- 审查对上游目录**只读**，在审查前后检测工作区是否被污染
- 子进程环境剥离敏感 token，降低泄漏风险
- 建议先用 `--sync-comments-only` 小批量验证，确认无问题后再执行关单

## 故障排查

- **`gh` 报错未认证**：执行 `gh auth login`
- **百炼报错**：检查 `DASHSCOPE_API_KEY`、`DASHSCOPE_MODEL` 与网络
- **找不到上游路径**：显式传入 `--loongcollector-dir` 指向你的克隆目录
- **日志异常**：检查 `loongsweeper.log.jsonl` 最后几行，最近的 `event` 和 `elapsed_ms` 可判断是否卡住
- **Node 版本不够**：本工具要求 Node.js ≥ 24
