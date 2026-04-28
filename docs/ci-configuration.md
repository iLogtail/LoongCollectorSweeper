# sweep.yml CI 配置说明

本文档描述 `.github/workflows/sweep.yml` 工作流的整体架构、触发条件、所需配置与各 job 的详细说明。

## 整体架构

```
schedule / workflow_dispatch
        │
        ├── [审查路径] plan → review（并行分片）→ publish → (continue sweep)
        ├── [Apply 路径] apply-existing → (continue apply)
        ├── [审计路径] audit-dashboard
        └── [热点路径] plan(hot) → review(hot) → publish(hot)
```

工作流通过 `if` 条件在同一个 YAML 中实现多条独立路径，由触发方式和输入参数决定执行哪条路径。

## 触发条件

### 定时触发 (schedule)

| Cron 表达式 | 频率 | 执行路径 |
| --- | --- | --- |
| `*/5 * * * *` | 每 5 分钟 | 热点 intake：plan + review（少量分片） |
| `17 * * * *` | 每小时第 17 分钟 | 常规审查：plan + review + publish |
| `3,18,33,48 * * * *` | 每小时 4 次 | Apply：应用已有提议关闭决策 |
| `7 */6 * * *` | 每 6 小时 | 审计仪表盘刷新 |

### 手动触发 (workflow_dispatch)

通过 GitHub Actions UI 手动触发，支持以下输入参数：

| 参数 | 默认值 | 说明 |
| --- | --- | --- |
| `apply_existing` | `false` | 应用已有「提议关闭」决策 |
| `apply_limit` | `20` | 单次最多关闭条数 |
| `apply_min_age_days` | `0` | 条目最小年龄（天） |
| `apply_kind` | `all` | 处理类型：`issue`/`pull_request`/`all` |
| `apply_item_numbers` | 空 | 逗号分隔的指定条目编号 |
| `apply_sync_comments_only` | `false` | 仅同步评论，不关单 |
| `apply_comment_sync_min_age_days` | `7` | 评论同步最小天数阈值 |
| `apply_close_delay_ms` | `2000` | 关闭间隔（毫秒），避免限流 |
| `apply_progress_every` | `10` | 每 N 条记录日志 |
| `apply_checkpoint_size` | `50` | 检查点提交间隔 |
| `batch_size` | `5` | 每个分片的批大小 |
| `bailian_timeout_ms` | `600000` | 百炼请求超时（10 分钟） |
| `shard_count` | `100` | 并行分片数 |
| `item_number` | 空 | 单个指定条目编号 |
| `item_numbers` | 空 | 逗号分隔的多个条目编号 |
| `hot_intake` | `false` | 执行热点快速审查 |
| `audit_dashboard` | `false` | 仅刷新审计仪表盘 |

## 所需 Secrets

在仓库 Settings → Secrets and variables → Actions 中配置：

| Secret 名称 | 必需 | 说明 |
| --- | --- | --- |
| `DASHSCOPE_API_KEY` | **是** | 阿里云百炼 / DashScope API Key，审查 job 必需 |
| `LOONGSWEEPER_APP_ID` | 推荐 | GitHub App ID，用于生成细粒度 token 访问上游仓库 |
| `LOONGSWEEPER_APP_PRIVATE_KEY` | 推荐 | GitHub App 私钥，与上条配合使用 |
| `LOONGCOLLECTOR_GH_READ_TOKEN` | 备选 | 上游仓库只读 PAT（无 GitHub App 时使用） |
| `LOONGCOLLECTOR_GH_WRITE_TOKEN` | 备选 | 上游仓库读写 PAT（apply 关单/评论时使用） |

**Token 优先级链**：GitHub App token > `LOONGCOLLECTOR_GH_READ_TOKEN` > `github.token`

## 所需 Variables

在仓库 Settings → Secrets and variables → Actions → Variables 中配置：

| Variable 名称 | 默认值 | 说明 |
| --- | --- | --- |
| `DASHSCOPE_MODEL` | `qwen3.6-max-preview` | 百炼模型名称 |

## 权限说明

工作流声明的 GitHub token 权限：

```yaml
permissions:
  contents: write      # 推送 README、items/、closed/ 等更新
  actions: write       # 触发后续工作流（continue sweep/apply）
  issues: write        # 在上游 Issue 上发表评论、关闭
  pull-requests: write # 在上游 PR 上发表评论、关闭
```

审查 job（review）仅需只读权限，通过 job 级 `permissions` 覆盖为 `read`。

## Jobs 详细说明

### plan（规划审查候选）

- **执行条件**：非 apply / 非 audit 路径时执行
- **超时**：30 分钟
- **流程**：
  1. Checkout 本仓库
  2. 生成 GitHub App token（如已配置）
  3. 安装依赖并构建
  4. 发布「规划开始」状态到 README
  5. 执行 `npm run plan`，输出分片矩阵
  6. 发布规划状态并更新仪表盘
- **输出**：`matrix`（分片信息）、`planned_count`、`shard_count` 等

### review（审查分片）

- **执行条件**：plan 完成后并行启动
- **超时**：75 分钟
- **并行度**：由 plan 输出的 matrix 决定（最多 `shard_count` 个并行 job）
- **流程**：
  1. Checkout 本仓库与上游 loongcollector 源码
  2. 安装依赖并构建
  3. 执行 `npm run review` 处理本分片分配的条目
  4. 上传审查产物为 artifact
- **注意**：审查 job 仅具有只读权限，不会写 GitHub

### publish（发布审查产物）

- **执行条件**：所有 review 完成后（`always()`）
- **超时**：60 分钟
- **流程**：
  1. 下载所有分片的审查产物
  2. 执行 `apply-artifacts` 合并到 `items/` 与 `closed/`
  3. 更新仪表盘并提交推送
  4. 同步持久化审查评论到上游
  5. 如果规划容量已满，触发下一轮 sweep

### audit-dashboard（审计仪表盘）

- **执行条件**：手动 `audit_dashboard=true` 或定时 `7 */6 * * *`
- **超时**：45 分钟
- **流程**：扫描 GitHub 开放条目，对比本地记录，刷新 README 审计健康区块

### apply-existing（应用关单提议）

- **执行条件**：手动 `apply_existing=true` 或定时 `3,18,33,48 * * * *`
- **超时**：360 分钟（6 小时）
- **流程**：
  1. 构建并对账
  2. 按检查点批量执行关单与评论同步
  3. 每个检查点提交一次，失败可续跑
  4. 完成后如达上限，触发下一轮 apply

## 并发组与调度策略

工作流使用动态并发组名避免不同路径互相取消：

| 路径 | 并发组名 |
| --- | --- |
| 评论同步 | `loongsweeper-comment-sync` |
| Apply 关单 | `loongsweeper-apply` |
| 热点 intake | `loongsweeper-intake` |
| 审计 | `loongsweeper-audit` |
| 常规审查 | `loongsweeper-review` |

所有并发组设置 `cancel-in-progress: false`，确保正在执行的 run 不会被新触发取消。

## 环境变量（job 内部）

部分 job 步骤使用以下环境变量控制行为：

| 变量 | 说明 |
| --- | --- |
| `LOONGSWEEPER_APPLY_CLOSURES` | 是否在审查时直接关闭（当前固定 `false`） |
| `LOONGSWEEPER_PUBLISH_THROTTLE_STATUS` | Apply 时启用状态节流心跳 |
| `LOONGSWEEPER_RUN_URL` | 当前 workflow run 的 URL |
| `LOONGSWEEPER_THROTTLE_STATUS_MIN_WAIT_MS` | 状态节流最小等待时间 |
| `LOONGSWEEPER_THROTTLE_STATUS_MIN_INTERVAL_MS` | 状态节流最小间隔时间 |
| `LOONGSWEEPER_APPLY_CHECKPOINT` | 当前检查点编号 |
