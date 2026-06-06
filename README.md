# 🌙 NEXO DIGITAL — Dashboard PRO + Luna Kernel v5.0

> **Sistema empresarial completo** com gestão financeira, CRM, projetos, votações e agente de IA autônomo.

---

## 📋 O que está incluído

| Módulo | Descrição | Tecnologia |
|--------|-----------|------------|
| **Dashboard PRO** | Gestão empresarial completa | React 18 + Vite + Express |
| **Luna Kernel v5.0** | Agente de IA autônomo | Node.js + Svelte + Playwright |
| **Luna Web** | Interface chat web | Svelte 4 + Tailwind |
| **Luna Extension** | Extensão Chrome para interceptação | Manifest V3 |
| **Telegram Bot** | Notificações e interação via chat | node-telegram-bot-api |

---

## 🚀 Instalação Rápida (3 comandos)

```bash
git clone https://github.com/Jhin1v9/nexo-digital.git
cd nexo-digital
./install.sh
```

O instalador irá:
1. Verificar pré-requisitos (Node 20+, PostgreSQL, Chrome)
2. Instalar dependências de todos os módulos
3. Buildar frontends
4. Guiar na configuração do `.env`
5. Aplicar migrations do banco de dados

---

## 📦 Pré-requisitos

- **Node.js** v20+ (com npm v10+)
- **Git**
- **PostgreSQL** 15+ (local ou Neon/Supabase)
- **Google Chrome** / Chromium (para Luna Bridge)
- **PM2** (opcional, recomendado para produção)
- **Caddy** (opcional, para HTTPS local)

### Instalação automática de dependências

O `./install.sh` detecta o que falta e mostra os comandos exatos para instalar.

---

## 🎮 Comandos

| Comando | Descrição |
|---------|-----------|
| `./install.sh` | Instalação completa interativa |
| `./start.sh` | Inicia todos os serviços |
| `./stop.sh` | Para todos os serviços |
| `./health-check.sh` | Verifica saúde do sistema |
| `npm run build:all` | Builda todos os frontends |
| `./dashboard/luna-nexo.sh start` | Inicia via PM2 (recomendado) |
| `./dashboard/luna-nexo.sh stop` | Para via PM2 |
| `./dashboard/luna-nexo.sh status` | Status dos serviços PM2 |

---

## 🌐 URLs de Acesso

Após iniciar:

| Serviço | URL Padrão |
|---------|------------|
| Dashboard | http://localhost:3456 |
| Luna Web | http://localhost:3458 |
| Luna Vite Dev | http://localhost:5173 (modo dev) |

Com Caddy configurado:
- https://localhost (Dashboard)
- https://localhost/luna-web/ (Luna Web)

---

## ⚙️ Configuração

O arquivo `.env` é criado automaticamente pelo `install.sh` a partir do `.env.template`.

### Variáveis obrigatórias

- `DATABASE_URL` — PostgreSQL
- `JWT_SECRET` — Mínimo 64 caracteres
- `TELEGRAM_BOT_TOKEN` — De @BotFather
- `TELEGRAM_GROUP_CHAT_ID` — ID do grupo de notificações
- `INTERNAL_API_TOKEN` — Token de comunicação interna
- `SMTP_USER` / `SMTP_PASS` — Email para notificações

Veja o guia completo em [`docs/ENV-GUIDE.md`](docs/ENV-GUIDE.md).

---

## 🏗️ Estrutura do Monorepo

```
nexo-digital/
├── install.sh              ← Instalador universal
├── start.sh / stop.sh      ← Controle de serviços
├── health-check.sh         ← Verificação de saúde
├── .env.template           ← Template de configuração
│
├── dashboard/              ← NEXO Dashboard PRO
│   ├── frontend/           ← React + Vite
│   ├── backend/            ← Express + PostgreSQL
│   ├── backend/migrations/ ← SQL migrations
│   └── agents/             ← Agentes e bots
│
├── luna-kernel/            ← Luna Kernel v5.0
│   ├── luna-web/           ← Svelte frontend
│   ├── luna-extension/     ← Extensão Chrome
│   ├── luna-soul.cjs       ← Orquestrador principal
│   ├── kimi-bridge.cjs     ← Bridge Playwright CDP
│   └── config/             ← Configurações centralizadas
│
├── shared/                 ← Configs compartilhadas
│   └── caddy/              ← Caddyfile
│
└── docs/                   ← Documentação
    ├── ENV-GUIDE.md
    └── TROUBLESHOOTING.md
```

---

## 🔒 Segurança

- **NUNCA** commite o arquivo `.env`
- O `.gitignore` já bloqueia secrets, cookies, logs e builds
- Tokens e credenciais são configurados localmente após clone
- O `JWT_SECRET` é gerado automaticamente se vazio

---

## 🐛 Resolução de Problemas

Veja [`docs/TROUBLESHOOTING.md`](docs/TROUBLESHOOTING.md) para:
- Portas em uso
- PostgreSQL não conecta
- Build falhando
- PM2 processos travados
- Extensão Chrome não carrega

---

## 📞 Suporte

- **Telegram**: @lunanexobot
- **Empresa**: NEXO DIGITAL S.L.
- **Localização**: Barcelona, Espanha

---

*Criado por NEXO DIGITAL S.L. 🌙*
