# Changelog

All notable changes to this project will be documented in this file.

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project follows [Semantic Versioning](https://semver.org/).

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
