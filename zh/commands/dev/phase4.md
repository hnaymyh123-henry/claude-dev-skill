# Phase 4 — Code Review & 合并

---

## 前置准备

Review 开始前必须先读取 `PROJECT_CONTEXT.md` 中的代码风格约定和架构决策，作为 Review 的参考基准。

---

## 静态分析门控（Review 前执行）

在人工 Review 之前，先运行静态分析工具（如果项目已配置）：
- Python：`flake8` / `pylint` / `mypy`；安全扫描：`bandit`（如未安装：`pip install bandit`，运行 `bandit -r .`）
- JavaScript：`eslint`

**依赖漏洞扫描（必须执行）：**
- Python：`pip-audit`（如未安装：`pip install pip-audit`）
- Node.js：`npm audit`

静态分析报告明显错误（非 nitpick）时，直接打回 Worker Agent 修复，不进入人工 Review。
`pip-audit` / `npm audit` 发现高危漏洞（High/Critical）时同样直接打回，要求升级依赖。

---

## Review Checklist

逐项执行，每项必须给出明确的通过/不通过结论：

```
□ 功能完整性
  验证方式：对照 Issue 验收标准逐条检查 diff
  强制否决条件：任何验收标准在 diff 中找不到对应实现

□ 边界处理
  验证方式：静态分析代码中的 null/empty/exception 处理路径
  强制否决条件：核心入口函数无任何输入验证

□ 错误处理
  验证方式：追踪外部调用（DB/API/文件）的失败路径
  强制否决条件：外部调用无 try/catch 且失败会导致进程崩溃

□ 代码风格
  验证方式：对照 PROJECT_CONTEXT.md 中记录的风格约定
  强制否决条件：命名风格与项目其余代码明显不一致（非 nitpick 级别）

□ 测试覆盖
  验证方式：检查 diff 中是否包含测试文件
  强制否决条件：如项目有测试框架，新功能无对应测试

□ 安全性
  验证方式：静态模式匹配（SQL 拼接、直接 eval、未转义输入、硬编码密钥/密码、日志打印 token/密码）
  强制否决条件：存在直接字符串拼接 SQL 或 shell 命令；或代码中有硬编码的密钥/密码/token

□ 数据库迁移（如 diff 含 schema 变更时执行）
  验证方式：检查是否使用迁移框架（Alembic/Flyway/Knex），迁移脚本是否包含 downgrade/rollback 方法
  强制否决条件：直接 DDL 操作（DROP COLUMN / ALTER TABLE）而不通过迁移框架；或迁移脚本无回滚方法

□ 性能
  验证方式：识别明显反模式（循环内 DB 查询、无限递归风险）
  强制否决条件：循环内有无必要的数据库查询
```

用 `gh pr review` 留下评论，每个问题对应一条具体评论。

---

## Review 评级

必须明确给出一个评级：

- **APPROVE**：所有 Checklist 项通过，或仅有 nitpick 级别问题
  → `gh pr merge --squash`，关闭对应 Issue

- **REQUEST CHANGES**：任何强制否决条件触发，或 Checklist 中有项目不通过
  → 评论中列出每个问题和期望的修复方式
  → 重新派 Worker Agent 修改
  → **修改完成后必须重新走 Phase 3.5（QA）+ Phase 4（Review），不得跳过**

- **COMMENT**：有疑问但不阻塞合并（需用户确认后决定）

---

## 合并顺序

按依赖顺序合并：基础设施 Issue 的 PR 先合，有依赖的 PR 等前置合并后再处理。

所有 PR 合并后，更新 `PROJECT_CONTEXT.md`（已完成功能列表、当前状态）。

---

## 合并后：受影响 PR 协调（每次合并后必须执行）

PR 合并到 main 后，立即执行：

1. `gh pr list --state open` 列出所有 open PR
2. 对比本次合并的文件列表与每个 open PR 的修改文件（`gh pr diff <PR号> --name-only`）
3. 有文件重叠的 PR → 在 PR 评论中通知：`此 PR 与刚合并的 #N 存在文件重叠，需要执行 rebase：git fetch origin && git rebase origin/main`
4. 有逻辑依赖（如本次重构改变了模块路径/接口签名）→ 同样通知受影响的 PR
