# AGENTS.md — Luna Web

> "README for machines." This file guides AI coding assistants working on the Luna Web project.

---

## Overview

Luna Web is a Svelte 4 SPA that serves as the frontend for **Luna** — an AI assistant powered by Kimi Web (via a Chrome/Playwright bridge). The app features real-time SSE streaming, tool execution cards, plan mode, and integrated dashboards (Tasks, Leads, Finance).

**Architecture:**
```
User → Luna Web (Svelte) → luna-server (Node) → luna-soul.cjs → kimi-bridge.cjs → Kimi Web (Chrome)
                                        ↓
                                   luna-tools.cjs → Dashboard API (NEXO)
```

---

## Tech Stack

- **Frontend:** Svelte 4, Vite, vanilla CSS (custom properties), highlight.js
- **Backend:** Node.js, Express, SSE (Server-Sent Events)
- **Bridge:** Playwright + Chrome Extension (DOM observation)
- **Deployment:** PM2 (`luna-server` on port 3458)

---

## Commands

```bash
# Dev (hot reload)
cd /home/jhin/.luna-kernel/luna-web && npm run dev

# Production build
cd /home/jhin/.luna-kernel/luna-web && npm run build

# Restart server after build
pm2 restart luna-server

# Check logs
pm2 logs luna-server
pm2 logs luna-server --err
```

---

## Project Structure

```
luna-web/
├── src/
│   ├── components/          # Svelte components
│   │   ├── ChatArea.svelte       # Main chat — SSE connection, event handlers
│   │   ├── MessagesList.svelte   # Renders message list
│   │   ├── AssistantMessage.svelte
│   │   ├── UserMessage.svelte
│   │   ├── ThinkingBubble.svelte
│   │   ├── TypingIndicator.svelte
│   │   ├── ToolCard.svelte
│   │   ├── Sidebar.svelte        # Session list + search
│   │   ├── TaskDashboardModal.svelte
│   │   ├── LeadDashboardModal.svelte
│   │   └── ConfigDrawer.svelte
│   ├── stores.js            # Svelte stores (messages, sessions, currentMode, etc.)
│   ├── api.js               # HTTP API + SSEManager class
│   ├── utils.js             # formatTime, scrollManager, etc.
│   └── App.svelte
├── dist/                    # GENERATED — never edit manually
├── public/
└── index.html

Backend (sibling to luna-web/):
├── luna-soul.cjs            # Main orchestrator — message loop, tool execution
├── kimi-bridge.cjs          # Playwright bridge to Kimi Web
├── luna-tools.cjs           # Tool implementations (file ops, dashboard APIs)
├── luna-tool-guard.cjs      # Safety guard for destructive operations
└── luna-chat-routes.js      # Express routes for chat API + SSE
```

---

## Code Style

- **Svelte:** Use `<script>` at top, then template, then `<style>`.
- **CSS:** Use CSS custom properties (`--luna-*`). Dark theme only.
- **Naming:** camelCase for JS/variables, kebab-case for CSS classes.
- **Stores:** Import from `../stores.js`. Never create ad-hoc event buses.
- **Icons:** Inline SVGs. Never add icon libraries.

---

## Event Flow (Critical)

```
1. User sends message → POST /api/chat
2. luna-soul.cjs starts processMessageStream()
3. Kimi bridge streams events (thinking_delta, response_delta, action_detected, ...)
4. luna-chat-routes.js stores events in session memory
5. SSE endpoint (/api/chat/stream) polls session every 100ms
6. ChatArea.svelte receives events → updates messages store
7. MessagesList.svelte renders components by message type
```

**Key events:**
- `thinking_start/delta` → ThinkingBubble
- `response_delta` → accumulated in buffer, flushed to AssistantMessage
- `action_start/end` → ToolCard (source of truth for tool state)
- `done` → stream ends

---

## Key Patterns

### Response Buffer (v8.3+)
`response_delta` events are buffered in `ChatArea.svelte` instead of rendered immediately. This prevents raw JSON/tool blocks from appearing during streaming. The buffer is flushed when:
- A complete JSON wrapper is detected
- `response_detected` or `done` arrives

### Thinking vs Instant Mode
- **THINKING/AGENT/SWARM:** Shows ThinkingBubble while processing
- **INSTANT:** Shows TypingIndicator (dots animation), no thinking text

### Tool Card State
ToolCard state is driven SOLELY by `action_start` → `action_end` events from the agent executor. Never rely on DOM mirroring for tool status.

### Deduplication
Multiple layers prevent duplicate tool execution:
1. `kimi-bridge.cjs`: `emittedActionCodes` Set per stream
2. `luna-soul.cjs`: `executedDomActionHashes` Set per message loop
3. `luna-soul.cjs`: `_executedActionCache` Map per session (global, 5min TTL)
4. `luna-tools.cjs`: Idempotency pre-check for createLead/createTask

---

## Safety / Permissions

### Allowed without approval
- Read any source file
- Edit frontend Svelte/CSS
- Run `vite build` on luna-web
- Run linters/formatters
- Restart PM2 processes

### Require approval first
- Modifying `luna-soul.cjs` or `kimi-bridge.cjs` (critical backend)
- Installing new npm packages
- Modifying PM2 ecosystem config
- Git operations (commit, push)
- Deleting files outside `luna-web/src/`

---

## Testing Changes

1. Make frontend changes in `luna-web/src/`
2. Run `cd luna-web && npm run build`
3. If build succeeds: `pm2 restart luna-server`
4. Open browser at `http://localhost:3458`
5. Test the specific feature
6. If broken: check `pm2 logs luna-server` and browser console

**Never commit `dist/` manually** — it is regenerated by `vite build`.

---

## Common Gotchas

- **`dist/` is generated.** Any manual edits are overwritten on build.
- **SSE dedup:** The frontend `processedEventIds` Set prevents duplicate rendering on reconnects. If events look "stale", check the `messageId` filter.
- **Buffer flush:** If assistant text seems delayed, the response buffer may be waiting for a complete JSON block. Check `flushResponseBuffer()` in ChatArea.
- **Chrome Extension:** The extension (`kimi-bridge-interceptor-toolcalls.js`) runs in Chrome's MAIN world. If it fails, the Playwright fallback observer takes over.
- **Mode switching:** `currentMode` store controls thinking vs instant behavior. Always update it via the store, not direct mutation.

---

## When Stuck

- Ask a clarifying question instead of guessing
- Check `pm2 logs` first for backend errors
- Check browser DevTools Network tab for SSE events
- The backup at `backup-luna-web-20260604-193703/` is the last known good version
