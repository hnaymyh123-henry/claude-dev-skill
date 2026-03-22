# PROJECT_CONTEXT.md Template

> Copy the content below into `PROJECT_CONTEXT.md` at your project root and fill in the actual values.
> The `/dev` skill reads this file at every Phase to restore context.

---

```markdown
# PROJECT_CONTEXT

## Repository Info
- **Repo URL**: https://github.com/[owner]/[repo]
- **Main branch**: main
- **Created**: YYYY-MM-DD

## Tech Stack
- **Language**: Python 3.11 / Node.js 20 / ...
- **Framework**: FastAPI / Express / ...
- **Database**: PostgreSQL / SQLite / ...
- **Test framework**: pytest / Jest / None

## Architecture Decisions
- **Auth scheme**: JWT, stored in HttpOnly Cookie / localStorage
- **API spec**: RESTful, error format `{"error_code": "...", "message": "..."}`, pagination via `?page=&size=`
- **Database migration framework**: Alembic (has existing data) / None (brand new project)
- **API Contract doc**: `API_CONTRACT.md` (exists for full-stack projects)

## Code Style Conventions
- **Naming**: Python snake_case, class names PascalCase
- **Directory structure**:
  ```
  src/
    routers/    # API routing layer
    services/   # Business logic layer
    models/     # Data models
    utils/      # Utility functions
  tests/
  ```
- **Error handling convention**: always raise HTTPException, no business logic in the routing layer

## Completed Features
- [ ] Example: user registration/login (PR #3, merged 2024-01-15)
- [ ] Example: product listing API (PR #5, merged 2024-01-20)

## Current Status
- **Last updated**: YYYY-MM-DD
- **Current iteration goal**: [description of features to complete this round]
- **Known tech debt**: [if any]
- **Open PRs**: #N [description], #M [description]
```
