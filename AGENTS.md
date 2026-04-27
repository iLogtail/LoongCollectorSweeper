# AGENTS.MD

LoongCollectorSweeper（本仓库）是面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化工具：证据充分才提议关闭，审查由**阿里云百炼（DashScope）**生成结构化 JSON。改动保持窄范围、可自动化、可审计。

## 仓库结构

- 主逻辑：[`src/clawsweeper.ts`](src/clawsweeper.ts)
- 测试：[`test/clawsweeper.test.mjs`](test/clawsweeper.test.mjs)
- GitHub Actions：[`.github/workflows/sweep.yml`](.github/workflows/sweep.yml)
- 仪表盘与说明：[README.md](README.md)
- 开放/已审记录：扁平 `items/<编号>.md`
- 归档：`closed/<编号>.md`
- 临时产物：`.artifacts/`、`artifacts/`、`apply-report.json`
- 本地环境变量：根目录 **`.env`**（由 [`.env.example`](.env.example) 复制；已忽略于 Git），启动时由 `dotenv` 加载。

保持 `items/` 与 `closed/` 扁平布局，不要按 Issue/PR 分子目录。

## 运行模式

- **Review**：仅生成/更新本地报告与提议，**不会**在 GitHub 上直接关闭条目。
- **Apply**：通过同步持久化审查评论，再对**未变更且高置信**的提议执行关闭。
- 并发以 **shard** 为界：每个 shard 内顺序处理；最大并行度约等于 `shard_count`（而非 `batch_size * shard_count`）。
- README 仪表盘为状态展示面；请以 **GitHub Actions 与远端 README** 为准，勿盲信本地时间戳。

## 安全规则

- **未经 Peter 明确要求，不要执行会真实写 GitHub 的 apply/close 命令。**
- 复现 apply 路径时：将单份报告拷到临时 `items/`，并传入 `--skip-dashboard`、`--item-number` 以及临时 `--closed-dir`。
- 维护者撰写或带保护标签的条目视为**不可自动关闭**。
- 快照或 `updated_at` 漂移会阻止 apply，除非唯一变更就是已有 Sweeper 审查评论。
- 已关闭又被作者重新打开、但曾被陈旧自动化锁定的 Issue 可能存在；须跳过而非令 apply 崩溃。
- 对锁定会话发表评论返回 403 时，视为**终态跳过**，不可当作可重试网络错误。

## 命令

```bash
npm install
npm run build
npm run test:unit
npm run format
npm run check
```

涉及代码/测试/工作流改动时，交接前请运行 `npm run check`。

## GitHub 便捷探针

```bash
gh run list --repo iLogtail/LoongCollectorSweeper --limit 20 --json databaseId,displayTitle,status,conclusion,createdAt,updatedAt
gh api repos/iLogtail/LoongCollectorSweeper/readme --jq '.content' | base64 --decode
gh api graphql -f query='query { repository(owner:"alibaba", name:"loongcollector") { issues(states: OPEN) { totalCount } pullRequests(states: OPEN) { totalCount } } }'
```

吞吐与默认参数请同时查看 [`src/clawsweeper.ts`](src/clawsweeper.ts) 与 [`.github/workflows/sweep.yml`](.github/workflows/sweep.yml)；continuation 路径否则会沿用旧默认值。

## 秘钥与环境变量（摘要）

- **`DASHSCOPE_API_KEY`**：百炼/灵积调用（审查必需）。
- **`LOONGCOLLECTOR_GH_READ_TOKEN` / `LOONGCOLLECTOR_GH_WRITE_TOKEN`**（或组织自定义名称）：对上游 `alibaba/loongcollector` 读/写 Issue、PR；写本报告仓库还需 `contents:write`。
- **`LOONGSWEEPER_DOCS_URL`**（可选）：公开文档根，默认指向本 fork 中文文档树。
- **`DASHSCOPE_MODEL`**、**`DASHSCOPE_HTTP_BASE_URL`**（可选）：模型与兼容模式 API 根路径。
