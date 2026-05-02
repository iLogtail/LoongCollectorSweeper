# LoongCollectorSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化：为每个待处理 Issue/PR 生成 Markdown 报告，在证据充分时提议关闭，并在 **apply** 阶段同步持久化审查评论。

- **目标仓库**：`alibaba/loongcollector`
- **本报告仓库**：`iLogtail/LoongCollectorSweeper`（`items/`、`closed/`、README 仪表盘）
- **审查模型**：阿里云百炼 / DashScope（兼容 OpenAI Chat Completions），**不再使用 Codex CLI**

## 仪表盘

上次仪表盘更新：2026年5月2日 UTC 11:06

### 当前运行

<!-- loongsweeper-status:start -->
**工作流状态**

更新时间：2026年5月2日 UTC 11:06

状态：审查进行中

已规划 2 条，分片 2，容量 500。审查分片将启动，完成后由 publish 合并产物。
运行链接：[https://github.com/iLogtail/LoongCollectorSweeper/actions/runs/25250513705](https://github.com/iLogtail/LoongCollectorSweeper/actions/runs/25250513705)
<!-- loongsweeper-status:end -->

### 队列

| 指标 | 数量 |
| --- | ---: |
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 Issue | 47 |
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 PR | 73 |
| 开放条目合计 | 120 |
| 已审查文件 | 67 |
| 尚未审查的开放条目 | 53 |
| 归档的 closed 文件 | 21 |

### 审查结果

| 指标 | 数量 |
| --- | ---: |
| 近 7 天新审查 Issue | 28 |
| 提议关闭 Issue | 0（占已审查 Issue 的 0%） |
| 近 7 天新审查 PR | 39 |
| 提议关闭 PR | 0（占已审查 PR 的 0%） |
| 近 7 天已验证审查 | 67 |
| 待 apply 的提议关闭 | 0（占新审查的 0%） |
| 已由 apply 关闭 | 20 |
| 失败或陈旧审查 | 0 |

### 节奏

| 指标 | 覆盖 |
| --- | ---: |
| 每小时节奏 | 0/2 当前（2 待办，0%） |
| 热点每小时节奏（<7 天） | 0/2 当前（2 待办，0%） |
| 每日节奏 | 37/37 当前（0 待办，100%） |
| 每日 PR 节奏 | 37/37 当前（0 待办，100%） |
| 每日新 Issue 节奏（<30 天） | 0/0 当前（0 待办，-） |
| 每周陈旧 Issue 节奏 | 28/28 当前（0 待办，100%） |
| 节奏维度待办合计 | 55 |

### 审计健康

<!-- loongsweeper-audit:start -->
上次审计：2026年5月2日 UTC 07:57

状态：**正常**

| 指标 | 数量 |
| --- | ---: |
| 扫描完成 | 是 |
| 已见开放条目 | 120 |
| 缺少符合条件开放记录 | 0 |
| 缺少维护者开放记录 | 53 |
| 缺少受保护开放记录 | 0 |
| 缺少近期创建开放记录 | 0 |
| 归档记录再次打开 | 0 |
| 陈旧条目记录 | 0 |
| 重复记录 | 0 |
| 受保护提议关闭 | 0 |
| 陈旧审查 | 0 |

| 条目 | 类别 | 标题 | 详情 |
| --- | --- | --- | --- |
| _无_ |  |  |  |
<!-- loongsweeper-audit:end -->

### 最近运行动态

最近审查：2026年5月2日 UTC 09:20。最近关闭：2026年4月28日 UTC 12:14。最近评论同步：2026年5月2日 UTC 09:21。

| 时间窗口 | 审查 | 关闭决策 | 保持开启 | 失败/陈旧 | 已关闭 | 评论已同步 | Apply 跳过 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 最近 15 分钟 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 最近 1 小时 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| 最近 24 小时 | 39 | 0 | 39 | 0 | 0 | 39 | 0 |

### 最近关闭

| 条目 | 标题 | 原因 | 关闭时间 | 报告 |
| --- | --- | --- | --- | --- |
| [#2452](https://github.com/alibaba/loongcollector/issues/2452) | 输出插件不支持infuxdb吗 | 更适合插件/扩展生态 | 2026年4月28日 UTC 12:14 | [closed/2452.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2452.md) |
| [#2533](https://github.com/alibaba/loongcollector/issues/2533) | [ENHANCEMENT]:flusher_kafka_v2输出插件, 账号密码支持从环境变量中获取 | 已在 main 上实现 | 2026年4月27日 UTC 11:00 | [closed/2533.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2533.md) |
| [#2311](https://github.com/alibaba/loongcollector/issues/2311) | [BUG]: The HasKeys configuration parameter for flusher_kafka_v2 to specify partitions is invalid | 已在 main 上实现 | 2026年4月27日 UTC 10:50 | [closed/2311.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2311.md) |
| [#2303](https://github.com/alibaba/loongcollector/issues/2303) | [QUESTION]: I collect pod log to loki，but Convert failed in  using DynamicLabels | 本仓库内无法落地 | 2026年4月27日 UTC 09:53 | [closed/2303.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2303.md) |
| [#2218](https://github.com/alibaba/loongcollector/issues/2218) | [FEATURE]: Support flush trace data to langfuse | 更适合插件/扩展生态 | 2026年4月27日 UTC 09:53 | [closed/2218.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2218.md) |
| [#2192](https://github.com/alibaba/loongcollector/issues/2192) | [QUESTION]:有没有 metric 可以监控没来得及收集的日志文件 | 本仓库内无法落地 | 2026年4月27日 UTC 09:53 | [closed/2192.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2192.md) |
| [#2168](https://github.com/alibaba/loongcollector/issues/2168) | [BUG]:seelog overflow | 长期停滞且信息不足 | 2026年4月27日 UTC 09:53 | [closed/2168.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2168.md) |
| [#2166](https://github.com/alibaba/loongcollector/issues/2166) | [QUESTION]: 是否可以支持unixsocket接收日志做转发？ | 更适合插件/扩展生态 | 2026年4月27日 UTC 09:52 | [closed/2166.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2166.md) |
| [#2124](https://github.com/alibaba/loongcollector/issues/2124) | [FEATURE]:k8s支持声明式采集 | 已在 main 上实现 | 2026年4月27日 UTC 09:52 | [closed/2124.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2124.md) |
| [#2084](https://github.com/alibaba/loongcollector/issues/2084) | [FEATURE]: Flusher plugin for Apache Doris | 重复或已被替代 | 2026年4月27日 UTC 09:52 | [closed/2084.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2084.md) |

<details>
<summary>最近审查（最多 10 条）</summary>

<br>

| 条目 | 标题 | 结果 | 状态 | 审查时间 |
| --- | --- | --- | --- | --- |
| [#2556](https://github.com/alibaba/loongcollector/pull/2556) | feat(input): add service_dns_etw plugin for Windows DNS Analytical ETW | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2556.md) | complete | 2026年5月2日 UTC 09:20 |
| [#2555](https://github.com/alibaba/loongcollector/pull/2555) | agentsight loongcollector代码首次提交 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2555.md) | complete | 2026年5月2日 UTC 09:20 |
| [#1772](https://github.com/alibaba/loongcollector/pull/1772) | feat: upgrade go kafka client sarama version v1.42.2 to v1.43.3 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1772.md) | complete | 2026年5月1日 UTC 15:19 |
| [#2359](https://github.com/alibaba/loongcollector/pull/2359) | Process optimize | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2359.md) | complete | 2026年5月1日 UTC 15:18 |
| [#2325](https://github.com/alibaba/loongcollector/pull/2325) | feat: add two new tags implementation based on slice | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2325.md) | complete | 2026年5月1日 UTC 15:18 |
| [#2228](https://github.com/alibaba/loongcollector/pull/2228) | fix: improve the judgment of the legitimacy of prometheus metrics | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2228.md) | complete | 2026年5月1日 UTC 15:18 |
| [#2214](https://github.com/alibaba/loongcollector/pull/2214) | Add processor_add_fields_v2 plugin | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2214.md) | complete | 2026年5月1日 UTC 15:18 |
| [#1864](https://github.com/alibaba/loongcollector/pull/1864) | test: go to cpp PipelineEventGroup transfer | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1864.md) | complete | 2026年5月1日 UTC 15:18 |
| [#2322](https://github.com/alibaba/loongcollector/pull/2322) | [for testing AI review] unified epoll for ebpf  | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2322.md) | complete | 2026年5月1日 UTC 15:18 |
| [#2247](https://github.com/alibaba/loongcollector/pull/2247) | Add support to Process Collector | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2247.md) | complete | 2026年5月1日 UTC 15:18 |

</details>

## 使用说明

### 秘钥与配置（GitHub Actions / 本地）

本地可在仓库根目录放 **`.env`**（与 `package.json` 同级，已加入 `.gitignore`）：复制 [`.env.example`](.env.example) 为 `.env` 后填写。程序启动时会从该文件加载环境变量，**无需**每次在 shell 里 `export`（`npm run` 各脚本同样会加载）。

| 名称 | 说明 |
| --- | --- |
| `DASHSCOPE_API_KEY` | 百炼/灵积 API Key（**必需**，审查） |
| `DASHSCOPE_MODEL` | 模型名，默认 `qwen3.6-max-preview` |
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

审查需本地克隆 `alibaba/loongcollector` 至默认路径 `../loongcollector`，或使用 `--loongcollector-dir` / `--target-repo-dir`。

### 与上游的关系

本工具逻辑 fork 自 OpenClaw 生态的 ClawSweeper，已替换为 LoongCollector 目标仓库与百炼调用路径，所有 claw 相关命名已重命名为 loong 系列；历史 `items/`、`closed/` 已清空后请由 Actions 重新生成。
