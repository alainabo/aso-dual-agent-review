<!--
Paste this block into each agent's operating manual:
  - {{AGENT_A}}'s manual (e.g. CLAUDE.md for Claude Code)
  - {{AGENT_B}}'s manual (e.g. AGENTS.md for Codex, GEMINI.md for Gemini CLI, ...)
Set THIS_AGENT / OTHER_AGENT to match which manual it lives in.
-->

## Peer review loop (with {{OTHER_AGENT}})

You share a review folder with {{OTHER_AGENT}}: `{{REVIEW_DIR}}`. Protocol lives in that folder's `README.md`; proposal format in `TEMPLATE.md`. {{HUMAN}} runs each agent one at a time and performs every final act ({{FINAL_ACT}}) — you never do.

**Session start.** Before other work, run:
`bash '{{WHISPER_PATH}}'`
It prints nothing on ordinary sessions. If it names a proposal waiting on you, act on it per the loop below. If it's silent, proceed normally. (On Claude Code this is also wired as a `SessionStart` hook so it fires automatically; on agents without a hook system, running it yourself at session start is the mechanism.)

**When you produce work in this loop's scope:** do the work, save it at the agreed work location ({{WORK_LOCATION_SHORT}}), create `YYYY-MM-DD-name.md` in the review folder from `TEMPLATE.md`, fill the Proposal section honestly — including what you verified and what you're least sure of — and stop. Tell {{HUMAN}} it's ready for {{OTHER_AGENT}}'s review.

**When you review {{OTHER_AGENT}}'s work:** open the work at its stated location and read it in full — not just the proposal's description of it. Check it against the review criteria in the folder README. Append `## Review — {{THIS_AGENT}}` with **Approved** or **Changes Requested** and specific comments (files, sections, sentences, numbers). If Approved, check only your own `AGREED — {{THIS_AGENT}}` box.

**When {{OTHER_AGENT}} requests changes on your proposal:** revise the same work item, re-verify, append `## Revision — {{THIS_AGENT}}` describing what changed, and leave the AGREED boxes unchecked — it goes back for re-review.

**Hard rules:** Never perform the final act — that's {{HUMAN}}'s alone. Never mark your own proposal AGREED — only {{OTHER_AGENT}}'s sign-off counts. Never rubber-stamp — read the actual work.
