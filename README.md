# LoongCollectorSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化：为每个待处理 Issue/PR 生成 Markdown 报告，在证据充分时提议关闭，并在 **apply** 阶段同步持久化审查评论。

- **目标仓库**：`alibaba/loongcollector`
- **本报告仓库**：`iLogtail/LoongCollectorSweeper`（`items/`、`closed/`、README 仪表盘）
- **审查模型**：阿里云百炼 / DashScope（兼容 OpenAI Chat Completions），**不再使用 Codex CLI**

## 仪表盘

上次仪表盘更新：2026年4月27日 UTC 09:11

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
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 Issue | 58 |
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 PR | 71 |
| 开放条目合计 | 129 |
| 已审查文件 | 49 |
| 尚未审查的开放条目 | 80 |
| 归档的 closed 文件 | 10 |

### 审查结果

| 指标 | 数量 |
| --- | ---: |
| 近 7 天新审查 Issue | 12 |
| 提议关闭 Issue | 0（占已审查 Issue 的 0%） |
| 近 7 天新审查 PR | 37 |
| 提议关闭 PR | 0（占已审查 PR 的 0%） |
| 近 7 天已验证审查 | 49 |
| 待 apply 的提议关闭 | 0（占新审查的 0%） |
| 已由 apply 关闭 | 10 |
| 失败或陈旧审查 | 0 |

### 节奏

| 指标 | 覆盖 |
| --- | ---: |
| 每小时节奏 | 0/0 当前（0 待办，-） |
| 热点每小时节奏（<7 天） | 0/0 当前（0 待办，-） |
| 每日节奏 | 38/38 当前（0 待办，100%） |
| 每日 PR 节奏 | 37/37 当前（0 待办，100%） |
| 每日新 Issue 节奏（<30 天） | 1/1 当前（0 待办，100%） |
| 每周陈旧 Issue 节奏 | 11/11 当前（0 待办，100%） |
| 节奏维度待办合计 | 80 |

### 审计健康

<!-- clawsweeper-audit:start -->
尚未发布审计结果。运行 `npm run audit -- --update-dashboard` 可刷新本段。
<!-- clawsweeper-audit:end -->

### 最近运行动态

最近审查：2026年4月27日 UTC 09:07。最近关闭：2026年4月27日 UTC 09:09。最近评论同步：2026年4月27日 UTC 09:11。

| 时间窗口 | 审查 | 关闭决策 | 保持开启 | 失败/陈旧 | 已关闭 | 评论已同步 | Apply 跳过 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 最近 15 分钟 | 6 | 4 | 2 | 0 | 7 | 20 | 0 |
| 最近 1 小时 | 26 | 7 | 19 | 0 | 7 | 40 | 0 |
| 最近 24 小时 | 59 | 10 | 49 | 0 | 10 | 59 | 0 |

### 最近关闭

| 条目 | 标题 | 原因 | 关闭时间 | 报告 |
| --- | --- | --- | --- | --- |
| [#1439](https://github.com/alibaba/loongcollector/issues/1439) | [FEATURE] sls_logs.proto建议定义成ms时间戳Again | 已在 main 上实现 | 2026年4月27日 UTC 09:09 | [closed/1439.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1439.md) |
| [#1414](https://github.com/alibaba/loongcollector/issues/1414) | [FEATURE]: 希望支持agent_id或者machine_uuid带在日志meta总进行上报 | 长期停滞且信息不足 | 2026年4月27日 UTC 09:09 | [closed/1414.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1414.md) |
| [#1221](https://github.com/alibaba/loongcollector/issues/1221) | [BUG]: _time_字段为空 | 长期停滞且信息不足 | 2026年4月27日 UTC 09:09 | [closed/1221.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1221.md) |
| [#1175](https://github.com/alibaba/loongcollector/issues/1175) | [DOC]: Add doc for metric_input_plugin | 已在 main 上实现 | 2026年4月27日 UTC 09:08 | [closed/1175.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1175.md) |
| [#900](https://github.com/alibaba/loongcollector/issues/900) | [FEATURE]: 希望支持采集 k8s events | 更适合插件/扩展生态（closeReason 仍为 clawhub） | 2026年4月27日 UTC 09:08 | [closed/900.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/900.md) |
| [#893](https://github.com/alibaba/loongcollector/issues/893) | [FEATURE]: 输出elastic的版本，兼容到7.9 | 长期停滞且信息不足 | 2026年4月27日 UTC 09:08 | [closed/893.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/893.md) |
| [#794](https://github.com/alibaba/loongcollector/issues/794) | [FEATURE]:iLogtail support s3 Flusher | 已在 main 上实现 | 2026年4月27日 UTC 09:08 | [closed/794.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/794.md) |
| [#1792](https://github.com/alibaba/loongcollector/pull/1792) | config server implement elasticsearch store mode | 重复或已被替代 | 2026年4月27日 UTC 07:14 | [closed/1792.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1792.md) |
| [#1546](https://github.com/alibaba/loongcollector/pull/1546) | feat: add self-monitor metrics for flusher_http | 重复或已被替代 | 2026年4月27日 UTC 07:14 | [closed/1546.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1546.md) |
| [#1515](https://github.com/alibaba/loongcollector/pull/1515) | set flusher flag first in case of logschain/aggregator queue full and flusher isready is always false | 已在 main 上实现 | 2026年4月27日 UTC 07:13 | [closed/1515.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1515.md) |

<details>
<summary>最近审查（最多 10 条）</summary>

<br>

| 条目 | 标题 | 结果 | 状态 | 审查时间 |
| --- | --- | --- | --- | --- |
| [#910](https://github.com/alibaba/loongcollector/issues/910) | [FEATURE]: 支持分级保障能力 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/910.md) | complete | 2026年4月27日 UTC 09:02 |
| [#553](https://github.com/alibaba/loongcollector/issues/553) | [BUG]: flusher_kafka_v2配置otlp报错 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/553.md) | complete | 2026年4月27日 UTC 08:59 |
| [#793](https://github.com/alibaba/loongcollector/issues/793) | [FEATURE]: iLogtail support oss Flusher | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/793.md) | complete | 2026年4月27日 UTC 08:50 |
| [#204](https://github.com/alibaba/loongcollector/issues/204) | [FEATURE]: add mqtt flusher plugin | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/204.md) | complete | 2026年4月27日 UTC 08:49 |
| [#2547](https://github.com/alibaba/loongcollector/issues/2547) | [QUESTION]:What versions of containerd does loongCollector support? | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2547.md) | complete | 2026年4月27日 UTC 08:45 |
| [#1273](https://github.com/alibaba/loongcollector/issues/1273) | [ENHANCEMENT]: flusher 报错不明显 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1273.md) | complete | 2026年4月27日 UTC 08:43 |
| [#918](https://github.com/alibaba/loongcollector/issues/918) | [FEATURE]:希望采集端有监控采集服务是否异常退出，重启的进程以及升级采集服务进程的能力 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/918.md) | complete | 2026年4月27日 UTC 08:41 |
| [#754](https://github.com/alibaba/loongcollector/issues/754) | [FEATURE]:ilogtail 增加ExternalK8sAnnotationsTag 参数支持通过容器的原数据annotations 中的字段追加到日志采集中 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/754.md) | complete | 2026年4月27日 UTC 08:37 |
| [#2522](https://github.com/alibaba/loongcollector/pull/2522) | add nano seconds support in LogFileReader and protocol converter | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2522.md) | complete | 2026年4月27日 UTC 08:34 |
| [#1236](https://github.com/alibaba/loongcollector/issues/1236) | [FEATURE]: Support S3/OSS Flusher | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1236.md) | complete | 2026年4月27日 UTC 08:32 |

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
