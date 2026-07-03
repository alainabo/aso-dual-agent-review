---
name: dual-agent-review
description: Use when someone wants two AI agents to review each other's work before a human ships it — for ANY kind of work, not just code: documents, marketing content, designs, contracts, analyses, spreadsheets, websites. Triggers include "set up dual-agent review", "peer review between my agents", "make my agents check each other", "review without babysitting", "second opinion agent", or wanting to install this workflow in a new project. Interviews the user about their domain, then installs the shared review folder, proposal template, silent whispers, per-agent manual sections, and a /check-reviews skill — all adapted to their work.
---

## What this skill does

Installs a **dual-agent peer-review system**: two AI agents (any pair — Claude Code + Codex, Claude + Gemini CLI, two Claude projects, ...) that review each other's work before a human performs the final act. Works for any domain — code, documents, marketing campaigns, legal drafts, financial models, designs. The user answers a short interview; everything installed is adapted to their answers.

**The idea in one paragraph:** An agent reviewing its own work has a blind spot — the same reasoning that produced the mistake tends to miss it. A second, independent agent catches what the first cannot. The human stays the final gate but stops being the messenger: silent session-start "whispers" tell each agent when work is waiting on it, so the human never has to relay "the other one reviewed" or re-explain the protocol. Ship quality goes up; babysitting goes to zero.

**What gets installed:**

1. **A shared review folder** (`<project>/agent-review/` by default) with a protocol `README.md` and a proposal `TEMPLATE.md` — the paper trail both agents write to.
2. **One whisper script per agent** — a silent bash script that scans the review folder and prints a one-line note *only* when a proposal is waiting on that specific agent (needs fix / needs countersign / needs review). Silent otherwise: near-zero token cost.
3. **A manual section per agent** — pasted into each agent's operating manual (`CLAUDE.md`, `AGENTS.md`, etc.) wiring the whisper to session start and teaching the propose/review/revise rules.
4. **A `/check-reviews` skill** (for the Claude Code side) — one trigger phrase that scans, classifies whose turn it is, and acts: fixes findings, reviews peer proposals, countersigns approvals.

All template sources live in `references/` with `{{PLACEHOLDER}}` slots. Read them, fill them from the interview, write them to their destinations. Do not invent your own protocol text — adapt these.

## Step 1 — Interview (keep it to ~6 questions, one message)

Ask, with sensible defaults offered:

1. **The two agents.** Which two? (Default: Claude Code + Codex.) What operating-manual file does each read at session start? (Claude Code → `CLAUDE.md`; Codex → `AGENTS.md`; Gemini CLI → `GEMINI.md`; another Claude project → its own `CLAUDE.md`.)
2. **The work.** What kind of work goes through this loop? (Code in a git repo / documents / marketing content / designs / mixed.) This drives the scope wording and review flavor.
3. **Where work-in-progress lives.** Git branches (which integration branch)? Draft files in a folder? Cloud doc links? The reviewer must be able to open the actual work from what the proposal says.
4. **The final act.** What does the human do when both agents agree — merge to main? publish the post? send the contract? sign off the report? This exact phrase goes into the never-do rules.
5. **Review criteria.** What should the reviewer check against? Existing guardrail files (brand guide, style guide, coding standards, legal checklist) — get paths; or offer to draft a starter criteria list from their answers.
6. **Locations.** Project root, review-folder path (default `<root>/agent-review/`), and the human's name.

## Step 2 — Install

1. Create the review folder. Write `README.md` from `references/review-folder-README.md` and `TEMPLATE.md` from `references/proposal-TEMPLATE.md`, filling every `{{PLACEHOLDER}}` from the interview. In the README, `{{WORK_LOCATION}}` should describe git branching if they chose git (feature branches from the integration branch, never direct to the shipping branch) or the drafts folder/doc convention otherwise.
2. Generate both whispers from `references/whisper.sh`: substitute `{{REVIEW_DIR}}` (absolute path), `{{ME}}`/`{{PEER}}` (the agent names exactly as they'll appear in proposal files). Write agent A's copy somewhere agent A owns (e.g. `.claude/hooks/review-whisper.sh`) and agent B's copy in agent B's workspace. `chmod +x` both.
3. Wire session start. For Claude Code: add a `SessionStart` hook to `.claude/settings.local.json` (create or extend `hooks.SessionStart` with a `command` entry running the script — preserve existing settings, validate JSON after). For agents without hooks (Codex, most CLIs): the manual section's "run this at session start" instruction *is* the mechanism — put it at the very top of that agent's manual.
4. Paste the manual section from `references/manual-section.md` into each agent's operating manual, placeholders filled per side.
5. Install `/check-reviews` for the Claude Code side: write `references/check-reviews-skill.md` (placeholders filled) to `.claude/skills/check-reviews/SKILL.md`.

## Step 3 — Verify before declaring done (do not skip)

1. `bash -n` both whispers, then run both against the real (empty) review folder — both must exit 0 **silently**.
2. Simulate the states in a temp folder (point a sed-patched copy of each whisper at it): proposal awaiting first review → only the reviewer's whisper fires; Changes Requested unaddressed → only the proposer's fires; revised → only the reviewer's; countersign pending → only the proposer's; both-agreed → neither. **No state may trigger both whispers at once.** Run with the OS default shell (macOS ships bash 3.2 — the template's length-guarded array loops exist for exactly that; keep them).
3. Validate any JSON you touched. Confirm each manual reads coherently where you pasted.
4. Walk the user through one dry run: have them ask agent A for a trivial change, watch the proposal appear, ask agent B to review, watch the whisper fire on the next session.

## Hard rules to preserve in everything you install

These are the load-bearing rules — every installed artifact must carry them:

- **Agents never perform the final act.** The human ships, merges, publishes, sends, signs. Always.
- **No agent ever marks its own proposal AGREED.** Only the peer's sign-off counts.
- **No rubber-stamping.** A review that didn't open the actual work is not a review.
- **Whispers only surface — they never act.** Acting is triggered by the human (or by the agent reading its manual at session start), never by the hook itself.
- **One turn at a time.** The classification logic (proposer vs reviewer, last-revision vs last-review ordering) must guarantee a proposal is never "waiting on" both agents simultaneously.

## Customizing further

Users can rename sections, add review rounds, or add a third agent (the whisper generalizes: one copy per agent, `{{PEER}}` becomes a check across the others' boxes — but tell them two is the sweet spot; three agents triples cost for diminishing returns). The proposal file format is the stable interface — anything that writes/reads `Proposed by:`, `## Review — <name>`, `## Revision — <name>`, and the AGREED checkboxes stays compatible.
