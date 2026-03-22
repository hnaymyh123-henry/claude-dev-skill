# Phase 4 — Code Review & Merge

---

## Pre-Review Preparation

Before starting Review, read `PROJECT_CONTEXT.md` for code style conventions and architecture decisions to use as the review baseline.

---

## Static Analysis Gate (run before human review)

Before human review, run static analysis tools (if configured in the project):
- Python: `flake8` / `pylint` / `mypy`; security scan: `bandit` (if not installed: `pip install bandit`, run `bandit -r .`)
- JavaScript: `eslint`

**Dependency vulnerability scan (mandatory):**
- Python: `pip-audit` (if not installed: `pip install pip-audit`)
- Node.js: `npm audit`

If static analysis reports significant errors (not nitpicks), send back to Worker Agent for fixes — do not proceed to human review.
If `pip-audit` / `npm audit` finds High or Critical vulnerabilities, also send back and require dependency upgrades.

---

## Review Checklist

Execute each item and give a clear pass/fail conclusion:

```
□ Feature Completeness
  Verification: check diff against each acceptance criterion in the Issue
  Mandatory veto: any acceptance criterion has no corresponding implementation in the diff

□ Boundary Handling
  Verification: static analysis of null/empty/exception handling paths in the code
  Mandatory veto: core entry function has no input validation at all

□ Error Handling
  Verification: trace failure paths of external calls (DB/API/file)
  Mandatory veto: external call has no try/catch and failure would crash the process

□ Code Style
  Verification: compare against style conventions in PROJECT_CONTEXT.md
  Mandatory veto: naming style is clearly inconsistent with the rest of the project (not nitpick level)

□ Test Coverage
  Verification: check if diff includes test files
  Mandatory veto: project has a test framework but new feature has no corresponding tests

□ Security
  Verification: static pattern matching (SQL concatenation, direct eval, unescaped input, hardcoded secrets/passwords, logging tokens/passwords)
  Mandatory veto: direct string-concatenated SQL or shell commands exist; or hardcoded secrets/passwords/tokens in code

□ Database Migration (execute only if diff contains schema changes)
  Verification: check if a migration framework is used (Alembic/Flyway/Knex), and if migration scripts include downgrade/rollback methods
  Mandatory veto: direct DDL operations (DROP COLUMN / ALTER TABLE) without using a migration framework; or migration script has no rollback method

□ Performance
  Verification: identify obvious anti-patterns (DB queries inside loops, infinite recursion risk)
  Mandatory veto: unnecessary database queries inside a loop
```

Use `gh pr review` to leave comments — one specific comment per issue.

---

## Review Rating

Must give one explicit rating:

- **APPROVE**: all Checklist items pass, or only nitpick-level issues
  → `gh pr merge --squash`, close the corresponding Issue

- **REQUEST CHANGES**: any mandatory veto triggered, or any Checklist item fails
  → list each issue and expected fix in comments
  → re-dispatch Worker Agent to make changes
  → **after fixes, must re-run Phase 3.5 (QA) + Phase 4 (Review) — never skip**

- **COMMENT**: questions that don't block the merge (decide after user confirmation)

---

## Merge Order

Merge in dependency order: infrastructure Issue PRs merge first; dependent PRs wait until prerequisites are merged.

Update `PROJECT_CONTEXT.md` after all PRs are merged (completed features list, current status).

---

## Post-Merge: Affected PR Coordination (mandatory after every merge)

After a PR is merged into main, immediately:

1. `gh pr list --state open` — list all open PRs
2. Compare this merge's file list against each open PR's modified files (`gh pr diff <PR-number> --name-only`)
3. Open PRs with file overlap → comment: `This PR overlaps files with the just-merged #N. Please rebase: git fetch origin && git rebase origin/main`
4. Open PRs with logical dependencies (e.g. this refactor changed module paths or interface signatures) → notify those PRs as well
