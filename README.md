# LoongCollectorSweeper

面向 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector) 的保守维护自动化：为每个待处理 Issue/PR 生成 Markdown 报告，在证据充分时提议关闭，并在 **apply** 阶段同步持久化审查评论。

- **目标仓库**：`alibaba/loongcollector`
- **本报告仓库**：`iLogtail/LoongCollectorSweeper`（`items/`、`closed/`、README 仪表盘）
- **审查模型**：阿里云百炼 / DashScope（兼容 OpenAI Chat Completions），**不再使用 Codex CLI**

## 仪表盘

上次仪表盘更新：2026年4月28日 UTC 11:19

### 当前运行

<!-- loongsweeper-status:start -->
**工作流状态**

更新时间：2026年4月28日 UTC 11:19

状态：热点发布完成

已合并 run 25049653738 的 热点 产物；reconcile 已与 GitHub 开放/关闭状态对齐，仪表盘已更新。
运行链接：[https://github.com/iLogtail/LoongCollectorSweeper/actions/runs/25049653738](https://github.com/iLogtail/LoongCollectorSweeper/actions/runs/25049653738)
<!-- loongsweeper-status:end -->

### 队列

| 指标 | 数量 |
| --- | ---: |
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 Issue | 49 |
| [alibaba/loongcollector](https://github.com/alibaba/loongcollector) 开放 PR | 71 |
| 开放条目合计 | 120 |
| 已审查文件 | 67 |
| 尚未审查的开放条目 | 53 |
| 归档的 closed 文件 | 19 |

### 审查结果

| 指标 | 数量 |
| --- | ---: |
| 近 7 天新审查 Issue | 0 |
| 提议关闭 Issue | 0（占已审查 Issue 的 -） |
| 近 7 天新审查 PR | 20 |
| 提议关闭 PR | 0（占已审查 PR 的 0%） |
| 近 7 天已验证审查 | 20 |
| 待 apply 的提议关闭 | 0（占新审查的 0%） |
| 已由 apply 关闭 | 19 |
| 失败或陈旧审查 | 47 |

### 节奏

| 指标 | 覆盖 |
| --- | ---: |
| 每小时节奏 | 0/0 当前（0 待办，-） |
| 热点每小时节奏（<7 天） | 0/0 当前（0 待办，-） |
| 每日节奏 | 20/38 当前（18 待办，52.6%） |
| 每日 PR 节奏 | 20/37 当前（17 待办，54.1%） |
| 每日新 Issue 节奏（<30 天） | 0/1 当前（1 待办，0%） |
| 每周陈旧 Issue 节奏 | 0/29 当前（29 待办，0%） |
| 节奏维度待办合计 | 100 |

### 审计健康

<!-- loongsweeper-audit:start -->
上次审计：2026年4月28日 UTC 10:11

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

最近审查：2026年4月28日 UTC 11:18。最近关闭：2026年4月27日 UTC 11:00。最近评论同步：2026年4月27日 UTC 11:00。

| 时间窗口 | 审查 | 关闭决策 | 保持开启 | 失败/陈旧 | 已关闭 | 评论已同步 | Apply 跳过 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 最近 15 分钟 | 20 | 0 | 20 | 0 | 0 | 0 | 0 |
| 最近 1 小时 | 20 | 0 | 20 | 0 | 0 | 0 | 0 |
| 最近 24 小时 | 67 | 0 | 67 | 47 | 0 | 0 | 0 |

### 最近关闭

| 条目 | 标题 | 原因 | 关闭时间 | 报告 |
| --- | --- | --- | --- | --- |
| [#2533](https://github.com/alibaba/loongcollector/issues/2533) | [ENHANCEMENT]:flusher_kafka_v2输出插件, 账号密码支持从环境变量中获取 | 已在 main 上实现 | 2026年4月27日 UTC 11:00 | [closed/2533.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2533.md) |
| [#2311](https://github.com/alibaba/loongcollector/issues/2311) | [BUG]: The HasKeys configuration parameter for flusher_kafka_v2 to specify partitions is invalid | 已在 main 上实现 | 2026年4月27日 UTC 10:50 | [closed/2311.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2311.md) |
| [#2303](https://github.com/alibaba/loongcollector/issues/2303) | [QUESTION]: I collect pod log to loki，but Convert failed in  using DynamicLabels | 本仓库内无法落地 | 2026年4月27日 UTC 09:53 | [closed/2303.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2303.md) |
| [#2218](https://github.com/alibaba/loongcollector/issues/2218) | [FEATURE]: Support flush trace data to langfuse | 更适合插件/扩展生态 | 2026年4月27日 UTC 09:53 | [closed/2218.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2218.md) |
| [#2192](https://github.com/alibaba/loongcollector/issues/2192) | [QUESTION]:有没有 metric 可以监控没来得及收集的日志文件 | 本仓库内无法落地 | 2026年4月27日 UTC 09:53 | [closed/2192.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2192.md) |
| [#2168](https://github.com/alibaba/loongcollector/issues/2168) | [BUG]:seelog overflow | 长期停滞且信息不足 | 2026年4月27日 UTC 09:53 | [closed/2168.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2168.md) |
| [#2166](https://github.com/alibaba/loongcollector/issues/2166) | [QUESTION]: 是否可以支持unixsocket接收日志做转发？ | 更适合插件/扩展生态 | 2026年4月27日 UTC 09:52 | [closed/2166.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2166.md) |
| [#2124](https://github.com/alibaba/loongcollector/issues/2124) | [FEATURE]:k8s支持声明式采集 | 已在 main 上实现 | 2026年4月27日 UTC 09:52 | [closed/2124.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2124.md) |
| [#2084](https://github.com/alibaba/loongcollector/issues/2084) | [FEATURE]: Flusher plugin for Apache Doris | 重复或已被替代 | 2026年4月27日 UTC 09:52 | [closed/2084.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/2084.md) |
| [#1439](https://github.com/alibaba/loongcollector/issues/1439) | [FEATURE] sls_logs.proto建议定义成ms时间戳Again | 已在 main 上实现 | 2026年4月27日 UTC 09:09 | [closed/1439.md](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/closed/1439.md) |

<details>
<summary>最近审查（最多 10 条）</summary>

<br>

| 条目 | 标题 | 结果 | 状态 | 审查时间 |
| --- | --- | --- | --- | --- |
| [#885](https://github.com/alibaba/loongcollector/pull/885) | support send medata to config server | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/885.md) | complete | 2026年4月28日 UTC 11:18 |
| [#2081](https://github.com/alibaba/loongcollector/pull/2081) | Strips binary keep a static symbol table | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2081.md) | complete | 2026年4月28日 UTC 11:18 |
| [#1166](https://github.com/alibaba/loongcollector/pull/1166) | Feat oss flusher | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1166.md) | complete | 2026年4月28日 UTC 11:18 |
| [#1872](https://github.com/alibaba/loongcollector/pull/1872) | Multi-line parsing supports SIMD optimization | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1872.md) | complete | 2026年4月28日 UTC 11:18 |
| [#1947](https://github.com/alibaba/loongcollector/pull/1947) | feat: prom textparser with simd | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1947.md) | complete | 2026年4月28日 UTC 11:18 |
| [#1323](https://github.com/alibaba/loongcollector/pull/1323) | 开发文档修改 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1323.md) | complete | 2026年4月28日 UTC 11:18 |
| [#1819](https://github.com/alibaba/loongcollector/pull/1819) | bug: syslog parse in rfc3164 tag length limit is 32 | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1819.md) | complete | 2026年4月28日 UTC 11:18 |
| [#1854](https://github.com/alibaba/loongcollector/pull/1854) | flusher_stdout: print typed-value metric with type int and uint | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/1854.md) | complete | 2026年4月28日 UTC 11:18 |
| [#2051](https://github.com/alibaba/loongcollector/pull/2051) | e2e: prom metric check func | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2051.md) | complete | 2026年4月28日 UTC 11:18 |
| [#2151](https://github.com/alibaba/loongcollector/pull/2151) | add flusher plugin for datahub & odps. (#2144) | [keep_open / kept_open](https://github.com/iLogtail/LoongCollectorSweeper/blob/main/items/2151.md) | complete | 2026年4月28日 UTC 11:18 |

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
