# Phase 3 — 多 Agent 并行开发（执行规则）

---

## 执行规则

- 对可并行的任务，使用 Agent 工具**同时启动多个 Worker Agent**
- 每个 Worker Agent 使用 `isolation: "worktree"` 在独立环境中工作
- **即使只有一个任务，也必须派 Worker Agent 执行，不得在主对话中直接写代码**
- 进度报告原则：**只报告关键节点**
  - 所有 Agent 启动后汇报一次
  - 某个 Agent 完成提 PR 后汇报：`✓ PR #N 已创建：[任务名] — [分支名]`
- 用户可随时查看代码，不主动干扰

## 派发 Worker Agent

将对应 prompt 文件的完整内容传入 Agent prompt，并替换 `[N]` 为实际 Issue 编号：

- 新功能：读取 `~/.claude/commands/dev/worker-new.md`，传入 Agent
- 修复/改进：读取 `~/.claude/commands/dev/worker-fix.md`，传入 Agent
