# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project follows [Semantic Versioning](https://semver.org/).

---

## [1.2.0] — 2026-03-30

### Added
- **`phase5.md`**：Phase 5 独立文件，包含完整的 Retro + 技术债清扫流程。技术债清扫分三步：2a 死文档清查（git log 辅助 + 引用对象验证）、2b 废弃代码清查（注释代码块、零调用方函数、固化 feature flag、过期 TODO/FIXME）、2c 失效功能登记；清扫后输出结构化报告
- **渐进式文档结构**：`PROJECT_CONTEXT_TEMPLATE.md` 重构为 index + 子文档模式，主索引 ≤ 35 行仅做路由，技术内容分散至 `docs/tech-stack.md`、`docs/architecture.md`、`docs/api-contracts.md`、`docs/style-guide.md`、`docs/feature-log.md`，每个子文档保持 100–200 行

### Changed
- **`dev.md`**：Phase 5 入口改为引用 `phase5.md`（与其他 phase 保持一致）；全局规则中 `PROJECT_CONTEXT.md` 更新说明改为「架构决策变化时立即更新对应子文档，每轮结束后更新主索引 + feature-log」
- **`phase3.md`（zh/en）**：进度报告格式升级为任务看板（Task Board），包含分支名、Issue 号、状态字段，每次 PR 创建后重新输出完整看板；状态枚举：进行中 / PR 已创建 / 阻塞
- **`install.sh`**：修复漏复制 `phase3.5.md` 和 `phase5.md` 的 bug

---

## [1.1.0] — 2026-03-24

### Added
- **轻量模式 (Lightweight Mode)**：Phase 0 新增轻量模式路由。满足「文件 ≤ 2 个、无新对外接口、无 schema 变更、无认证逻辑」时，Tech Lead 可在主对话中直接执行，无需 Issue / worktree / PR 流程，并附内联质量检查
- `phase3.5.md`：Phase 3.5 QA 触发条件独立文件，量化判断规则（diff 行数 ≥ 50 / 文件数 ≥ 3 / 新增对外接口 / schema 变更 / 认证逻辑），满足任一条件才触发 QA，否则直接进入 Phase 4

### Changed
- **phase4.md**：Review 新增 Step 0 Scope Drift 检测（`gh pr diff --name-only` 对比 Issue 预期范围，超出则 REQUEST CHANGES）
- **phase2.md**：新项目初始化流程更详细，拆分为①创建仓库（`gh repo create --clone`）+ ②创建 init commit 推送 main 分支两步，避免 main 分支不存在导致 worktree 创建失败
- **worker-new.md / worker-fix.md**：并行冲突检查移至 Step 2（代码阅读之前），强调必须先通过冲突检查才能继续，而非作为编码前的可选步骤
- **qa-agent.md**：QA 报告措辞优化，强调「实际运行测试」与「静态分析推断」的区分

---

## [1.0.0] — 2026-03-22

### Initial Release

**Core workflow (Phase 0–5)**
- Phase 0: 6-type request router — New Project / New Feature / Bug Fix / Emergency Hotfix / Architectural Change / Refactoring
- Phase 1: Product alignment — uses existing PRD directly, or generates one in ≤2 rounds of questions
- Phase 2: Architecture decision checkpoint + task decomposition + GitHub Issue creation with explicit dependency DAG
- Phase 3: Multi-agent parallel development with `isolation: "worktree"`
- Phase 3.5: QA Agent with honest tool boundary declaration (static analysis only)
- Phase 4: Code Review with 8-item checklist and mandatory veto conditions per item
- Phase 5: Retro + next iteration loop

**Worker Agents**
- `worker-new.md`: new feature agent — design-first, 6-category counterexample self-check, structured test output format
- `worker-fix.md`: fix/hotfix agent — minimal scope principle, hotfix branch naming, regression testing requirement

**Safety gates (Phase 4)**
- Static analysis: `flake8` / `pylint` / `mypy` / `eslint` + `bandit` security scan
- Dependency vulnerability scan: `pip-audit` / `npm audit` (mandatory, High/Critical = send back)
- Hardcoded secrets detection (mandatory veto)
- Database migration guard: direct DDL without migration framework = mandatory veto

**Multi-language support**
- `zh/`: Chinese skill files
- `en/`: English skill files
- Install scripts support `--lang en|zh`

**Project templates**
- `PROJECT_CONTEXT_TEMPLATE.md`: structured template for project context file

**Key design decisions**
- Progressive disclosure: slim entry file (`dev.md`) + on-demand phase files
- Tech Lead role anchoring via session state anchor block
- Post-merge PR coordination: scans open PRs for rebase needs after every merge
- `PROJECT_CONTEXT.md` updated at decision time, not just at end of iteration
