# 更新日志

本文件记录 **LoongCollectorSweeper** 的重要变更。本工具由 OpenClaw 生态下的 ClawSweeper fork 而来，所有 claw 相关命名已重命名为 loong 系列，目标仓库为 [`alibaba/loongcollector`](https://github.com/alibaba/loongcollector)，报告与仪表盘落在 [`iLogtail/LoongCollectorSweeper`](https://github.com/iLogtail/LoongCollectorSweeper)。

仪表盘心跳、检查点与仅状态类提交有意不写入本日志；若需细粒度历史，请以 Git 提交记录为准。

## [未发布]

### 修复

- **ROOT 路径解析**：独立 skill/bundle 模式下 ROOT 不再错误地指向上级目录；自动检测 `dist/` 开发模式与独立部署模式。
- **资源文件读取**：新增 `readResource()` 函数，优先从 bundle 内联资源读取，移除无效的 `fs.readFileSync` monkey-patch（ESM named import 无法被拦截）。
- **checkCommand 放宽**：独立 skill 模式下不再要求 `.github/workflows/sweep.yml` 存在。
- **dotenv 加载**：跟随 ROOT 逻辑，在 skill 目录下也能正确加载 `.env`。

## [0.1.2] - 2026-04-28

### 变更

- Release zip 中新增 `schema/` 和 `prompts/` 目录作为参考文档，便于 Agent 理解数据模型和审查逻辑。
- 重写 **SKILL.md**：新增「快速开始（Agent 自动化流程）」节，给出可直接复制执行的完整命令序列；新增进度监控指引；frontmatter 加入 `argument-hint`。

## [0.1.1] - 2026-04-28

### 变更

- **SKILL.md** 加入标准 YAML frontmatter（`name`、`description`、`when_to_use`、`allowed-tools`），符合 Agensi/悟空等 AI Agent 平台的 skill 加载规范。

## [0.1.0] - 2026-04-28

### 新增

- **Skill 打包**：使用 esbuild 将所有依赖、schema、prompts 打包为单文件 `loongsweeper.js`（约 173KB），无需 `npm install`。
- **GitHub Release 工作流**（`release.yml`）：手动 `workflow_dispatch` 触发，输入版本号，自动构建、测试、打包 zip 并创建 GitHub Release。
- **SKILL.md**：通用 AI Agent 指令文件，兼容悟空、Cursor、Windsurf 等平台。
- **CI 配置文档**（`docs/ci-configuration.md`）：sweep.yml 完整配置说明。
- **结构化审计日志**（JSONL）：每次运行生成 `loongsweeper.log.jsonl`，逐条追加，包含时间戳、进度、阶段、事件、LLM 调用详情等，可用 `tail -f` 实时监控。
- 日志覆盖所有命令的 start/finish、review 每条 item 开始/结束、LLM 调用开始/成功/失败、apply 进度、GitHub API 重试等关键节点。

### 变更

- **命名重构**：所有 `claw*` 重命名为 `loong*`（clawsweeper → loongsweeper, CLAWSWEEPER_* → LOONGSWEEPER_*, clawhub → loong_plugin_system）。
- **默认模型**：`qwen-plus` → `qwen3.6-max-preview`。
- **环境变量**：移除 `OPENCLAW_GH_TOKEN` fallback，统一使用 `LOONGSWEEPER_*` 系列。
- `close_reason` 枚举值 `clawhub` → `loong_plugin_system`，已有记录同步更新。

### 修复

- 修复 `package-lock.json` 中指向阿里内部 registry（`registry.anpm.alibaba-inc.com`）的依赖 URL，改用公网 npm registry。

## [初始版本] - 2026-04-20

### 新增

- 以「保守维护」为目标的清扫机器人：为上游每个开放 Issue / Pull Request 生成一份 Markdown 审查记录。
- **仅提议**的审查流水线，以及独立的 **apply** 模式：仅对未变更且高置信的「提议关闭」执行关单与评论同步。
- 支持按单号 / 逗号分隔多号定向审查，便于排障与补审。
- README **仪表盘**：指向 `items/` 报告、证据与关单率、节奏覆盖、工作流状态、apply 状态等。
- 扁平 **`closed/`** 归档，使 **`items/`** 主要跟踪当前仍开放的条目。
- **`audit`** 只读命令：对照 GitHub 实时状态检查 `items/` 与 `closed/` 是否一致。
- **持久化审查评论**：在关单或同步前原地更新同一条自动化审查评论。
- 与审查并行的 **定时 / 手动 apply、仅评论同步** 等工作流路径。
- **热点 intake** 审查分片，面向新建与近期活跃条目。
- **阿里云百炼 / DashScope**：通过兼容 OpenAI Chat Completions 的 HTTP 接口调用模型。
- 可配置文档根、默认中文文档树与插件生态说明链接。

### 变更

- 审查模型由 Codex/GPT 管线改为 **百炼**。
- 目标仓库 **`alibaba/loongcollector`**，报告仓库 **`iLogtail/LoongCollectorSweeper`**。
- GitHub Actions 全面适配上游仓库。
