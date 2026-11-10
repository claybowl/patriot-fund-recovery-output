#!/usr/bin/env bash
#
# Patriot Fund Recovery — daily output sync routine
#
# Keeps the git repository of PFR file output current so Clark's Grok agent can
# pull the latest work. Stages + commits new/changed output; no-op on quiet days.
#
# Intended cadence: once per day (cron / launchd / Doer Routine).
#
# Linked to: PAT Goal → Project (file output) → Routine (this script, daily).

set -euo pipefail

REPO="/Users/clay/Desktop/donjon.agency"
PFR="Patriot Fund Recovery"

cd "$REPO"

# Stage the surfaces that constitute "current output".
git add \
  "$PFR/output" \
  "$PFR/donjon-investor-presentation-pages" \
  "$PFR/PAT-OPERATIONS.md" \
  "$PFR/REPLY-TO-CLARK-2026-11-07.md" \
  "$PFR/Donjon Investor Brief.html" \
  "$PFR/Donjon_Investment_Presentation.html"

# Only commit when there is something to commit.
if git diff --cached --quiet; then
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) daily-sync: no output changes"
  exit 0
fi

git commit -m "chore(pfr): daily output sync $(date -u +%Y-%m-%d)

Auto-committed by scripts/daily-output-sync.sh.
Organizes Patriot Fund Recovery file output for Clark's Grok agent pull."

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) daily-sync: committed"
