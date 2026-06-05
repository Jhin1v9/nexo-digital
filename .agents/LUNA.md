# 🌙 AGENTE — Luna AI Kernel

> **Contexto específico** para agentes IA trabalhando na Luna Kernel.
> Leia `.agents/GLOBAL.md` primeiro para contexto da empresa.

---

## 📁 Estrutura da Luna

```
luna-kernel/
├── luna-web/                        ← Interface Web (Svelte)
│   ├── src/
│   │   ├── App.svelte               ← Main app
│   │   ├── api.js                   ← API client (dashboard + Kimi)
│   │   ├── stores.js                ← Svelte stores
│   │   ├── components/                ← UI components
│   │   │   ├── ChatArea.svelte
│   │   │   ├── ChatInput.svelte
│   │   │   ├── ChatHeader.svelte
│   │   │   ├── AssistantMessage.svelte
│   │   │   ├── ConfigDrawer.svelte
│   │   │   ├── LunaMascot.svelte
│   │   │   ├── LunaStage.svelte
│   │   │   ├── Sidebar.svelte
│   │   │   ├── TaskDashboardModal.svelte
│   │   │   ├── FinanceDashboardModal.svelte
│   │   │   ├── LeadDashboardModal.svelte
│   │   │   └── ...
│   │   └── lib/
│   │       ├── slashCommands.js
│   │       ├── starAnimations.js
│   │       ├── starData.js
│   │       └── voiceService.js
│   ├── public/mascot/               ← SVG assets
│   └── package.json
│
├── luna-extension/                  ← Chrome Extension
│   ├── manifest.json
│   ├── background.js
│   ├── content.js
│   ├── injected.js
│   └── offscreen.js
│
├── config/                          ← Configurações
│   ├── luna-config.js
│   └── luna-prompt-config.json
│
├── cookies/                         ← Cookies Kimi (não versionados)
│   ├── kimi-master-cookies.json
│   └── kimi-master-localstorage.json
│
├── plans/                           ← Planos de projeto
│
└── Core Engine (root)
    ├── kimi-bridge.cjs              ← Bridge principal Kimi (262KB)
    ├── luna-soul.cjs                ← Personalidade/behavior (175KB)
    ├── luna-tools.cjs               ← Tool definitions (90KB)
    ├── luna-cli.cjs                 ← CLI interface
    ├── luna-workspace.cjs           ← Workspace manager
    ├── luna-git.cjs                 ← Git helper
    ├── luna-code-validator.cjs      ← Code validation
    ├── luna-tool-guard.cjs          ← Tool safety guard
    ├── computer-use-engine.cjs      ← Computer automation
    ├── meta-executor-secure.cjs     ← Secure execution
    ├── response-stream-parser.cjs   ← Stream parser
    ├── session-manager.cjs          ← Session management
    ├── telegram-luna-adapter.cjs    ← Telegram bot
    ├── webbridge-client.cjs         ← WebSocket client
    ├── save-master-cookies.cjs      ← Cookie persistence
    ├── save-master-session.cjs      ← Session persistence
    ├── test-dashboard-tools.cjs     ← Dashboard tool tests
    ├── patch-luna-soul.js         ← Soul patches
    ├── patch-loop-fix.js          ← Loop fixes
    ├── install.sh                 ← Install script
    └── luna-watchdog.sh           ← Process watchdog
```

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia |
|--------|------------|
| **Frontend** | Svelte + Vite + Tailwind CSS |
| **Backend** | Node.js + Express (local) |
| **Bridge** | kimi-bridge.cjs (WebSocket + HTTP) |
| **Extension** | Chrome Extension Manifest V3 |
| **Telegram** | Bot API via telegram-luna-adapter.cjs |
| **Deploy** | Local PC (/home/jhin/.luna-kernel) |

---

## 🔧 Tools Disponíveis (luna-tools.cjs)

A Luna pode executar as seguintes ferramentas via JSON commands:

| Tool | Descrição | Projeto |
|------|-----------|---------|
| `readFile` | Ler arquivo | Ambos |
| `writeFile` | Escrever arquivo | Ambos |
| `replaceInFile` | Substituir texto | Ambos |
| `appendFile` | Adicionar ao arquivo | Ambos |
| `deleteFile` | Deletar arquivo | Ambos |
| `viewDirectory` | Listar diretório | Ambos |
| `searchFiles` | Buscar arquivos | Ambos |
| `grep` | Buscar texto | Ambos |
| `executeShell` | Executar comando shell | Ambos |
| `executeScript` | Executar script | Ambos |
| `gitStatus` | Git status | Ambos |
| `gitCommit` | Git commit | Ambos |
| `searchWeb` | Buscar web | Ambos |
| `fetchURL` | Fetch URL | Ambos |
| `browser` | Navegar browser | Luna |
| `downloadFile` | Download | Luna |
| `clipboardRead` | Ler clipboard | Luna |
| `clipboardWrite` | Escrever clipboard | Luna |
| `dashboardCreateTask` | Criar tarefa | Dashboard |
| `dashboardListTasks` | Listar tarefas | Dashboard |
| `dashboardCompleteTask` | Completar tarefa | Dashboard |
| `dashboardCreateLead` | Criar lead | Dashboard |
| `dashboardListLeads` | Listar leads | Dashboard |
| `dashboardCreatePayment` | Criar pagamento | Dashboard |
| `dashboardListPayments` | Listar pagamentos | Dashboard |
| `dashboardCreateExpense` | Criar despesa | Dashboard |
| `dashboardListExpenses` | Listar despesas | Dashboard |
| `dashboardGetCashBox` | Ver caixa | Dashboard |
| `dashboardAddCashEntry` | Add entrada caixa | Dashboard |
| `dashboardCreateQuote` | Criar orçamento | Dashboard |
| `dashboardListQuotes` | Listar orçamentos | Dashboard |
| `dashboardSendEmail` | Enviar email | Dashboard |
| `dashboardListEmails` | Listar emails | Dashboard |
| `dashboardSendWhatsApp` | Enviar WhatsApp | Dashboard |
| `dashboardGetWhatsAppHistory` | Histórico WhatsApp | Dashboard |
| `dashboardGetSystemStatus` | Status sistema | Dashboard |
| `dashboardGetSystemLogs` | Logs sistema | Dashboard |
| `dashboardListNotifications` | Notificações | Dashboard |
| `dashboardListUsers` | Usuários | Dashboard |
| `dashboardListGitHubRepos` | Repos GitHub | Dashboard |
| `dashboardListVercelProjects` | Projetos Vercel | Dashboard |
| `dashboardGetFinanceSummary` | Resumo financeiro | Dashboard |
| `dashboardCreateIdea` | Criar ideia | Dashboard |
| `dashboardListIdeas` | Listar ideias | Dashboard |
| `openDebugTerminal` | Terminal debug | Dashboard |

---

## 🧠 Arquitetura Core

### kimi-bridge.cjs (262KB)
- Conecta com API Kimi (WebSocket + HTTP)
- Intercepta tool calls
- Formata JSON commands
- Gerencia streaming de respostas

### luna-soul.cjs (175KB)
- Personalidade da Luna
- Regras de comportamento
- Prompts por contexto
- Memory management

### luna-tools.cjs (90KB)
- Definições de todas as tools
- Schema validation
- Error handling
- Tool routing

---

## ⚠️ Regras de Código

1. **Node.js**: CommonJS (.cjs) para compatibilidade
2. **Svelte**: Componentes reativos, stores centralizados
3. **Chrome Ext**: Manifest V3, service workers
4. **Cookies**: NUNCA versionar — `.gitignore` ativo
5. **Backups**: `*.bak.*` e `backup-*` ignorados

---

## 📦 Scripts Úteis

```bash
cd luna-kernel
npm install
npm start              # Inicia core engine
node luna-cli.cjs      # CLI interativo
node luna-soul.cjs     # Test soul
node luna-tools.cjs    # Test tools
```

---

## 🔗 Integração com Dashboard

A Luna se comunica com o Dashboard via:
- **API**: `luna-web/src/api.js` → Dashboard backend
- **Extension**: `injected.js` → intercepta Kimi web
- **Telegram**: `telegram-luna-adapter.cjs` → notificações

---

*Atualizado: 2026-06-05 | Projeto: Luna AI Kernel v6.1*
