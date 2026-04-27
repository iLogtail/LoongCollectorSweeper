# 更新日志

本文件记录 **LoongCollectorSweeper** 的重要变更。本工具由 OpenClaw 生态下的 ClawSweeper fork 而来，目标仓库为 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector)，报告与仪表盘落在 [`iLogtail/LoongCollectorSweeper`](https://github.com/iLogtail/LoongCollectorSweeper)。

仪表盘心跳、检查点与仅状态类提交有意不写入本日志；若需细粒度历史，请以 Git 提交记录为准。

## [0.1.0] - 未发布

### 新增

- 以「保守维护」为目标的清扫机器人：为上游每个开放 Issue / Pull Request 生成一份 Markdown 审查记录。
- **仅提议**的审查流水线，以及独立的 **apply** 模式：仅对未变更且高置信的「提议关闭」执行关单与评论同步。
- 支持按单号 / 逗号分隔多号定向审查，便于排障与补审。
- README **仪表盘**：指向 `items/` 报告、证据与关单率、节奏覆盖、工作流状态、apply 状态等；保留 `<!-- clawsweeper-status:* -->` / `<!-- clawsweeper-audit:* -->` 锚点供自动化更新。
- 扁平 **`closed/`** 归档，使 **`items/`** 主要跟踪当前仍开放的条目。
- **`audit`** 只读命令：对照 GitHub 实时状态检查 `items/` 与 `closed/` 是否一致（致谢 @stainlu）。
- 审查报告中的运行元数据（模型等）；MIT 许可。
- **持久化审查评论**：在关单或同步前原地更新同一条自动化审查评论（现由百炼生成内容，历史兼容 Codex 文案识别）。
- 与审查并行的 **定时 / 手动 apply、仅评论同步** 等工作流路径。
- **约每 5 分钟的热点 intake** 审查分片，面向新建与近期活跃条目。
- **定向评论同步**：热点审查合并后可立即同步持久评论而无需关单。
- 评论同步与大批量 apply **并发组分离**，避免互相挤占。
- README **最近运行**统计：近期审查、关单决策、评论同步、apply 跳过、实际关单等计数。
- README **审计健康**区块及独立定时/手动任务，可在不触发全量审查的情况下刷新（致谢 @stainlu）。
- 支持逗号分隔的定向审查派发，便于按审计结果批量补审（致谢 @stainlu）。
- **阿里云百炼 / DashScope**：通过兼容 OpenAI Chat Completions 的 HTTP 接口调用模型，解析并校验符合 `schema/clawsweeper-decision.schema.json` 的 JSON；**不再依赖 Codex CLI**。
- 可配置文档根（如 `LOONGSWEEPER_DOCS_URL`）、默认中文文档树与插件生态说明链接；审查提示词 **`prompts/review-item.md`** 中文化并绑定 LoongCollector 边界。

### 变更

- 审查模型由 Codex/GPT 管线改为 **百炼**（默认模型可通过 `DASHSCOPE_MODEL` 等配置）。
- 目标仓库 **`alibaba/loongcollector`**，报告仓库 **`iLogtail/LoongCollectorSweeper`**；`gh` 默认 `--repo`、链接与正则均对齐上游。
- 本地 / CI 检出目录默认为 **`../loongcollector`**；CLI 推荐 **`--target-repo-dir` / `--loongcollector-dir`**，保留 **`--openclaw-dir`** 等旧参数别名。
- GitHub Actions：克隆 `alibaba/loongcollector`、缓存与 job 展示名中文化；Secrets 推荐使用 **`LOONGCOLLECTOR_GH_READ_TOKEN`** / **`LOONGCOLLECTOR_GH_WRITE_TOKEN`**（并保留对旧名的兼容回退）；审查 job 注入 **`DASHSCOPE_API_KEY`**。
- 工作流 `workflow_dispatch` 中单条超时参数改为 **`bailian_timeout_ms`**（代码侧仍兼容 `codex_timeout_ms` / `llm_timeout_ms`）。
- 提升吞吐：更大 batch、多分片、链式续跑、检查点提交等策略仍适用。
- 审查节奏与活跃度、创建时间挂钩（热点约小时级、其余日/周级等，以代码为准）。
- 审查策略版本变更时，强制将此前仍「新鲜」的报告重新进入规划队列。
- 关单证据与公开评论：结构化审查摘要、公开文档链接、源码锚点、修复版本证据、Markdown 排版等持续优化。
- 输出「最佳处理建议」，便于 **keep_open** 与 **close** 两种结论下都给维护者清晰路径。
- apply 默认行为、检查点、心跳与冲突重试等与上游 ClawSweeper 能力对齐；关单前延迟等参数随上游迭代调整。
- **最近关闭** 表格：链接到上游条目与本地 `closed/` 归档报告。
- 审计中对「缺失开放记录」等分类，严格模式下突出可处理漂移（致谢 @stainlu）。
- GitHub API 短暂失败重试与二级限流退避、节流心跳（致谢 @stainlu）。
- README 仪表盘分区与可折叠的近期审查表，便于浏览。

### 修复

- 审查对上游检出目录 **只读**，并在单项审查前后检测工作区是否被污染。
- **子进程环境** 剥离敏感 token（含 `DASHSCOPE_API_KEY`、各类 `GH_TOKEN` 等），降低日志与嵌套会话泄漏风险。
- 严格 JSON Schema 解析与失败兜底（非 JSON、超时、4xx/5xx 等归为百炼失败并 **keep_open**）。
- 压缩审查 prompt 中的 GitHub 上下文体量；分片内单项失败不阻塞其余条目。
- 多工作流并发推送下的审查产物合并与发布可靠性。
- **`reconcile`**：随 Issue/PR 关闭、重开同步 `items/` 与 `closed/`。
- apply 关单安全：维护者稿件排除、保护标签、快照变更检测、幂等与已关闭处理等。
- apply 长任务场景下的 API 调用与读写重试退避。
- 关单评论格式与基于已存证据渲染的 apply 评论一致。
- 仪表盘节奏指标与当前审查规则一致。
- 通过识别既有自动化审查评论 + 隐藏标记，避免重复关单评论。
- 修正 Actions 文档中关于 App token 评论/关单归属的说明。
- 子进程标准输出/错误缺失时仍保留可读失败信息（致谢 @ZHOUKAILIAN）。
