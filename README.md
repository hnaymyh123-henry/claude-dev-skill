# /dev — AI-Assisted Multi-Agent Development SOP for Claude Code

[中文版](./README.zh.md)

A custom skill for [Claude Code](https://claude.com/claude-code) that turns Claude into a **Tech Lead** coordinating multiple AI Worker Agents through a complete software development workflow — from requirements alignment to PR merge.

---

## What It Does

`/dev` is a **multi-agent software development SOP** covering:

- **Phase 0** — Request classification & routing (New Project / New Feature / Bug Fix / Emergency Hotfix / Architectural Change / Refactoring)
- **Phase 1** — Product alignment (uses your existing PRD, or generates one in two rounds)
- **Phase 2** — Architecture decisions + task decomposition + GitHub Issue creation
- **Phase 3** — Multiple Worker Agents developing **in parallel** (each in an isolated worktree)
- **Phase 3.5** — QA Agent static verification
- **Phase 4** — Code Review + merge (7-item structured checklist with mandatory veto conditions)
- **Phase 5** — Retro + next iteration loop

### Key Features

- **Tech Lead iron rule**: main conversation never writes code directly — all changes go through Worker Agent → PR → Review
- **6-category counterexample self-check**: Worker Agents must cover Null / Empty / Boundary / External failure / Concurrency / Malicious input before submitting
- **Pre-coding conflict check**: Worker Agents scan other open Issues for file overlap before starting
- **Post-merge PR coordination**: after every merge, scans open PRs and notifies branches that need rebase
- **Security gate**: `bandit` + `pip-audit` / `npm audit` run mandatorily before Review
- **Database migration guard**: direct DDL operations (ALTER TABLE / DROP COLUMN) trigger mandatory veto

---

## Requirements

| Tool | Notes |
|------|-------|
| [Claude Code](https://claude.com/claude-code) | Anthropic's official CLI, login required |
| [GitHub CLI (`gh`)](https://cli.github.com/) | For Issues, PRs, repos — run `gh auth login` first |
| Git | Version control |

---

## Installation

**Option 1: Script (recommended)**

```bash
# macOS / Linux — install English version
bash install.sh --lang en

# macOS / Linux — install Chinese version
bash install.sh --lang zh

# Windows PowerShell — English
.\install.ps1 -Lang en

# Windows PowerShell — Chinese
.\install.ps1 -Lang zh
```

**Option 2: Manual**

Copy all files from `en/commands/` (or `zh/commands/`) into `~/.claude/commands/`, keeping the directory structure:

```
~/.claude/commands/
  dev.md
  dev/
    phase1.md
    phase2.md
    phase3.md
    phase4.md
    worker-new.md
    worker-fix.md
    qa-agent.md
    PROJECT_CONTEXT_TEMPLATE.md
```

---

## Usage

In Claude Code, type:

```
/dev [optional description]
```

Examples:
```
/dev I want to build a Todo app with user registration and task management
/dev
```

Claude will automatically classify the request type and enter the corresponding flow.

---

## Repository Structure

```
claude-dev-skill/
├── README.md               # This file (English)
├── README.zh.md            # Chinese version
├── LICENSE
├── install.sh              # macOS/Linux installer
├── install.ps1             # Windows installer
├── en/                     # English skill files
│   └── commands/
│       ├── dev.md
│       └── dev/
│           ├── phase1.md ~ phase4.md
│           ├── worker-new.md
│           ├── worker-fix.md
│           ├── qa-agent.md
│           └── PROJECT_CONTEXT_TEMPLATE.md
└── zh/                     # Chinese skill files (中文版)
    └── commands/
        └── dev/ ...
```

---

## Scope

**Best suited for:**
- New small-to-medium web backend / API projects
- Feature modules with an existing PRD that need systematic development
- Parallel multi-feature development where you want to avoid merge conflicts

**Not suited for:**
- Projects requiring production deployment (no DevOps/deployment capability)
- Complex database migrations with large amounts of existing data
- High compliance security requirements (finance, healthcare)

---

## License

MIT — see [LICENSE](./LICENSE)
