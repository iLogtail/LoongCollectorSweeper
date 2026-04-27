# LoongCollectorSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化：为每个待处理 Issue/PR 生成 Markdown 报告，在证据充分时提议关闭，并在 **apply** 阶段同步持久化审查评论。

- **目标仓库**：`alibaba/loongcollector`
- **本报告仓库**：`iLogtail/LoongCollectorSweeper`（`items/`、`closed/`、README 仪表盘）
- **审查模型**：阿里云百炼 / DashScope（兼容 OpenAI Chat Completions），**不再使用 Codex CLI**

## 仪表盘

上次仪表盘更新：2026年4月27日 UTC 08:24

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
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 Issue | 65 |
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 PR | 71 |
| 开放条目合计 | 136 |
| 已审查文件 | 36 |
| 尚未审查的开放条目 | 100 |
| 归档的 closed 文件 | 3 |

### 审查结果

| 指标 | 数量 |
| --- | ---: |
| 近 7 天新审查 Issue | 0 |
| 提议关闭 Issue | 0（占已审查 Issue 的 -） |
| 近 7 天新审查 PR | 36 |
| 提议关闭 PR | 0（占已审查 PR 的 0%） |
| 近 7 天已验证审查 | 36 |
| 待 apply 的提议关闭 | 0（占新审查的 0%） |
| 已由 apply 关闭 | 3 |
| 失败或陈旧审查 | 0 |

### 节奏

| 指标 | 覆盖 |
| --- | ---: |
| 每小时节奏 | 0/0 当前（0 待办，-） |
| 热点每小时节奏（<7 天） | 0/0 当前（0 待办，-） |
| 每日节奏 | 36/36 当前（0 待办，100%） |
| 每日 PR 节奏 | 36/36 当前（0 待办，100%） |
| 每日新 Issue 节奏（<30 天） | 0/0 当前（0 待办，-） |
| 每周陈旧 Issue 节奏 | 0/0 当前（0 待办，-） |
| 节奏维度待办合计 | 100 |

### 审计健康

<!-- clawsweeper-audit:start -->
尚未发布审计结果。运行 `npm run audit -- --update-dashboard` 可刷新本段。
<!-- clawsweeper-audit:end -->

### 最近运行动态

最近审查：2026年4月27日 UTC 08:21。最近关闭：2026年4月27日 UTC 07:14。最近评论同步：2026年4月27日 UTC 08:24。

| 时间窗口 | 审查 | 关闭决策 | 保持开启 | 失败/陈旧 | 已关闭 | 评论已同步 | Apply 跳过 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 最近 15 分钟 | 8 | 0 | 8 | 0 | 0 | 20 | 0 |
| 最近 1 小时 | 20 | 0 | 20 | 0 | 0 | 20 | 0 |
| 最近 24 小时 | 39 | 3 | 36 | 0 | 3 | 39 | 0 |

### 最近关闭

| 条目 | 标题 | 原因 | 关闭时间 | 报告 |
| --- | --- | --- | --- | --- |
| [#1792](https://github.com/alibaba/loongcollector/pull/1792) | config server implement elasticsearch store mode | 重复或已被替代 | 2026年4月27日 UTC 07:14 | [closed/1792.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1792.md) |
| [#1546](https://github.com/alibaba/loongcollector/pull/1546) | feat: add self-monitor metrics for flusher_http | 重复或已被替代 | 2026年4月27日 UTC 07:14 | [closed/1546.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1546.md) |
| [#1515](https://github.com/alibaba/loongcollector/pull/1515) | set flusher flag first in case of logschain/aggregator queue full and flusher isready is always false | 已在 main 上实现 | 2026年4月27日 UTC 07:13 | [closed/1515.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1515.md) |

<details>
<summary>最近审查（最多 10 条）</summary>

<br>

| 条目 | 标题 | 结果 | 状态 | 审查时间 |
| --- | --- | --- | --- | --- |
| [#2496](https://github.com/alibaba/loongcollector/pull/2496) | feat: selfmonitor metrics support dynamic labels and gc | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2496.md) | complete | 2026年4月27日 UTC 08:21 |
| [#2359](https://github.com/alibaba/loongcollector/pull/2359) | Process optimize | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2359.md) | complete | 2026年4月27日 UTC 08:19 |
| [#2294](https://github.com/alibaba/loongcollector/pull/2294) | test: add mem and cpu chaos injection in e2e engine | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2294.md) | complete | 2026年4月27日 UTC 08:17 |
| [#2247](https://github.com/alibaba/loongcollector/pull/2247) | Add support to Process Collector | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2247.md) | complete | 2026年4月27日 UTC 08:15 |
| [#2208](https://github.com/alibaba/loongcollector/pull/2208) | Support json encoding when converter protocol is raw (#2207) | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2208.md) | complete | 2026年4月27日 UTC 08:14 |
| [#2487](https://github.com/alibaba/loongcollector/pull/2487) | fix(plugins/metric_system_v2): report fd metrics as string to avoid float64 precision loss | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2487.md) | complete | 2026年4月27日 UTC 08:12 |
| [#2325](https://github.com/alibaba/loongcollector/pull/2325) | feat: add two new tags implementation based on slice | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2325.md) | complete | 2026年4月27日 UTC 08:11 |
| [#2268](https://github.com/alibaba/loongcollector/pull/2268) | feat: support dynamic label values and global metrics record. | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2268.md) | complete | 2026年4月27日 UTC 08:09 |
| [#2228](https://github.com/alibaba/loongcollector/pull/2228) | fix: improve the judgment of the legitimacy of prometheus metrics | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2228.md) | complete | 2026年4月27日 UTC 08:07 |
| [#2151](https://github.com/alibaba/loongcollector/pull/2151) | add flusher plugin for datahub & odps. (#2144) | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2151.md) | complete | 2026年4月27日 UTC 08:05 |

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
一键执行：`npm run sweep:local`（可加 `-- --dry-run` 等，见该文档「一键脚本」）。

审查需本地克隆 `alibaba/loongcollector` 至默认路径 `../loongcollector`，或使用 `--loongcollector-dir` / `--target-repo-dir` / `--openclaw-dir`（兼容旧参数）。

### 与上游的关系

本工具逻辑 fork 自 OpenClaw 生态的 ClawSweeper，已替换为 LoongCollector 目标仓库与百炼调用路径；历史 `items/`、`closed/` 已清空后请由 Actions 重新生成。
