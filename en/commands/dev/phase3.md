# Phase 3 — Multi-Agent Parallel Development (Execution Rules)

---

## Execution Rules

- For parallelizable tasks, use the Agent tool to **launch multiple Worker Agents simultaneously**
- Each Worker Agent uses `isolation: "worktree"` to work in an isolated environment
- **Even with only one task, a Worker Agent must be dispatched — never write code directly in the main conversation**
- Progress reporting: **report at key milestones only**
  - After all agents are launched, output the **Task Board** (see format below) once
  - After each agent creates a PR, update the Task Board and re-output it
- Users may view the code at any time; do not proactively interrupt

## Task Board Format

Output after all agents are launched, and re-output (full board) after each PR is created:

```
## Agent Task Board

| # | Branch | Issue | Status |
|---|--------|-------|--------|
| 1 | feat/auth | #3 User login | ⏳ In progress |
| 2 | feat/user-api | #4 User profile API | ⏳ In progress |
| 3 | feat/db-schema | #5 Database schema | ⏳ In progress |
```

Status values:
- `⏳ In progress` — agent is running
- `✓ PR #N created` — PR submitted, waiting for review
- `❌ Blocked: [reason]` — agent encountered a blocker, Tech Lead action needed

## Dispatching Worker Agents

Pass the full content of the corresponding prompt file into the Agent prompt, replacing `[N]` with the actual Issue number:

- New feature: read `~/.claude/commands/dev/worker-new.md`, pass into Agent
- Fix / improvement: read `~/.claude/commands/dev/worker-fix.md`, pass into Agent
