# Reply to Clark — 2026-11-07

**Delivered.** Posted to the PFR HQ Notion page as the section "Reply to Clark — Nov 7" (directly above the 🚦 Decision Register), plus a top-level page comment for notification.
Page: https://app.notion.com/p/3f2d16eb335c80029c38d2da809678f3
Comment id: 412d16eb-335c-81e2-a020-001dbd1b7805

---

"All as recommended" clears #1 and #4 — but two of the six are already settled by Clark's own 11-05 reorientation. Confirm the rest individually rather than blanket-approving.

**Already resolved — no action needed**
- **#1 Texas — OUT.** In line with the 11-05 Florida-only pilot. Returns later as a Bag 3 counsel-handoff lane only, after Tennessee handoffs prove out. Counsel declines = auto-close.
- **#4 Tax-deed vs mortgage-foreclosure — settled 11-05.** Foreclosure under Fla. Stat. § 45.033 is the pilot path; tax-deed only where the current clerk instruction confirms payment to an assignee. Supersedes the tax-deed-first rec. Separate statutes, clocks, caps — lanes never bleed.

**Needs your confirm**
- **#2 Georgia — parked for the pilot.** Proposed wave-1 stance: allowlist-first — counsel-signed modules only, never Gwinnett.
- **#3 Assignment vs owner-pay — two different questions.** Pilot already runs the assignment lane (Florida Bag 1, § 45.033, signed assignment before contact). For the wave-1 *general* default we propose owner-pay: Oklahoma forces it, removes the assignment-drafting risk surface. Revisit once collections prove out.
- **#6 SOC 2 Type II — none.** Substitute: written security commitment — DPA, encryption at rest and in transit, access control, breach notification. Never promised in customer-facing material.

**Needs a fact only Clark has**
- **#5 Licensure.** Does Donjon Capital / PFR hold any relevant license — collection agency, PI, anything? Assuming none → strictly unlicensed lane: owner-pay + counsel handoffs, no filing, UPL respected everywhere.

**The 401 — deliberate lockdown, not a lockout**
- Doer server moved to authenticated mode ahead of the DigitalOcean move. Nothing to scrape.
- Grok gets a scoped **agent API key** minted for its identity in the PAT company: Doer app → agent → **API Keys**, or `POST /api/agents/:id/keys`.
- One token, shown once. Send as `Authorization: Bearer <key>` to `http://<host>:3100/api`.
- Same key survives the VM move — only the base URL changes.
- Name the agent identity to mint under and it's issued.

**On the page**
The 🚦 Decision Register carries live status of all six. Grok: use the register as current state, not the individual recommendations.
