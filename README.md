# LoongCollectorSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化：为每个待处理 Issue/PR 生成 Markdown 报告，在证据充分时提议关闭，并在 **apply** 阶段同步持久化审查评论。

- **目标仓库**：`alibaba/loongcollector`
- **本报告仓库**：`iLogtail/LoongCollectorSweeper`（`items/`、`closed/`、README 仪表盘）
- **审查模型**：阿里云百炼 / DashScope（兼容 OpenAI Chat Completions），**不再使用 Codex CLI**

## 仪表盘

上次仪表盘更新：（由 `npm run dashboard` 或 Actions 写入）

### 当前运行

<!-- clawsweeper-status:start -->
**工作流状态**

更新时间：（待写入）

状态：空闲

尚未发布工作流状态。
<!-- clawsweeper-status:end -->

### 队列

| 指标 | 数量 |
| --- | ---: |
| [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 开放 Issue | — |
| [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 开放 PR | — |
| 开放条目合计 | — |
| 已审查文件 | — |
| 尚未审查的开放条目 | — |
| 归档的 closed 文件 | — |

### 审查结果

| 指标 | 数量 |
| --- | ---: |
| 近 7 天新审查 Issue | — |
| 提议关闭 Issue | — |
| 近 7 天新审查 PR | — |
| 提议关闭 PR | — |
| 近 7 天已验证审查 | — |
| 待 apply 的提议关闭 | — |
| 已由 apply 关闭 | — |
| 失败或陈旧审查 | — |

### 节奏

| 指标 | 覆盖 |
| --- | ---: |
| 每小时节奏 | — |
| 热点每小时节奏（<7 天） | — |
| 每日节奏 | — |
| 每日 PR 节奏 | — |
| 每日新 Issue 节奏（<30 天） | — |
| 每周陈旧 Issue 节奏 | — |
| 节奏维度待办合计 | — |

### 审计健康

<!-- clawsweeper-audit:start -->
尚未发布审计结果。运行 `npm run audit -- --update-dashboard` 可刷新本段。
<!-- clawsweeper-audit:end -->

### 最近运行动态

（由 Actions 更新）

### 最近关闭

| 条目 | 标题 | 原因 | 关闭时间 | 报告 |
| --- | --- | --- | --- | --- |
| _无_ |  |  |  |  |

<details>
<summary>最近审查（最多 10 条）</summary>

<br>

| 条目 | 标题 | 结果 | 状态 | 审查时间 |
| --- | --- | --- | --- | --- |
| _无_ |  |  |  |  |

</details>

## 使用说明

### 秘钥与配置（GitHub Actions / 本地）

本地可在仓库根目录放 **`.env`**（与 `package.json` 同级，已加入 `.gitignore`）：复制 [`.env.example`](.env.example) 为 `.env` 后填写。程序启动时会从该文件加载环境变量，**无需**每次在 shell 里 `export`（`npm run` 各脚本同样会加载）。

| 名称 | 说明 |
| --- | --- |
| `DASHSCOPE_API_KEY` | 百炼/灵积 API Key（**必需**，审查） |
| `DASHSCOPE_MODEL` | 模型名，默认 `qwen-plus` |
| `DASHSCOPE_HTTP_BASE_URL` | 可选；完整兼容根，默认 `https://dashscope.aliyuncs.com/compatible-mode/v1` |
| `LOONGSWEEPER_DOCS_URL` | 可选；公开文档根，默认指向本组织中文文档树 |
| `LOONGSWEEPER_TARGET_REPO_DIR` / `LOONGCOLLECTOR_LOCAL_DIR` | 可选；本机 `loongcollector` 克隆路径；不设则 `../loongcollector`；命令行 `--loongcollector-dir` 等**优先** |
| `LOONGCOLLECTOR_GH_READ_TOKEN` | 读上游 Issue/PR |
| `LOONGCOLLECTOR_GH_WRITE_TOKEN` | 写评论/关闭上游；写本仓库 README/items 需相应权限 |

### 本地命令

```bash
npm install
npm run build
npm run test:unit
npm run check
```

**子命令、环境变量与传参说明**（含 `npm run … -- --参数` 写法）见：**[本地运行指南](docs/local-run.md)**。  
**全量审查、合并产物、更新本仓库并可选对上游关单/评论的推荐顺序**见：**[全量工作流](docs/full-sweep-workflow.md)**。

审查需本地克隆 `alibaba/loongcollector` 至默认路径 `../loongcollector`，或使用 `--loongcollector-dir` / `--target-repo-dir` / `--openclaw-dir`（兼容旧参数）。

### 与上游的关系

本工具逻辑 fork 自 OpenClaw 生态的 ClawSweeper，已替换为 LoongCollector 目标仓库与百炼调用路径；历史 `items/`、`closed/` 已清空后请由 Actions 重新生成。
