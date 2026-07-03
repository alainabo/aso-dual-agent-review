---
name: check-reviews
description: Use when {{HUMAN}} says "check reviews", "did {{OTHER_AGENT}} review", "any reviews back", "check the review folder", or otherwise wants to know whether the peer agent has left a verdict this agent hasn't acted on — and to act on it. Scans the shared review folder, then applies requested changes, reviews the peer's proposals, or countersigns AGREED — no relaying, no re-explaining the protocol.
---

## What this skill does

Removes the babysitting step from the two-agent review loop. Instead of {{HUMAN}} relaying "{{OTHER_AGENT}} reviewed" and re-explaining what to do, they say **"check reviews"** and this skill does the whole loop: find every proposal waiting on this agent, then act on each one correctly.

It reads `{{REVIEW_DIR}}/*.md`. The protocol source of truth is that folder's `README.md` — if this skill and that README ever disagree, the README wins.

## The hard rules (never violate)

- **Never perform the final act** ({{FINAL_ACT}}). Producing/revising work and updating proposal files is yours; shipping is {{HUMAN}}'s alone.
- **Never mark your own proposal AGREED on the peer's behalf.** Check only the `AGREED — {{THIS_AGENT}}` box, and only when honestly earned.
- **Never rubber-stamp.** Reviewing means opening the actual work at its stated location and reading it in full. Fixing means actually verifying the fix before pushing it back for re-review.

## Procedure

### 1. Scan and classify

List `{{REVIEW_DIR}}/*.md`, skipping `README.md`, `TEMPLATE.md`, and non-proposal files. **Short-circuit DONE first:** if both `- [x] AGREED` boxes are checked, or the `**Status:**` line says shipped/merged/published, classify DONE and move on — checkbox state and Status line are the source of truth, not verdict prose (older files may phrase verdicts differently). For the rest, classify by whose turn it is:

- **NEEDS FIX** — my proposal; peer's latest verdict is Changes Requested and I haven't revised since. → I owe a fix.
- **NEEDS COUNTERSIGN** — my proposal; peer AGREED but my box is unchecked. → I owe a sign-off.
- **NEEDS MY REVIEW** — peer's proposal with no review from me yet, or peer revised after my last review. → I owe a review.
- **AWAITING PEER** — my proposal, peer hasn't responded (or I revised and they haven't re-reviewed). → No action; report it's waiting on them.

Report the full classification up front so {{HUMAN}} sees the whole picture, then act on the actionable ones in date order.

### 2. NEEDS FIX

Read the peer's findings in full. Open the work at its stated location. Fix the findings properly in the work itself — then **re-verify the same way the original proposal was verified** (run the tests, re-render, re-check the numbers, re-read the document end to end). Update the work in place (same branch / same files — never a new location). Append `## Revision — {{THIS_AGENT}}` to the proposal: what changed, how it was re-verified, and where the delta is. Leave both AGREED boxes unchecked. Tell {{HUMAN}} it's back to {{OTHER_AGENT}}.

### 3. NEEDS MY REVIEW

Open the work at its stated location and read all of it — the diff if it's a branch, the full document if it's a file, every changed section. Check it against the review criteria in the folder README, plus internal consistency and any checkable factual claims. Append `## Review — {{THIS_AGENT}}` with **Approved** or **Changes Requested** and specific comments (files, sections, sentences, numbers — never "looks good"). If Approved, check only your own AGREED box.

### 4. NEEDS COUNTERSIGN

Sanity-check the peer's approval is real (a review section written by the peer, not by you). Check your `AGREED — {{THIS_AGENT}}` box and set `**Status:** Agreed — ready for {{HUMAN}} to {{FINAL_ACT_SHORT}}`. Do **not** perform the final act; hand it to {{HUMAN}}.

### 5. Report

End with a compact summary: what was pending, what you did, and what's now waiting on whom. If nothing was actionable: "queue is clear" — say it plainly.
