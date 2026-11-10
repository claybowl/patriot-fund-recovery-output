#!/usr/bin/env bash
#
# Patriot Fund Recovery — output supervision check
#
# Reports modifications under Patriot Fund Recovery/ that were made OUTSIDE the
# daily sync routine (external changes, manual edits, agent drops).
#
# Use: run on a cadence or as a pre-flight check before Grok pulls, so out-of-band
# changes are surfaced rather than silently committed.

set -euo pipefail

REPO="/Users/clay/Desktop/donjon.agency"
PFR="Patriot Fund Recovery"
cd "$REPO"

echo "== Supervision check: $(date -u +%Y-%m-%dT%H:%M:%SZ) =="
echo

# Uncommitted changes (working tree vs index)
if ! git diff --quiet -- "$PFR" 2>/dev/null; then
  echo "UNCOMMITTED CHANGES (working tree):"
  git diff --name-only -- "$PFR"
  echo
fi

# Staged-but-uncommitted changes (index vs HEAD)
if ! git diff --cached --quiet -- "$PFR" 2>/dev/null; then
  echo "STAGED, NOT COMMITTED:"
  git diff --cached --name-only -- "$PFR"
  echo
fi

# Untracked files (new output not yet admitted to the repo)
untracked=$(git ls-files --others --exclude-standard -- "$PFR" 2>/dev/null || true)
if [ -n "$untracked" ]; then
  echo "UNTRACKED (new output, not in repo):"
  echo "$untracked"
  echo
fi

echo "== Supervision check complete =="
