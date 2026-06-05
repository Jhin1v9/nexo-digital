# 🎯 AGENTE — NEXO Dashboard Pro

> **Contexto específico** para agentes IA trabalhando no NEXO Dashboard Pro.
> Leia `.agents/GLOBAL.md` primeiro para contexto da empresa.

---

## 📁 Estrutura do Dashboard

```
dashboard/
├── backend/
│   ├── server.js                    ← Entry point Express
│   ├── data/                        ← JSON databases (leads, tasks, etc)
│   ├── routes/                      ← API routes
│   ├── services/                    ← Business logic
│   │   ├── telegram-notification.service.js
│   │   ├── telegram-notifier.js
│   │   └── ...
│   ├── middleware/                  ← Auth, validation
│   ├── luna-chat-routes.js         ← Luna integration routes
│   └── luna-extension-handler.cjs  ← Extension event handler
│
├── frontend/
│   ├── src/
│   │   ├── pages/                   ← React pages (Metas, Settings, etc)
│   │   ├── components/              ← Reusable UI
│   │   ├── hooks/                   ← Custom hooks
│   │   ├── stores/                  ← Zustand stores
│   │   └── App.jsx                  ← Main router
│   └── index.html
│
└── agents/
    └── core/
        └── ActionExecutor.js        ← AI action execution
```

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia |
|--------|------------|
| **Frontend** | React 18 + Vite + Tailwind CSS |
| **Backend** | Node.js + Express |
| **Database** | PostgreSQL (Supabase) + Local JSON |
| **Auth** | Supabase Auth |
| **State** | Zustand |
| **API** | REST + WebSocket (real-time) |
| **Deploy** | Vercel |

---

## 🔧 Módulos Principais

### 💰 Financeiro
- Caixa (cash box)
- Despesas (expenses)
- Pagamentos (payments)
- Orçamentos (quotes)
- Relatórios financeiros

### 👥 CRM
- Leads (captação)
- Clientes
- Pipeline de vendas
- Follow-up automático

### 📋 Projetos
- Tarefas (tasks)
- Links úteis
- Colaboração em equipe

### 💬 Comunicação
- Email integrado
- WhatsApp (via Twilio/Supabase)
- Notificações push

### 🤖 Agentes IA
- ActionExecutor.js
- Integração com Luna Kernel
- Automação de tarefas

---

## ⚠️ Regras de Código

1. **TypeScript**: Sem `any` — tipagem estrita obrigatória
2. **Commits**: Só com autorização do Abner
3. **Build**: `npm run build` deve passar limpo
4. **Lint**: ESLint configurado, zero warnings
5. **Env**: Nunca commite `.env` — usar `.env.example`

---

## 🔗 Integração com Luna

O Dashboard se comunica com a Luna via:
- **Backend routes**: `backend/luna-chat-routes.js`
- **Extension handler**: `backend/luna-extension-handler.cjs`
- **Frontend**: Componentes `luna-web/` dentro do dashboard

---

## 📦 Scripts Úteis

```bash
cd dashboard
npm install
npm run dev      # Dev server
npm run build    # Production build
npm run lint     # ESLint check
```

---

*Atualizado: 2026-06-05 | Projeto: NEXO Dashboard Pro*
