# Peer Review Protocol

This folder is the shared ground between **{{AGENT_A}}** and **{{AGENT_B}}** — two AI agents that review each other's work before a human ships it. Neither agent works fully autonomously here, and neither agent performs the final act ({{FINAL_ACT}}). {{HUMAN}} runs each agent, one at a time, and stays in control of every ship.

## Why two agents

An agent reviewing its own work has a blind spot: the same reasoning that produced the mistake tends to miss it. A second, independent agent — ideally a different model, always a fresh context — catches what the first cannot: logic errors the author was confident about, claims that overreach, broken assumptions, tone that drifts off-brand, numbers that don't add up. The human stays the final gate. It's the same reason human teams review each other's work, applied to agents.

## What goes through this loop

{{SCOPE}}

Everything else stays single-agent as before.

## Where work-in-progress lives

{{WORK_LOCATION}}

## The loop

1. {{HUMAN}} asks one agent to produce a change (code, document, design, campaign, analysis — whatever this loop is scoped to). That agent does the work, saves it at the work location above, and creates a proposal file here: `YYYY-MM-DD-short-name.md` (copy `TEMPLATE.md`). It fills in the Proposal section — what, why, where the work lives, how it verified the work — and **stops**. It does not ship anything.
2. {{HUMAN}} asks the other agent to review (or that agent's session-start whisper surfaces it). The reviewer opens the work at its stated location, **reads it in full — not just the proposal's summary of it** — checks it against the review criteria below, and appends a `## Review — <its name>` section: **Approved** or **Changes Requested**, with specific comments.
3. If **Changes Requested**, the proposing agent revises the same work item, appends a `## Revision — <its name>` section describing what changed, and it goes back for re-review.
4. Repeat until both agents have checked their `AGREED` box in **Final Status**.
5. Once both AGREE, {{HUMAN}} performs the final act: {{FINAL_ACT}}. Agents never do this step.

## Review criteria

The reviewer checks the work against:

{{REVIEW_CRITERIA}}

Plus always: internal consistency, factual claims that can be checked, and whether the work actually does what the proposal says it does.

## Rules for both agents

- **Never perform the final act.** {{FINAL_ACT_RULE}}
- **Never mark your own proposal AGREED.** Only the *other* agent's sign-off counts as a review. Check only your own box.
- **Never rubber-stamp.** Open the actual work and read it before approving. A review that only read the proposal text is not a review.
- **Keep it specific.** Name files, sections, sentences, numbers. "Looks good" and vague summaries are not acceptable in either direction.

## No-babysitting layer

Each agent runs a silent session-start whisper (`whisper.sh`) that prints a one-line note only when a proposal is waiting on *that* agent — and prints nothing otherwise. {{HUMAN}} never has to relay "the other one reviewed" or re-explain this protocol. See each agent's operating manual for how it's wired.
