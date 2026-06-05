# Relatório de Testes — Dashboard Tools

**Data:** 2026-06-04T18:50:23.252Z
**Total:** 47 | ✅ 38 | ❌ 9 | ⚠️ 0 | ⏭️ 0
**Taxa de sucesso:** 80.9%

## Health

| Tool | Status | Detalhe |
|------|--------|---------|
| getSystemStatus | ✅ PASS | 🖥️ Sistema: OK \| Backend: [object Object] \| Frontend: [object Object] |
| getSystemLogs | ✅ PASS | 📝 Logs: âœ¨ === LUNA v19.0 "MODO CONCIERGE" === âœ¨ [EXTRAORDINARY] [2026-05-18 |

## Tasks

| Tool | Status | Detalhe |
|------|--------|---------|
| createTask | ✅ PASS | ✅ Tarefa criada: [TEST-1780599010124] Tarefa de Teste (ID: 1780599011500) |
| listTasks | ✅ PASS | 📋 63 tarefa(s): - [pending] [TEST-1780599010124] Tarefa de Teste (P: medium) -  |
| updateTask | ✅ PASS | ✏️ Tarefa 1780599011500 atualizada. |
| addComment | ✅ PASS | 💬 Comentário adicionado à tarefa 1780599011500. |
| completeTask | ✅ PASS | ✅ Tarefa 1780599011500 marcada como concluída. |
| deleteTask | ✅ PASS | 🗑️ Tarefa 1780599011500 excluída. |

## Leads

| Tool | Status | Detalhe |
|------|--------|---------|
| createLead | ✅ PASS | ✅ Lead criado: [TEST-1780599010124] Lead de Teste (ID: lead-1780599012278-t8oh) |
| listLeads | ✅ PASS | 📋 9 lead(s): - [novo] [TEST-1780599010124] Lead de Teste (test@luna.bot) - [nov |
| updateLead | ❌ FAIL | Dashboard API /leads/lead: 404 Not Found |
| convertLead | ❌ FAIL | Dashboard API /leads/lead/convert: 404 Not Found |
| deleteLead | ✅ PASS | 🗑️ Lead lead excluído. |

## Finance

| Tool | Status | Detalhe |
|------|--------|---------|
| getFinanceSummary | ✅ PASS | 💰 Finance Summary: - Expected: 5400 - Received: 0 - Pending: 5400 - Overdue: 0 |
| getCashBox | ✅ PASS | 💵 Caixa: €20.57 Última atualização: N/A |
| listPayments | ✅ PASS | 💰 6 pagamento(s): - ⏳ €undefined — Teste E2E - Site Institucional — Contrato &  |
| listExpenses | ✅ PASS | 📤 12 despesa(s): - ⏳ €[object Object] —  (others) - ⏳ €[object Object] —  (othe |
| listCashHistory | ❌ FAIL | items.map is not a function |
| createPayment | ✅ PASS | 💰 Pagamento registrado: €99.99 — Pagamento de teste |
| createExpense | ✅ PASS | 📤 Despesa registrada: €49.99 — Despesa de teste |

## Ideas

| Tool | Status | Detalhe |
|------|--------|---------|
| createIdea | ❌ FAIL | Dashboard API /ideas: 400 Bad Request |
| listIdeas | ✅ PASS | 💡 5 ideia(s): - [rascunho] Wallapop África — Marketplace C2C com Dramane (tipo: |

## Quotes

| Tool | Status | Detalhe |
|------|--------|---------|
| createQuote | ✅ PASS | 📄 Orçamento criado: "Projeto" — €0 |
| listQuotes | ✅ PASS | 📄 9 orçamento(s): - [draft] Projeto — €[object Object] - [draft] Test — €[objec |

## Projects

| Tool | Status | Detalhe |
|------|--------|---------|
| listProjects | ✅ PASS | 📁 2 projeto(s): - SantaFe Construcciones (em-progresso) - NEXO Dashboard Pro (e |

## Clients

| Tool | Status | Detalhe |
|------|--------|---------|
| listClients | ❌ FAIL | items.map is not a function |

## Links

| Tool | Status | Detalhe |
|------|--------|---------|
| addLink | ✅ PASS | 🔗 Link adicionado: https://example.com/luna-test |
| listLinks | ✅ PASS | 🔗 48 link(s): - https://vm.tiktok.com/znrpt9nsh/ (tiktok) - https://www.linkedi |
| getLinksStats | ✅ PASS | 🔗 Stats: 48 total, 9 quebrados. |

## Emails

| Tool | Status | Detalhe |
|------|--------|---------|
| listEmails | ✅ PASS | 📧 0 email(s): Nenhum email. |

## WhatsApp

| Tool | Status | Detalhe |
|------|--------|---------|
| getWhatsAppStatus | ❌ FAIL | Unexpected token '<', "<!doctype "... is not valid JSON |
| getWhatsAppHistory | ❌ FAIL | Unexpected token '<', "<!doctype "... is not valid JSON |
| getWhatsAppClassifications | ❌ FAIL | Unexpected token '<', "<!doctype "... is not valid JSON |

## Notifications

| Tool | Status | Detalhe |
|------|--------|---------|
| listNotifications | ✅ PASS | 🔔 17 notificação(ões): - ✓ 🚨 Login falho detectado - ✓ 🚨 Login falho detectad |
| markAllNotificationsRead | ✅ PASS | ✅ Todas lidas. |

## Users

| Tool | Status | Detalhe |
|------|--------|---------|
| listUsers | ❌ FAIL | items.map is not a function |

## Members

| Tool | Status | Detalhe |
|------|--------|---------|
| listMembers | ✅ PASS | 👥 0 membro(s): Nenhum. |

## BugReports

| Tool | Status | Detalhe |
|------|--------|---------|
| listBugReports | ✅ PASS | 🐛 22 relatório(s): - bug-report-test-123-2026-05-13T12-30-59-207Z.json: Relatór |

## GitHub

| Tool | Status | Detalhe |
|------|--------|---------|
| listGitHubRepos | ✅ PASS | 🐙 48 repo(s): - NexoDashboard (?) - luna-kernel (?) - nana-beauty-studio (?) -  |

## Vercel

| Tool | Status | Detalhe |
|------|--------|---------|
| listVercelProjects | ✅ PASS | ▲ 0 projeto(s): Nenhum. |

## OpsAlerts

| Tool | Status | Detalhe |
|------|--------|---------|
| listOpsAlerts | ✅ PASS | ⚠️ 0 alerta(s): Nenhum. |

## Transactions

| Tool | Status | Detalhe |
|------|--------|---------|
| listTransactions | ✅ PASS | 💳 0 transação(ões): Nenhuma. |

## State

| Tool | Status | Detalhe |
|------|--------|---------|
| getNexoState | ✅ PASS | 🌐 NEXO State: {   "success": true,   "timestamp": "2026-06-04T18:50:20.347Z",   |

## Config

| Tool | Status | Detalhe |
|------|--------|---------|
| getConfig | ✅ PASS | ⚙️ Config: {   "success": true,   "data": {     "_schema": {       "version": "1 |

## Voting

| Tool | Status | Detalhe |
|------|--------|---------|
| listVotingSessions | ✅ PASS | 🗳️ 11 sessão(ões) de votação: - [open] 🚀 Lançar Nova Feature AI — Luna v6.0 PR |

## Roadmaps

| Tool | Status | Detalhe |
|------|--------|---------|
| listRoadmaps | ✅ PASS | 🎯 2 projeto(s): - [active] Projeto Teste E2E (website, 0%) — €0 - [active] Test |

## ProjectTypes

| Tool | Status | Detalhe |
|------|--------|---------|
| listProjectTypes | ✅ PASS | 📋 4 tipo(s) de projeto: - app: App Mobile (8 fases padrão) - ecommerce: E-comme |

## Falhas Detalhadas

### Leads — updateLead
- **Erro:** Dashboard API /leads/lead: 404 Not Found
- **Horário:** 2026-06-04T18:50:12.552Z

### Leads — convertLead
- **Erro:** Dashboard API /leads/lead/convert: 404 Not Found
- **Horário:** 2026-06-04T18:50:12.599Z

### Finance — listCashHistory
- **Erro:** items.map is not a function
- **Horário:** 2026-06-04T18:50:13.026Z

### Ideas — createIdea
- **Erro:** Dashboard API /ideas: 400 Bad Request
- **Horário:** 2026-06-04T18:50:13.266Z

### Clients — listClients
- **Erro:** items.map is not a function
- **Horário:** 2026-06-04T18:50:13.490Z

### WhatsApp — getWhatsAppStatus
- **Erro:** Unexpected token '<', "<!doctype "... is not valid JSON
- **Horário:** 2026-06-04T18:50:14.146Z

### WhatsApp — getWhatsAppHistory
- **Erro:** Unexpected token '<', "<!doctype "... is not valid JSON
- **Horário:** 2026-06-04T18:50:14.152Z

### WhatsApp — getWhatsAppClassifications
- **Erro:** Unexpected token '<', "<!doctype "... is not valid JSON
- **Horário:** 2026-06-04T18:50:14.157Z

### Users — listUsers
- **Erro:** items.map is not a function
- **Horário:** 2026-06-04T18:50:14.326Z
