# 🌙 AGENTE GLOBAL — NEXO DIGITAL

> **Contexto unificado** para agentes IA trabalhando nos projetos NEXO Dashboard + Luna Kernel.
> **Leia este arquivo ANTES** de qualquer outro `.agents/`.

---

## 🏢 Identidade da Empresa

| Campo | Valor |
|-------|-------|
| **Empresa** | NEXO DIGITAL S.L. |
| **CEO** | Abner Gabriel |
| **Localização** | Barcelona, Espanha |
| **Time** | 3 fundadores (Abner + 2 sócios) |
| **Website** | nexodigital.com |

---

## 📁 Estrutura do Mono-Repo

Este repositório contém **2 projetos principais**:

```
nexo-digital-backup/
├── dashboard/     ← NEXO Dashboard Pro (React + Node.js)
├── luna-kernel/   ← Luna AI Kernel (Node.js + Svelte + Chrome Ext)
└── .agents/       ← Você está aqui
```

---

## 🔄 Regras de Interação entre Projetos

| Ação | Regra |
|------|-------|
| Modificar Dashboard | Leia `.agents/DASHBOARD.md` |
| Modificar Luna | Leia `.agents/LUNA.md` |
| Modificar ambos | Leia AMBOS + este GLOBAL |
| Criar integração | Sempre consulte ambos os contextos |

---

## ⚠️ Guardrails Globais

1. **NUNCA** suba `node_modules/`, `.env`, credenciais, cookies
2. **SEMPRE** verifique `.gitignore` antes de `git add`
3. **COMMITS** só com autorização do Abner (CEO)
4. **TYPECHECK** limpo antes de qualquer push
5. **SEM `any`** em TypeScript — tipagem estrita

---

## 🛠️ Stack Tecnológica Unificada

| Camada | Dashboard | Luna |
|--------|-----------|------|
| **Frontend** | React + Vite | Svelte + Vite |
| **Backend** | Node.js + Express | Node.js + Express |
| **DB** | PostgreSQL + Supabase | Local JSON + Supabase |
| **Auth** | Supabase Auth | Kimi Session + Local |
| **Deploy** | Vercel | Local PC + Chrome Ext |
| **Estado** | Zustand | Svelte Stores |

---

## 📞 Contato / Escalonamento

- **Dúvidas técnicas**: Consulte o `.agents/` específico do projeto
- **Decisões de arquitetura**: Abner (CEO) é a fonte primária de verdade
- **Bugs críticos**: Reporte imediatamente, não implemente sem aprovação

---

*Atualizado: 2026-06-05 | Autor: Luna 🌙*
