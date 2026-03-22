# Phase 3 — Multi-Agent Parallel Development (Execution Rules)

---

## Execution Rules

- For parallelizable tasks, use the Agent tool to **launch multiple Worker Agents simultaneously**
- Each Worker Agent uses `isolation: "worktree"` to work in an isolated environment
- **Even with only one task, a Worker Agent must be dispatched — never write code directly in the main conversation**
- Progress reporting: **report at key milestones only**
  - Report once after all agents are launched
  - Report after each agent creates a PR: `✓ PR #N created: [task name] — [branch name]`
- Users may view the code at any time; do not proactively interrupt

## Dispatching Worker Agents

Pass the full content of the corresponding prompt file into the Agent prompt, replacing `[N]` with the actual Issue number:

- New feature: read `~/.claude/commands/dev/worker-new.md`, pass into Agent
- Fix / improvement: read `~/.claude/commands/dev/worker-fix.md`, pass into Agent
