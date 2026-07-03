# ASO Dual-Agent Review Kit

**By [ASO Ltd.](https://www.asoltd.info) — the digital backbone of African business.**

Make two AI agents review each other's work before you ship it — **without you playing messenger between them.**

Works for **any kind of work**, not just code: documents, marketing content, contracts, financial models, designs, websites. Any two agents: Claude Code + OpenAI Codex, Claude + Gemini CLI, two Claude projects — if it can read a folder and follow an operating manual, it can run this loop.

This is the exact system ASO Ltd. uses in production: every change to our own website is proposed by one agent, adversarially reviewed by the other, and merged only by a human after both sign off. It has caught real bugs neither the author-agent nor a single review would have — dead fallback paths, self-contradicting page copy, a spam honeypot that looked right but could never fire.

---

## The problem this solves

One agent reviewing its own work has a blind spot: the same reasoning that produced the mistake tends to miss it. A second, independent agent — different model, fresh context — catches what the first cannot.

But naïve two-agent setups turn *you* into the bottleneck: you relay "the other one reviewed," re-explain the protocol every session, and babysit every round-trip.

This kit fixes both:

1. **A paper-trail protocol** — proposals, reviews, revisions, and sign-offs live as markdown files in a shared folder. Every decision is auditable.
2. **Silent whispers** — each agent runs a tiny script at session start that prints *one line* only when a proposal is waiting on *that* agent, and nothing otherwise. You open an agent; if it's that agent's turn, it already knows. Near-zero token cost.
3. **Hard rules baked into every file** — agents never ship/merge/publish (you do), never approve their own work, never rubber-stamp. The turn-tracking logic guarantees a proposal is never "waiting on" both agents at once.

## Quick start

1. Copy `.claude/skills/dual-agent-review/` from this repo into your project's `.claude/skills/` folder.
2. Open the project in Claude Code and say: **"set up dual-agent review"**.
3. Answer the ~6-question interview: which two agents, what kind of work, where work-in-progress lives (git branches or draft files), what the human's final act is (merge / publish / send / sign), and what the reviewer should check against.
4. The skill installs everything, adapted to your answers, and verifies the whispers before declaring done.

Day-to-day after that:

- You: *"make X change"* → Agent A does it + writes a proposal, stops.
- You open Agent B → its whisper says a proposal awaits → it reviews for real.
- Changes requested? Agent A's next session whisper tells it. Fixed, re-reviewed, both agree.
- You perform the final act. That's the only part that's yours — as it should be.

On the Claude Code side you also get **`/check-reviews`** — one phrase that scans the queue, classifies whose turn it is, and does whatever this agent owes: fix, review, or countersign.

## What gets installed

| Piece | What it does |
|---|---|
| `agent-review/README.md` | The protocol, adapted to your domain — the source of truth both agents follow |
| `agent-review/TEMPLATE.md` | Proposal format: what/why/where the work lives, verification done, *what the reviewer should scrutinize* |
| `whisper.sh` × 2 | Per-agent silent session-start check — surfaces only, never acts |
| Manual sections | Pasted into each agent's `CLAUDE.md` / `AGENTS.md` / equivalent — wires the whisper + teaches the rules |
| `/check-reviews` skill | The no-babysitting trigger for the Claude Code side |

## Design choices that matter

- **The proposal file format is the stable interface.** `Proposed by:`, `## Review — <name>`, `## Revision — <name>`, and two `AGREED` checkboxes. Anything that reads/writes these stays compatible — customize everything else freely.
- **The proposer must declare what it verified and where it's least confident.** That one field is worth more than the rest of the proposal combined.
- **Whispers are exhaustively turn-aware.** Proposal awaiting first review → only the reviewer hears. Changes requested and unaddressed → only the proposer. Revised → only the reviewer. Approved awaiting countersign → only the proposer. Done → silence. Tested on macOS's default bash 3.2.
- **Two agents, not three.** A third reviewer triples cost for diminishing returns. The human is the third reviewer.

## Want this wired into your business?

Installing the kit takes minutes. Designing the workflows around it — what your agents should build, review, and automate across payments, logistics, and operations — is what **ASO Ltd.** does for clients across Cameroon and Central Africa. **AI & Intelligent Automation** is one of our eight service lines, built for XAF, MTN/Orange Mobile Money, French and English.

- **Talk to us:** [consult@asoltd.info](mailto:consult@asoltd.info) — we respond within 24 hours
- **See what we build:** [www.asoltd.info](https://www.asoltd.info)

**More free tools from ASO:** [AIOS Starter — Claude Edition](https://github.com/alainabo/aso-aios-starter-claude) · [AIOS Starter — Codex Edition](https://github.com/alainabo/codex-aios-template)

## License

MIT License. © 2026 ASO Ltd.
