# Patriot Fund Recovery — File Output Repository

This repository organizes the **current file output** of the Donjon Intelligence Systems
Patriot Fund Recovery (PFR) agent org so Clark's Grok agent can clone / pull it and
stay current without asking for a status dump.

## What lives here

| Path | Contents |
|------|----------|
| `output/pdf/` | Formal deliverables (agreements, presentation archives) |
| `donjon-investor-presentation-pages/` | Rendered presentation page images |
| `PAT-OPERATIONS.md` | Doer platform operations (company, agents, routines) |
| `REPLY-TO-CLARK-2026-11-07.md` | Correspondence to Clark / decision register |
| `scripts/daily-output-sync.sh` | Daily maintenance routine (commit new/changed output) |
| `scripts/supervise-output.sh` | Supervision check (detect external / out-of-band changes) |

## How Grok keeps up

```bash
# Clone once
git clone /Users/clay/Desktop/donjon.agency  # or the remote URL once added
cd donjon.agency

# Pull current output whenever needed
git pull
```

The repo is maintained **daily** by `scripts/daily-output-sync.sh` (see below). Grok
can `git pull` at any time to see the latest committed output.

## Maintenance routine

`scripts/daily-output-sync.sh` stages and commits new or changed file output under
`Patriot Fund Recovery/`. It is intended to run once per day (cron / launchd). It only
commits when there are changes, so it produces no noise on quiet days.

## Supervision

`scripts/supervise-output.sh` reports any modifications under `Patriot Fund Recovery/`
that were made **outside** the daily sync routine (external changes, manual edits, agent
drops). Run it on a cadence or as a pre-flight check before Grok pulls.

## Link to the PAT Goal

This repository is the file-output surface for the **PAT Goal** in the Doer platform.
A Doer **Project** is linked to that goal, and a **Routine** (daily) drives
`daily-output-sync.sh` so the repo stays current without manual intervention.

> **Note:** no remote is configured yet. Grok can pull from the local path today. Add a
> remote (GitHub / etc.) and `git remote add origin <url>` when Clark wants remote access.
