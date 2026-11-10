# Patriot Fund Recovery — File Output Repository

This repository organizes the **current file output** of the Donjon Intelligence Systems
Patriot Fund Recovery (PFR) agent org so Clark's Grok agent can clone / pull it over
the network and stay current without asking for a status dump.

**GitHub:** https://github.com/claybowl/patriot-fund-recovery-output (private)

## How Grok keeps up (network pull)

```bash
# Clone once
git clone https://github.com/claybowl/patriot-fund-recovery-output.git
cd patriot-fund-recovery-output

# Pull current output whenever needed (over the network)
git pull
```

If the repo is private, Grok authenticates with a GitHub token:
```bash
git clone https://<TOKEN>@github.com/claybowl/patriot-fund-recovery-output.git
```

## What lives here

| Path | Contents |
|------|----------|
| `output/pdf/` | Formal deliverables (agreements, presentation archives) |
| `donjon-investor-presentation-pages/` | Rendered presentation page images |
| `PAT-OPERATIONS.md` | Doer platform operations (company, agents, routines) |
| `REPLY-TO-CLARK-2026-11-07.md` | Correspondence to Clark / decision register |
| `scripts/daily-output-sync.sh` | Daily maintenance routine (commit + push) |
| `scripts/supervise-output.sh` | Supervision check (detect external / out-of-band changes) |

## Maintenance routine

`scripts/daily-output-sync.sh` stages and commits new or changed file output, then
pushes to GitHub. It is intended to run **once per day** (cron / launchd / Doer
Routine at 6am CT). It only commits when there are changes, so quiet days are no-ops.

## Supervision

`scripts/supervise-output.sh` reports any modifications made **outside** the daily
sync routine (external changes, manual edits, agent drops). Run it on a cadence or
as a pre-flight check before Grok pulls.

## Link to the PAT Goal

This repository is the file-output surface for the **PAT Goal** in the Doer platform:

- **Goal:** `a4b6ac2d-…` — "Create and maintain current PAT knowledge-base repository on GitHub for partners"
- **Project:** `5aff91a0-…` — "PAT File Output Repository (Grok Access)" (lead: DonDog)
- **Routine:** `fb6fdb9e-…` — "PAT Daily Output Sync", cron `0 6 * * *` America/Chicago, runs `scripts/daily-output-sync.sh`

> **Note:** this is a standalone git repo (its own `.git`), separate from the broader
> `donjon.agency` workspace repo. Only PFR file output lives here — exactly what
> Clark's Grok needs to pull.
