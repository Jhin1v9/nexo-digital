# 📘 Guia de Variáveis de Ambiente (.env)

Este documento descreve todas as variáveis de ambiente utilizadas pelo NEXO Dashboard PRO + Luna Kernel v5.0.

---

## 🔴 Obrigatórias

### `DATABASE_URL`
URL de conexão com PostgreSQL.

**Formato:** `postgresql://user:password@host:port/database`

**Exemplos:**
```
# Local
DATABASE_URL=postgresql://nexo:nexo123@localhost:5432/nexodb

# Neon
DATABASE_URL=postgresql://user:pass@neon-host.neon.tech/db?sslmode=require

# Supabase
DATABASE_URL=postgresql://postgres:pass@db.supabase.co:5432/postgres
```

---

### `JWT_SECRET`
Chave secreta para assinatura de tokens JWT.

**Requisitos:** Mínimo 64 caracteres

**Como gerar:**
```bash
openssl rand -hex 32
```

---

### `TELEGRAM_BOT_TOKEN`
Token do bot Telegram criado via @BotFather.

**Como obter:**
1. Abra https://t.me/BotFather
2. Envie `/newbot`
3. Siga as instruções e copie o token

**Exemplo:**
```
TELEGRAM_BOT_TOKEN=123456789:ABCdefGHIjklMNOpqrSTUvwxyz
```

---

### `TELEGRAM_GROUP_CHAT_ID`
ID do grupo/canal onde o bot envia notificações.

**Como descobrir:**
```bash
curl -s "https://api.telegram.org/bot<TELEGRAM_BOT_TOKEN>/getUpdates" | jq ".result[-1].message.chat.id"
```

Ou use o script helper incluso:
```bash
node shared/scripts/discover-telegram-chat-id.js
```

---

### `INTERNAL_API_TOKEN`
Token de comunicação segura entre os serviços internos (Dashboard ↔ Luna Kernel).

**Como gerar:**
```bash
openssl rand -hex 32
```

---

### `DISCORD_SECURITY_WEBHOOK`
URL do webhook do Discord para alertas críticos de segurança.

**Como criar:**
1. No Discord, vá em Configurações do Servidor → Integrações → Webhooks
2. Crie um webhook e copie a URL

---

### `SMTP_USER` / `SMTP_PASS`
Credenciais para envio de email via SMTP (Gmail recomendado).

**Para Gmail:**
1. Ative 2FA na conta Google
2. Gere uma App Password em https://myaccount.google.com/apppasswords
3. Use seu email e a App Password gerada

```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=seu-email@gmail.com
SMTP_PASS=sua-app-password-16-chars
NEXO_NOTIFICATION_EMAIL=seu-email@gmail.com
```

---

### `DASHBOARD_PUBLIC_URL`
URL pública do dashboard (usada em webhooks e notificações).

**Exemplos:**
```
DASHBOARD_PUBLIC_URL=https://nexo.duckdns.org
DASHBOARD_PUBLIC_URL=https://seu-dominio.com
```

---

## 🟡 Opcionais (com defaults)

### `GEMINI_API_KEY`
Chave da API Google Gemini para recursos avançados de IA.

**Como obter:** https://aistudio.google.com/app/apikey

---

### Portas

```
DASHBOARD_PORT=3456    # Backend do dashboard
LUNA_PORT=3458         # Luna Web Server
VITE_PORT=5173         # Vite dev server (modo desenvolvimento)
DB_PORT=5432           # PostgreSQL
```

### `CEO_USERNAMES`
Usernames dos administradores com acesso total, separados por vírgula.

```
CEO_USERNAMES=abner,nonoke,elias
```

### Kimi Bridge Settings

```
KIMI_TIMEOUT=120000
KIMI_MAX_PAGES=5
KIMI_IDLE_TIMEOUT=600000
KIMI_COOLDOWN_MS=5000
KIMI_MAX_TYPE_LENGTH=500
KIMI_LOG_MAX_MB=10
```

### Context Auto-Compaction

```
LUNA_COMPACT_THRESHOLD=24
LUNA_COMPACT_TOKEN_THRESHOLD=120000
```

### Debug

```
LUNA_DEBUG=true        # Ativa logs detalhados
```

---

## 📋 Template Completo

Copie de `.env.template` e preencha os valores:

```bash
cp .env.template .env
nano .env
```

---

## 🔒 Segurança

- Nunca compartilhe seu `.env`
- Nunca commite o `.env` no Git
- Regenere `JWT_SECRET` e `INTERNAL_API_TOKEN` em caso de vazamento
- Use senhas fortes para PostgreSQL
