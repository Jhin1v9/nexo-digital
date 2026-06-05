# 🌙 NEXO DIGITAL — Backup Completo

> **Repositório de backup unificado** da NEXO DIGITAL S.L.
> Contém: **NEXO Dashboard Pro** + **Luna Kernel** (incluindo Luna Web + Telegram)

---

## 📁 Estrutura do Repositório

```
nexo-digital-backup/
├── README.md                 ← Você está aqui
├── .gitignore               ← Regras globais de ignore
├── .agents/                 ← Configurações de agentes IA
│   ├── GLOBAL.md            ← Contexto geral dos 2 projetos
│   ├── DASHBOARD.md         ← Contexto do Dashboard
│   └── LUNA.md              ← Contexto da Luna (tools, arquitetura)
│
├── dashboard/               ← NEXO Dashboard Pro (cópia funcional)
│   ├── backend/             ← Node.js API + serviços
│   ├── frontend/            ← React SPA
│   ├── agents/              ← Agentes IA do dashboard
│   └── ...
│
└── luna-kernel/             ← Luna AI Kernel (cópia funcional)
    ├── luna-web/            ← Interface web Svelte
    ├── luna-extension/      ← Extensão Chrome
    ├── config/              ← Configurações
    ├── cookies/             ← Cookies Kimi (não versionados)
    ├── plans/               ← Planos de projeto
    └── *.cjs / *.js         ← Core engine, bridge, tools, soul
```

---

## 🏢 Sobre a NEXO DIGITAL

| Campo | Valor |
|-------|-------|
| **Empresa** | NEXO DIGITAL S.L. |
| **CEO** | Abner Gabriel |
| **Localização** | Barcelona, Espanha |
| **Time** | 3 fundadores |
| **Projetos** | Dashboard Pro + Luna AI |

---

## 🚀 Projetos

### 1. NEXO Dashboard Pro
Sistema de gestão empresarial completo:
- **Financeiro**: Caixa, despesas, pagamentos, orçamentos
- **CRM**: Leads, clientes, pipeline de vendas
- **Projetos**: Tarefas, links, colaboração
- **Comunicação**: Email, WhatsApp integrado
- **Agentes IA**: Automação inteligente

**Stack**: React + Node.js + PostgreSQL + Supabase

### 2. Luna AI Kernel
Agente de IA autônomo executando no PC local:
- **Luna Web**: Interface chat Svelte com dashboard integrado
- **Luna Extension**: Extensão Chrome para interceptação Kimi
- **Core Engine**: Bridge Kimi, tools, executor, soul
- **Telegram**: Bot adapter para notificações

**Stack**: Node.js + Svelte + Chrome Extension APIs

---

## ⚡ Como Restaurar

```bash
# 1. Clone o repo
git clone https://github.com/Jhin1v9/nexo-digital.git

# 2. Dashboard
cd nexo-digital/dashboard
npm install
npm run dev

# 3. Luna Kernel
cd ../luna-kernel
npm install
npm start
```

---

## 🔒 Segurança

- **NUNCA** commite arquivos `.env`, credenciais ou cookies
- O `.gitignore` já bloqueia: `node_modules/`, `dist/`, `cookies/`, `*.env`
- Tokens e secrets devem ser reconfigurados manualmente após clone

---

## 📅 Último Backup

**Data**: 2026-06-05
**Versão**: Beta funcional
**Status**: ✅ Completo

---

*Criado por Luna 🌙 — Agente de IA da NEXO DIGITAL*
