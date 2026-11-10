#!/usr/bin/env bash
#
# Patriot Fund Recovery — output supervision check
#
# Reports modifications under this repo that were made OUTSIDE the daily sync
# routine (external changes, manual edits, agent drops).
#
# Run on a cadence or as a pre-flight check before Grok pulls, so out-of-band
# changes are surfaced rather than silently committed.

set -euo pipefail

REPO="/Users/clay/Desktop/donjon.agency/Patriot Fund Recovery"
cd "$REPO"

echo "== Supervision check: $(date -u +%Y-%m-%dT%H:%M:%SZ) =="
echo

# Uncommitted changes (working tree vs index)
if ! git diff --quiet; then
  echo "UNCOMMITTED CHANGES (working tree):"
  git diff --name-only
  echo
fi

# Staged-but-uncommitted changes (index vs HEAD)
if ! git diff --cached --quiet; then
  echo "STAGED, NOT COMMITTED:"
  git diff --cached --name-only
  echo
fi

# Untracked files (new output not yet admitted to the repo)
untracked=$(git ls-files --others --exclude-standard || true)
if [ -n "$untracked" ]; then
  echo "UNTRACKED (new output, not in repo):"
  echo "$untracked"
  echo
fi

echo "== Supervision check complete =="
