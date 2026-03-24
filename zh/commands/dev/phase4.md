# Phase 4 — Code Review & 合并

---

## 前置准备

读取 `PROJECT_CONTEXT.md` 中的代码风格约定和架构决策，作为 Review 的参考基准。

---

## Step 0 — Scope Drift 检测（Review 第一步，不得跳过）

**在任何 checklist 之前**，先检查 Worker Agent 交付的是否是被要求的东西：

```
gh pr diff [PR号] --name-only
```

对比修改文件列表与 Issue 描述的预期范围：
- 改动文件明显超出 Issue 范围（如修了不相关模块）→ **标记 Scope Drift**，REQUEST CHANGES，要求 Worker Agent 撤销无关改动
- 缺少 Issue 要求的文件（如漏实现某个功能）→ 记录为功能完整性问题，进入 checklist
- 范围吻合 → 继续

---

## Step 1 — 静态分析门控

运行静态分析工具（如果项目已配置）：
- Python：`flake8` / `mypy`；安全扫描：`bandit -r .`
- JavaScript：`eslint`

**依赖漏洞扫描（必须执行）：**
- Python：`pip-audit`
- Node.js：`npm audit`

发现明显错误或 High/Critical 漏洞 → 直接打回 Worker Agent，不进入人工 Review。

---

## Step 2 — Review Checklist（两遍走）

### Pass 1：Critical（任何一项不通过 → 不得合并）

对每个问题，分类为 `AUTO-FIX`（直接修）或 `ASK`（批量问用户）：

```
□ Scope Drift
  问题：改动是否超出或遗漏 Issue 范围？
  → AUTO-FIX：删除无关改动；ASK：补充遗漏实现

□ SQL 安全
  问题：是否存在字符串拼接 SQL / ORM raw query 未参数化？
  → AUTO-FIX：改为参数化查询

□ 认证/权限边界
  问题：新增接口是否缺少鉴权；是否直接信任用户输入的 ID？
  → ASK：确认权限设计意图

□ 竞态条件
  问题：有副作用的函数是否在并发调用时有 race condition 风险？
  → ASK：确认是否需要加锁或原子操作

□ 功能完整性
  问题：对照 Issue 验收标准，每条是否在 diff 中有对应实现？
  → ASK：列出缺失的验收标准，要求补充

□ 错误处理
  问题：外部调用（DB/API/文件）失败路径是否有处理？
  → AUTO-FIX：补充明显缺失的 try/catch；ASK：失败语义不明确时
```

### Pass 2：Informational（记录，不阻塞合并）

```
□ 测试覆盖（见下方覆盖率审计）
□ 魔法数字 / 硬编码值
□ 死代码 / 未使用的 import
□ 性能反模式（循环内 DB 查询、N+1）
□ 代码风格（对照 PROJECT_CONTEXT.md）
□ 数据库迁移（含 schema 变更时）：是否有 downgrade 方法
```

**执行原则（Fix-First）：**
- `AUTO-FIX` 类问题直接在 Review 时修掉，PR body 注明 `[AUTO-FIXED]`
- `ASK` 类问题批量整理成一个问题问用户或 Worker Agent，不逐个打断

---

## Step 3 — 测试覆盖率审计

追踪 diff 中每个改动点的执行路径，绘制覆盖图：

```
Coverage Audit — [PR标题]
changed: src/auth.py (+47 lines)

  register()
    ├── happy path: POST valid email/pass → 201          [有测试 ✓]
    ├── dup email → 409                                   [有测试 ✓]
    ├── invalid email format → 400                        [无测试 ✗]
    └── DB断连 → 500                                      [无测试 ✗]
```

- 有测试框架且存在未覆盖的 Critical 路径 → Pass 2 标记，建议补充（不强制阻塞）
- 完全没有测试且项目有测试框架 → Pass 1 阻塞

---

## Step 4 — Adversarial Review（按需触发，不按行数）

**触发条件：Pass 1 或 Pass 2 中存在 ASK 类 findings**（即 Tech Lead 对某个问题的判断存在不确定性）。

Pass 1 和 Pass 2 全部为 AUTO-FIX 或明确通过 → **跳过 adversarial review，直接评级**。

有任何 ASK 类 findings → 派一个子 Agent 做独立第二意见，聚焦 ASK 项涉及的代码区域：

**对抗性子 Agent prompt（有 ASK findings 时派发）：**
```
你是一个挑剔的 staff engineer。Tech Lead 在 review 以下 diff 时，对这些问题拿不准：
[列出 ASK 类 findings 及对应代码片段]

你的任务：针对这几个具体的不确定点，给出独立判断：
- 这个问题是否真实存在？
- 严重程度如何？
- 推荐修复方案是什么？
只针对列出的问题回答，不泛化到整个 diff。格式：每个问题一段。
```

---

## Review 评级

**APPROVE：** Pass 1 全部通过，AUTO-FIX 已应用
→ `gh pr merge --squash`，关闭对应 Issue，更新 PROJECT_CONTEXT.md

**REQUEST CHANGES：** Pass 1 有未解决的 ASK 项，或 Scope Drift 确认
→ 评论中列出每个 ASK 问题和期望修复方式，重新派 Worker Agent
→ **修改完成后必须重新走 Phase 3.5 + Phase 4，不得跳过**

**COMMENT：** 仅 Pass 2 问题，不阻塞合并，留评论记录

> **nitpick 定义**：不影响功能、性能、安全性的纯风格问题（如变量名偏好、注释用词）。

---

## 合并顺序

按依赖顺序合并：基础设施 PR 先合，有依赖的 PR 等前置合并后再处理。

合并后立即执行受影响 PR 协调：
1. `gh pr list --state open` 列出所有 open PR
2. `gh pr diff <PR号> --name-only` 对比文件重叠
3. 有重叠或逻辑依赖 → PR 评论通知 rebase
