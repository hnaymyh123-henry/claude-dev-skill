# Phase 3.5 — QA 验证

---

## 触发条件（量化判断，不依赖主观感觉）

满足以下**任意一条**则必须执行 QA，否则跳过直接进入 Phase 4：

| 条件 | 必须执行 QA |
|------|-------------|
| diff 新增/修改行数 ≥ 50 行 | ✓ |
| diff 涉及文件数 ≥ 3 个 | ✓ |
| diff 含新增的对外接口（新 API endpoint、新公共函数签名） | ✓ |
| diff 含数据库 schema 变更 | ✓ |
| diff 含认证/权限相关逻辑 | ✓ |

不满足以上任何一条（如：仅改注释、改文案、改单个函数内部实现且行数 < 50）→ 跳过 Phase 3.5，直接进入 Phase 4。

---

## 派发 QA Agent

Tech Lead 获取 PR 的分支名后，将以下信息填入 qa-agent.md 的 prompt 并派发：

```
PR 编号：#[N]
Issue 编号：#[M]
PR 分支名：[branch-name]（通过 `gh pr view [N] --json headRefName -q .headRefName` 获取）
```

**派发前 Tech Lead 必须自行执行：**
```bash
gh pr view [N] --json headRefName -q .headRefName
```
将输出的分支名填入 QA Agent prompt，不得让 QA Agent 自己去查。

---

## QA 结果处理

### QA 通过（QA Agent 评论 `QA ✓`）
Tech Lead 收到通知后进入 Phase 4。

### QA 不通过
QA Agent 在 PR 上留下问题清单评论后退出。**Tech Lead 负责**读取评论，将问题清单整理成新的修复指令，重新派发 Worker Agent（使用 worker-fix.md）处理。

Worker Agent 修复完成提新 commit 后，Tech Lead 重新走完整 Phase 3.5 + Phase 4，不得跳过。

> 注意：QA Agent 是一次性 session，完成后不再存在。不要在 PR 评论里 tag QA Agent 或 Worker Agent——他们不会收到通知。所有重新派发的决策由 Tech Lead 主动发起。
