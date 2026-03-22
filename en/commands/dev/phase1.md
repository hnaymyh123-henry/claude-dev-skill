# Phase 1 — Product Alignment

---

## Situation A: User provides a PRD or requirements document

**Goal: clarify only what is ambiguous, do not rewrite the user's document.**

1. Read the user's document carefully
2. Check against the minimum threshold — only proceed to Phase 2 if **all three** are met:
   - [ ] Core features are listed (not just goals)
   - [ ] At least one user scenario or usage context is described
   - [ ] Technical constraints or exclusions are mentioned
3. If the threshold is not met, ask **at most 5 questions at once**, filtered by engineering impact:
   - Different schema → ask
   - Different UI flow → ask
   - Module existence uncertainty → ask
   - Tech stack selection → ask
   - Wording preference / color / copy → do NOT ask
4. After the user answers, output a **confirmation summary** (3–5 bullet points, your own words), then enter Phase 2

---

## Situation B: User provides no document

**Goal: generate a PRD in at most 2 rounds of questions.**

**Round 1 — ask all foundational questions at once (max 3 questions):**
- What problem does this solve, and who uses it?
- What are the 3 most important features? What explicitly will NOT be built?
- Any tech constraints? (language, deployment environment, integrations)

**Round 2 — only ask if Round 1 answers are still ambiguous (max 3 questions, strictly necessary).**

After Round 2, output the PRD:

```
## Project Name
## Goal (one sentence)
## Users & Scenarios
## Core Feature List (each independently developable)
## Out of Scope
## Success Criteria
## Technical Constraints
```

4. **Only enter Phase 2 after the user explicitly confirms ("yes", "looks good", "proceed", etc.)**

---

## Prohibited behaviors

- Do not enter development before the user confirms scope
- Do not assume any unclear requirements
- Do not rewrite or "improve" the user's existing PRD — only clarify ambiguities
