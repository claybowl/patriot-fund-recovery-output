#!/usr/bin/env bash
#
# Patriot Fund Recovery — daily output sync routine
#
# Keeps the PFR file-output git repository current so Clark's Grok agent can
# pull the latest work over the network (https://github.com/claybowl/patriot-fund-recovery-output).
# Stages + commits new/changed output; no-op on quiet days.
#
# Intended cadence: once per day (cron / launchd / Doer Routine).
# Linked to: PAT Goal → Project → Routine (this script, daily 6am CT).

set -euo pipefail

REPO="/Users/clay/Desktop/donjon.agency/Patriot Fund Recovery"
cd "$REPO"

# Stage the surfaces that constitute "current output".
git add \
  output \
  donjon-investor-presentation-pages \
  PAT-OPERATIONS.md \
  REPLY-TO-CLARK-2026-11-07.md \
  "Donjon Investor Brief.html" \
  Donjon_Investment_Presentation.html

# Only commit when there is something to commit.
if git diff --cached --quiet; then
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) daily-sync: no output changes"
  exit 0
fi

git commit -m "chore(pfr): daily output sync $(date -u +%Y-%m-%d)

Auto-committed by scripts/daily-output-sync.sh.
Organizes Patriot Fund Recovery file output for Clark's Grok agent pull."

# Push to GitHub so Grok can pull over the network.
git push origin master >/dev/null 2>&1 || \
  echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) daily-sync: commit done, push skipped (no network/auth)"

echo "$(date -u +%Y-%m-%dT%H:%M:%SZ) daily-sync: committed + pushed"
