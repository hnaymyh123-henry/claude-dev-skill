# Phase 3 — 多 Agent 并行开发（执行规则）

---

## 执行规则

- 对可并行的任务，使用 Agent 工具**同时启动多个 Worker Agent**
- 每个 Worker Agent 使用 `isolation: "worktree"` 在独立环境中工作
- **即使只有一个任务，也必须派 Worker Agent 执行，不得在主对话中直接写代码**
- 进度报告原则：**只报告关键节点**
  - 所有 Agent 启动后，输出**任务看板**（格式见下方）一次
  - 某个 Agent 完成提 PR 后，更新任务看板并重新输出完整看板
- 用户可随时查看代码，不主动干扰

## 任务看板格式

所有 Agent 启动后输出一次，每次有 PR 创建后重新输出完整看板：

```
## Agent 任务看板

| # | 分支 | Issue | 状态 |
|---|------|-------|------|
| 1 | feat/auth | #3 用户登录 | ⏳ 进行中 |
| 2 | feat/user-api | #4 用户资料 API | ⏳ 进行中 |
| 3 | feat/db-schema | #5 数据库 schema | ⏳ 进行中 |
```

状态值：
- `⏳ 进行中` — agent 运行中
- `✓ PR #N 已创建` — PR 已提交，等待 Review
- `❌ 阻塞：[原因]` — agent 遇到阻碍，需要 Tech Lead 介入

## 派发 Worker Agent

将对应 prompt 文件的完整内容传入 Agent prompt，并替换 `[N]` 为实际 Issue 编号：

- 新功能：读取 `~/.claude/commands/dev/worker-new.md`，传入 Agent
- 修复/改进：读取 `~/.claude/commands/dev/worker-fix.md`，传入 Agent
