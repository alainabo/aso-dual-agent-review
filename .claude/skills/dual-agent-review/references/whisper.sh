#!/usr/bin/env bash
# Dual-agent review whisper for {{ME}} (peer reviewer: {{PEER}}).
# SILENT by design: prints nothing (exit 0) unless a proposal is waiting on {{ME}}.
# It only surfaces — it never acts. Follow the review loop in your operating manual.
set -u
DIR="{{REVIEW_DIR}}"
[ -d "$DIR" ] || exit 0
ME="{{ME}}"
PEER="{{PEER}}"

needs_fix=(); needs_countersign=(); needs_review=()
lastline() { grep -nF "$1" "$2" 2>/dev/null | tail -1 | cut -d: -f1; }

for f in "$DIR"/*.md; do
  [ -e "$f" ] || continue
  base=$(basename "$f")
  case "$base" in README.md|TEMPLATE.md|*-PLAN.md|*-diff.md) continue;; esac

  my_box=$(grep -cE "^- \[x\] AGREED — $ME" "$f")
  peer_box=$(grep -cE "^- \[x\] AGREED — $PEER" "$f")

  # DONE: both signed, or already merged/live.
  if [ "$my_box" -ge 1 ] && [ "$peer_box" -ge 1 ]; then continue; fi
  grep -qiE '^\*\*Status:\*\* .*(merged|live)' "$f" && continue

  proposer=""
  grep -qF "**Proposed by:** $ME"   "$f" && proposer="ME"
  grep -qF "**Proposed by:** $PEER" "$f" && proposer="PEER"

  my_review=$(lastline "## Review — $ME" "$f");     my_review=${my_review:-0}
  peer_review=$(lastline "## Review — $PEER" "$f"); peer_review=${peer_review:-0}
  my_rev=$(lastline "## Revision — $ME" "$f");      my_rev=${my_rev:-0}
  peer_rev=$(lastline "## Revision — $PEER" "$f");  peer_rev=${peer_rev:-0}

  if [ "$proposer" = "ME" ]; then
    # I proposed; peer reviews.
    if [ "$peer_box" -ge 1 ] && [ "$my_box" -eq 0 ]; then
      needs_countersign+=("$base")                       # peer approved; I sign to finish
    elif [ "$peer_review" -gt 0 ] && [ "$peer_box" -eq 0 ] && [ "$peer_review" -gt "$my_rev" ]; then
      needs_fix+=("$base")                               # peer requested changes; I haven't revised since
    fi
  elif [ "$proposer" = "PEER" ]; then
    # Peer proposed; I review.
    [ "$my_box" -ge 1 ] && continue                      # I already approved; peer's turn
    if [ "$my_review" -eq 0 ] || [ "$peer_rev" -gt "$my_review" ]; then
      needs_review+=("$base")                            # never reviewed, or peer revised since
    fi
  else
    # Unknown proposer: only the safe checkbox certainty.
    [ "$peer_box" -ge 1 ] && [ "$my_box" -eq 0 ] && needs_countersign+=("$base")
  fi
done

total=$(( ${#needs_fix[@]} + ${#needs_countersign[@]} + ${#needs_review[@]} ))
[ "$total" -eq 0 ] && exit 0

echo "📋 Review pending — waiting on $ME:"
# Length-guard each loop: "${empty[@]}" trips `set -u` on macOS's bash 3.2.
[ "${#needs_fix[@]}" -gt 0 ]         && for b in "${needs_fix[@]}";         do echo "   • $b — $PEER requested changes (needs your fix)"; done
[ "${#needs_countersign[@]}" -gt 0 ] && for b in "${needs_countersign[@]}"; do echo "   • $b — $PEER approved (needs your countersign)"; done
[ "${#needs_review[@]}" -gt 0 ]      && for b in "${needs_review[@]}";      do echo "   • $b — new/updated proposal from $PEER (needs your review)"; done
exit 0
