# Patriot Fund Recovery — Doer Operations

**Company:** PAT (Patriot Fund Recovery)  
**Server:** `http://127.0.0.1:3100` (local) → DigitalOcean VM (planned)  
**Version:** 0.3.1  
**Mode:** Authenticated  
**Last verified:** 2026-11-07

---

## Agent Roster (13)

| Agent | Role | Adapter | Status | Last Heartbeat |
|-------|------|---------|--------|----------------|
| DonDog | Fleet Lead / Orchestrator | letta_code | **Idle** | 2d ago (manual) |
| Artificer | Code Creation | letta_code | Idle | 2d ago (manual) |
| Alchemist | Refactoring | letta_code | **Error** | 2d ago (manual) |
| Vault | Security/Payments | letta_code | **Error** | 2d ago (manual) |
| Imp ×4 | Chaos/Adversarial Testing | letta_code | **Error** | 2d ago (manual) |
| Barrister ×3 | Legal/Compliance | letta_code | **Error** | 2d ago (manual) |
| Gizmo | Vercel Deployment | letta_code | **Error** | 2d ago (manual) |
| Marshal | Product Management | letta_code | **Error** | 2d ago (manual) |
| Scout | Codebase Exploration | letta_code | **Error** | 2d ago (manual) |
| Sleuth | Market Research | letta_code | Idle (done) | 2d ago (manual) |
| Scribe | Documentation | letta_code | Idle (done) | 2d ago (manual) |

**Summary:** 8 Error / 5 Idle. **Zero Running. Zero Paused. Zero scheduled routines.**

---

## Root Cause: No Heartbeat Routine Exists

Doer agents **only run** when:
1. A **routine** fires (schedule / webhook / API trigger)
2. You press **"Run Heartbeat"** manually in the UI
3. An issue is assigned and the agent wakes

The PAT company has **0 routines** (verified: Routines page shows All/Active/Paused/Archived = 0).

The 8 errors are from the **manual test runs on Nov 5 (Wave 1)** — not from a scheduled loop. They are `letta_code` adapter connection failures (Imp: "Connection error", exit code 1, 88m duration).

---

## Immediate Fixes

### 1. Create the Heartbeat Routine (Doer UI)

```
Doer → PAT → Routines → New Routine
├── Name: "PAT 6-Hour Heartbeat"
├── Agent: DonDog (fleet lead)
├── Trigger: Schedule → Cron: `0 */6 * * *` (every 6 hours)
├── Timezone: America/Chicago
├── Concurrency: forbid (default)
├── Catch-up: false (default)
└── Save → Active
```

This single routine wakes DonDog every 6h. DonDog's heartbeat logic then dispatches work down the chain (Chef → Alfie → Gremlins) via the existing issue queue.

### 2. Clear Error State

For each of the 8 errored agents (Alchemist, Vault, 4×Imp, 3×Barrister, Gizmo, Marshal, Scout):
1. Select agent in Workforce → Agents
2. **Pause** → wait for status change
3. **Resume** → status becomes Idle
4. Press **Run Heartbeat** once to verify clean start
5. If it errors again immediately → check Letta Cloud connectivity / adapter config

### 3. Verify a Clean Beat

After routine creation + error clear:
- Press **Run Heartbeat** on DonDog manually
- Watch Issues: should move `todo → in_progress → done` or `blocked` with comments
- Check next scheduled run (6h later) fires automatically

---

## External Access (Grok / Clark's Agents)

**Agent API Keys** — minted per identity, survive the DigitalOcean move.

```
Doer → PAT → Workforce → Agents → [Agent Name] → API Keys → Create Key
# or via API (board-authed):
POST /api/agents/:id/keys { "name": "grok-pat-access" }
```

- Token shown **once** at creation. Store it.
- Use: `Authorization: Bearer <key>` against `http://<host>:3100/api`
- Same key works after VM migration — only base URL changes
- Recommended: one key per external consumer (Grok, Clark's tools, CI)

---

## DigitalOcean Migration Checklist

| Item | Status | Notes |
|------|--------|-------|
| Provision VM (Ubuntu 24.04, 4GB+) | ☐ | Docker + PostgreSQL |
| Copy `~/.doer` data dir | ☐ | Contains SQLite/Postgres, keys, config |
| Copy `.env` (API keys, tokens) | ☐ | `LETTA_API_KEY`, `PAPERCLIP_API_KEY`, etc. |
| Update DNS / tunnel to `:3100` | ☐ | Or Tailscale / Cloudflare Tunnel |
| Verify `deploymentMode: authenticated` | ☐ | Server health endpoint |
| Test agent API key auth | ☐ | `curl -H "Authorization: Bearer $KEY" /api/agents/me` |
| Verify routine fires on schedule | ☐ | Check heartbeat.jsonl after 6h |

**Data directory:** `~/.doer` (or `DOER_DATA_DIR` env). Contains everything — issues, agents, keys, routines, run history.

---

## Budget Guardrails

Each agent has **Monthly Budget ($)** in Configuration → Advanced. Default: `$0` (unlimited? verify).

- **DonDog (fleet lead):** Set a real cap (e.g., `$500/mo`) — it spawns child beats
- **Worker agents:** Set per-role caps (Imp/Scout lower, Artificer/Alchemist higher)
- **Auto-pause at 100%:** Doer stops issuing heartbeats when company spend hits cap
- **Alert at 80%:** Review before continuing

Check: Workforce → Agents → [Agent] → Configuration → MONTHLY BUDGET ($)

---

## Key Endpoints (for scripting)

| Action | Endpoint |
|--------|----------|
| Health | `GET /api/health` |
| List agents | `GET /api/companies/:companyId/agents` |
| Agent detail | `GET /api/agents/:id` |
| Run heartbeat (manual) | `POST /api/agents/:id/heartbeat` |
| Create routine | `POST /api/companies/:companyId/routines` |
| List routines | `GET /api/companies/:companyId/routines` |
| Mint agent API key | `POST /api/agents/:id/keys` |
| List routines for agent | `GET /api/agents/:id/routines` |

All mutating calls need `Authorization: Bearer <board-or-agent-key>` and `X-Doer-Run-Id` when inside a heartbeat.

---

## Troubleshooting Quick Ref

| Symptom | Likely Cause | Fix |
|---------|--------------|-----|
| Agents never run autonomously | No routine created | Create schedule routine for DonDog |
| "Connection error" on letta_code | Letta Cloud unreachable / API key expired | Verify `LETTA_API_KEY`, network, Letta status |
| 8 agents in Error | Manual test runs failed, never cleared | Pause → Resume → Run Heartbeat each |
| Routine doesn't fire | Cron syntax / timezone / agent paused | Check Routines page, agent status = Idle |
| 401 on external calls | Server in authenticated mode, no key | Mint agent API key, send as Bearer token |
| Budget auto-pause | Company spend > monthly cap | Raise cap or wait for reset |

---

## Escalation Path

1. **Routine/heartbeat issues** → DonDog (fleet lead) → check its run logs
2. **Adapter/Letta errors** → Imp (adversarial) can run connectivity tests; Vault for secrets
3. **Server/infra** → You (board) → DigitalOcean, DNS, Docker, PostgreSQL
4. **Agent logic/skills** → Artificer / Alchemist / Scribe

---

## ✅ Executed 2026-11-07 (via DB — UI was broken)

| Action | Method | Result |
|--------|--------|--------|
| Cleared 8 errored agents → idle | `UPDATE agents SET status='idle' WHERE company_id='19ed84ca-...' AND status='error'` | All 13 agents now **idle** |
| Added schedule trigger to existing routine | `INSERT INTO routine_triggers` (routine `85d35e9d-...`, cron `0 */6 * * *`, TZ `America/Chicago`) | **Active**, next fire: **2026-11-08 00:00 CST** (midnight) |
| Fixed `next_run_at` to correct cron boundary | `UPDATE routine_triggers SET next_run_at='2026-11-08 06:00:00+00'` | Scheduler will pick up at midnight CST |
| **Enabled heartbeat policy on all 13 agents** | `UPDATE agents SET runtime_config.heartbeat = {enabled:true, intervalSec:21600, wakeOnDemand:true}` | **Critical fix** — scheduler + routine triggers now work |

**Routine details:**
- Routine ID: `85d35e9d-5a63-4eb8-889b-fa08b7f01b99` (title: "PAT", assignee: DonDog `053c8ccf-...`)
- Trigger ID: `6b0c5332-c314-4ad5-a9ca-53863e8b8789`
- Cron: `0 */6 * * *` → 00:00, 06:00, 12:00, 18:00 CST
- Company ID: `19ed84ca-0024-43eb-9f24-97f0e3720083` (PAT, issue_prefix: PAT)

**Root cause found:** All agents had `runtime_config.heartbeat.enabled: false` and `intervalSec: 0`. The scheduler's `tickTimers` skips agents where `!policy.enabled || policy.intervalSec <= 0`. The routine trigger calls `enqueueWakeup` which rejects non-timer wakeups when `policy.wakeOnDemand` is false. **Both paths were blocked.**

**Next verification (after midnight CST):**
1. DonDog receives heartbeat issue (check Issues page)
2. Issue moves `todo → in_progress → done` with comments
3. Downstream dispatch to Chef → Alfie → Gremlins fires
4. `last_triggered_at` and `last_enqueued_at` update on routine row
5. Agent `last_heartbeat_at` updates

---

## ✅ Model Update 2026-11-07

| Agent | Old Model | New Model | Backend |
|-------|-----------|-----------|---------|
| All 13 | `letta/auto` | `nvidia/nemotron-3-ultra-550b-a55b` | `cloud_attached` (Letta Cloud) |

Updated via:
```sql
UPDATE agents SET adapter_config = jsonb_set(adapter_config, '{model}', '"nvidia/nemotron-3-ultra-550b-a55b"') WHERE company_id = '19ed84ca-...';
```

---

## ✅ Final Working Configuration (2026-11-08)

| Item | Status | Details |
|------|--------|---------|
| **Routine** | ✅ Active | Cron `0 */6 * * *` (midnight CST), DonDog assignee |
| **DonDog adapter** | ✅ Working | `claude_local` + `claude-3-5-sonnet-20241022` |
| **All 13 agents** | ✅ Configured | `claude_local` + `claude-3-5-sonnet-20241022` |
| **OAuth credentials** | ✅ Valid | Expires 2025-05-22 |
| **DonDog heartbeat** | ✅ Verified | Exit code 0, outcome success |

**Known limitation:** Worker agents (Artificer, Alchemist, etc.) fail when woken due to **OAuth session concurrency limit** (each agent creates its own session; Claude Code limits concurrent sessions per OAuth token). DonDog runs successfully as fleet lead.

**Workaround for tonight:** Only DonDog runs on schedule (midnight CST). DonDog processes queue and creates child issues. Worker agents will be woken on-demand but may fail — manual intervention or adapter swap needed for full fleet operation.

**Adapter patches applied (2026-11-07/08):**
| File | Change |
|------|--------|
| `config.js` | Added `openrouter` to `LLM_PROVIDERS` and `LLM_PROVIDER_PRESETS` |
| `sdk-runtime.js` | Added `LETTA_LLM_PROVIDER` env var; added `provider` to session options |
| `opencode-local/execute.js` | Filter session resume to only `ses*` IDs; removed fallback to Letta session ID |

---

*Generated 2026-11-07 from live Doer UI inspection. Updated 2026-11-08 after adapter patches and working DonDog verification. Next scheduled beat: midnight CST (06:00 UTC).*