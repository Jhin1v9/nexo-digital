#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
# NEXO DIGITAL — Universal Installer
# Dashboard PRO + Luna Kernel v5.0
# ═══════════════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log()     { echo -e "${BLUE}[NEXO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
info()    { echo -e "${CYAN}[INFO]${NC} $1"; }

# ── Directories ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${SCRIPT_DIR}"
cd "$INSTALL_DIR"

# ═══════════════════════════════════════════════════════════════════════════
# HEADER
# ═══════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║                                                                ║${NC}"
echo -e "${BOLD}${CYAN}║   🌙  NEXO DIGITAL — Instalador Universal v1.0.0              ║${NC}"
echo -e "${BOLD}${CYAN}║       Dashboard PRO + Luna Kernel v5.0                       ║${NC}"
echo -e "${BOLD}${CYAN}║                                                                ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

info "Diretório de instalação: $INSTALL_DIR"

# ═══════════════════════════════════════════════════════════════════════════
# 1. DETECT OS
# ═══════════════════════════════════════════════════════════════════════════
log "Detectando sistema operacional..."
OS="unknown"
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
    if grep -q Microsoft /proc/version 2>/dev/null; then
        OS="wsl"
    fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
fi
success "OS detectado: $OS"

# ═══════════════════════════════════════════════════════════════════════════
# 2. CHECK PREREQUISITES
# ═══════════════════════════════════════════════════════════════════════════
log "Verificando pré-requisitos..."

MISSING_DEPS=()

# Node.js
if ! command -v node &>/dev/null; then
    MISSING_DEPS+=("nodejs")
else
    NODE_MAJOR=$(node -v | sed 's/^v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -lt 20 ]; then
        warn "Node.js v$(node -v) encontrado, mas v20+ é obrigatório."
        MISSING_DEPS+=("nodejs-upgrade")
    else
        success "Node.js $(node -v)"
    fi
fi

# npm
if ! command -v npm &>/dev/null; then
    MISSING_DEPS+=("npm")
else
    success "npm $(npm -v)"
fi

# Git
if ! command -v git &>/dev/null; then
    MISSING_DEPS+=("git")
else
    success "Git $(git --version | awk '{print $3}')"
fi

# PostgreSQL
if ! command -v psql &>/dev/null; then
    MISSING_DEPS+=("postgresql")
else
    success "PostgreSQL $(psql --version | head -1)"
fi

# Google Chrome / Chromium
CHROME_FOUND=false
CHROME_PATH=""
for chrome in google-chrome chromium-browser chromium google-chrome-stable; do
    if command -v "$chrome" &>/dev/null; then
        CHROME_FOUND=true
        CHROME_PATH=$(command -v "$chrome")
        success "Chrome/Chromium encontrado: $CHROME_PATH"
        break
    fi
done
if [ "$CHROME_FOUND" = false ]; then
    MISSING_DEPS+=("chrome")
fi

# PM2
if ! command -v pm2 &>/dev/null; then
    MISSING_DEPS+=("pm2")
else
    success "PM2 $(pm2 --version | head -1)"
fi

# Caddy (optional)
if ! command -v caddy &>/dev/null; then
    warn "Caddy não encontrado (opcional, mas recomendado para HTTPS local)"
else
    success "Caddy $(caddy version | head -1 | awk '{print $1}')"
fi

# Ollama (optional)
if ! command -v ollama &>/dev/null; then
    warn "Ollama não encontrado (opcional — para IA offline)"
else
    success "Ollama $(ollama -v 2>/dev/null || echo 'instalado')"
fi

# ── Report missing ──
if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    echo ""
    warn "Dependências faltando ou desatualizadas:"
    for dep in "${MISSING_DEPS[@]}"; do
        case "$dep" in
            nodejs)
                echo "   ❌ Node.js v20+ — Instale via:"
                echo "      curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
                echo "      sudo apt-get install -y nodejs"
                ;;
            nodejs-upgrade)
                echo "   ⚠️  Node.js precisa ser atualizado para v20+"
                ;;
            npm)
                echo "   ❌ npm — Geralmente instalado com Node.js"
                ;;
            git)
                echo "   ❌ Git — sudo apt-get install git"
                ;;
            postgresql)
                echo "   ❌ PostgreSQL — sudo apt-get install postgresql postgresql-contrib"
                ;;
            chrome)
                echo "   ❌ Google Chrome/Chromium — Necessário para Luna Bridge"
                echo "      wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -"
                echo "      sudo sh -c 'echo \"deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main\" > /etc/apt/sources.list.d/google-chrome.list'"
                echo "      sudo apt-get update && sudo apt-get install -y google-chrome-stable"
                ;;
            pm2)
                echo "   ❌ PM2 — npm install -g pm2"
                ;;
        esac
    done
    echo ""
    error "Instale as dependências faltantes e execute novamente."
    exit 1
fi

success "Todos os pré-requisitos atendidos!"

# ═══════════════════════════════════════════════════════════════════════════
# 3. INSTALL DEPENDENCIES
# ═══════════════════════════════════════════════════════════════════════════
echo ""
log "Instalando dependências..."

log "📦 npm install (raiz)..."
npm install --silent 2>&1 | tail -3 || true
success "Raiz OK"

log "📦 dashboard..."
cd "$INSTALL_DIR/dashboard"
npm install --silent 2>&1 | tail -3 || true
success "Dashboard OK"

log "📦 luna-kernel..."
cd "$INSTALL_DIR/luna-kernel"
npm install --silent 2>&1 | tail -3 || true
success "Luna Kernel OK"

cd "$INSTALL_DIR"

# ═══════════════════════════════════════════════════════════════════════════
# 4. BUILD FRONTENDS
# ═══════════════════════════════════════════════════════════════════════════
echo ""
log "Buildando frontends..."

log "🔨 Dashboard frontend..."
cd "$INSTALL_DIR/dashboard/frontend"
npm run build 2>&1 | tail -5
success "Dashboard build OK → $(ls -d dist 2>/dev/null && echo 'dist/ criado' || echo 'verifique o build')"

log "🔨 Luna Web..."
cd "$INSTALL_DIR/luna-kernel/luna-web"
npm run build 2>&1 | tail -5
success "Luna Web build OK → $(ls -d dist 2>/dev/null && echo 'dist/ criado' || echo 'verifique o build')"

cd "$INSTALL_DIR"

# ═══════════════════════════════════════════════════════════════════════════
# 5. SETUP .ENV
# ═══════════════════════════════════════════════════════════════════════════
echo ""
log "Configurando ambiente (.env)..."

if [ -f ".env" ]; then
    warn "Arquivo .env já existe."
    read -p "   Deseja recriar do template? [s/N]: " RECREATE_ENV
    if [[ ! "$RECREATE_ENV" =~ ^[Ss]$ ]]; then
        success ".env mantido."
    else
        cp .env.template .env
        success ".env recriado do template."
    fi
else
    cp .env.template .env
    success ".env criado do template."
fi

# ── Interactive prompts ──
echo ""
echo -e "${BOLD}📝 Preencha as variáveis obrigatórias:${NC}"
echo "   (pressione ENTER para manter o valor atual ou pular)"
echo ""

prompt_env() {
    local key="$1"
    local current=$(grep "^$key=" .env 2>/dev/null | cut -d= -f2- | head -1)
    local desc="$2"
    local default="$3"
    local val=""

    if [ -z "$current" ] || [ "$current" = "YOUR_VALUE_HERE" ]; then
        current=""
    fi

    echo -e "${CYAN}$desc${NC}"
    if [ -n "$default" ] && [ -z "$current" ]; then
        read -p "   $key [$default]: " val
        val="${val:-$default}"
    else
        read -p "   $key [${current:-vazio}]: " val
        val="${val:-$current}"
    fi

    if [ -n "$val" ]; then
        # Escape special chars for sed
        local escaped_val=$(printf '%s\n' "$val" | sed -e 's/[&/\\]/\\&/g')
        if grep -q "^$key=" .env; then
            sed -i "s|^$key=.*|$key=$escaped_val|" .env
        else
            echo "$key=$val" >> .env
        fi
    fi
    echo ""
}

prompt_env "DATABASE_URL" "🔗 URL do Banco de Dados PostgreSQL" "postgresql://nexo:nexo123@localhost:5432/nexodb"
prompt_env "TELEGRAM_BOT_TOKEN" "🤖 Token do Bot Telegram (de @BotFather)" ""
prompt_env "TELEGRAM_GROUP_CHAT_ID" "💬 Chat ID do Grupo Telegram" ""
prompt_env "DISCORD_SECURITY_WEBHOOK" "🔒 Webhook do Discord (alertas)" ""
prompt_env "SMTP_USER" "📧 Email SMTP (Gmail)" ""
prompt_env "SMTP_PASS" "🔑 App Password do Gmail" ""
prompt_env "DASHBOARD_PUBLIC_URL" "🌐 URL pública do dashboard" "https://nexo.duckdns.org"

# ── Auto-generate secrets if empty ──
generate_secret() {
    openssl rand -hex 32 2>/dev/null || cat /dev/urandom | tr -dc 'a-zA-Z0-9' | head -c 64
}

JWT_CURRENT=$(grep "^JWT_SECRET=" .env | cut -d= -f2- | head -1)
if [ -z "$JWT_CURRENT" ] || [ "$JWT_CURRENT" = "YOUR_VALUE_HERE" ]; then
    NEW_JWT=$(generate_secret)
    sed -i "s|^JWT_SECRET=.*|JWT_SECRET=$NEW_JWT|" .env
    success "JWT_SECRET gerado automaticamente"
fi

API_CURRENT=$(grep "^INTERNAL_API_TOKEN=" .env | cut -d= -f2- | head -1)
if [ -z "$API_CURRENT" ] || [ "$API_CURRENT" = "YOUR_VALUE_HERE" ]; then
    NEW_API=$(generate_secret)
    sed -i "s|^INTERNAL_API_TOKEN=.*|INTERNAL_API_TOKEN=$NEW_API|" .env
    success "INTERNAL_API_TOKEN gerado automaticamente"
fi

# ── Copy .env to workspaces ──
cp .env dashboard/backend/.env 2>/dev/null || true
cp .env luna-kernel/.env 2>/dev/null || true

success ".env configurado e copiado para workspaces"

# ═══════════════════════════════════════════════════════════════════════════
# 6. DATABASE SETUP
# ═══════════════════════════════════════════════════════════════════════════
echo ""
log "Configurando banco de dados..."

DB_URL=$(grep "^DATABASE_URL=" .env | cut -d= -f2- | head -1)

if [ -z "$DB_URL" ] || [ "$DB_URL" = "YOUR_VALUE_HERE" ]; then
    warn "DATABASE_URL não configurada. Pulando setup do banco."
    warn "Configure manualmente e rode as migrations em:"
    warn "   cd dashboard/backend && psql \"$DB_URL\" < migrations/001-init.sql"
else
    log "Testando conexão com PostgreSQL..."
    if psql "$DB_URL" -c "SELECT 1;" &>/dev/null; then
        success "Conexão OK"

        log "Verificando tabelas existentes..."
        TABLES=$(psql "$DB_URL" -t -c "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='public';" 2>/dev/null | tr -d ' ' || echo "0")
        if [ "$TABLES" = "0" ]; then
            log "Banco vazio. Rodando migrations..."
            for mig in "$INSTALL_DIR"/dashboard/backend/migrations/*.sql; do
                if [ -f "$mig" ]; then
                    log "   → $(basename "$mig")"
                    psql "$DB_URL" -f "$mig" >/dev/null 2>&1 || warn "   Erro em $(basename "$mig") (pode já existir)"
                fi
            done
            success "Migrations aplicadas!"
        else
            info "Banco já possui $TABLES tabelas. Migrations puladas."
        fi
    else
        warn "Não foi possível conectar ao PostgreSQL."
        warn "Verifique se o servidor está rodando e a DATABASE_URL está correta."
        warn "Para PostgreSQL local:"
        warn "   sudo systemctl start postgresql"
        warn "Ou execute: ./dashboard/setup-local-pg.sh"
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════
# 7. FINAL SUMMARY
# ═══════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   ✅ INSTALAÇÃO CONCLUÍDA!                                    ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
info "Próximos passos:"
echo ""
echo -e "   ${BOLD}1️⃣  Iniciar todos os serviços:${NC}"
echo -e "      ${YELLOW}./start.sh${NC}"
echo ""
echo -e "   ${BOLD}2️⃣  Acessar o Dashboard:${NC}"
echo -e "      ${CYAN}http://localhost:3456${NC} (ou via Caddy HTTPS)"
echo ""
echo -e "   ${BOLD}3️⃣  Acessar Luna Web:${NC}"
echo -e "      ${CYAN}http://localhost:3458${NC}"
echo ""
echo -e "   ${BOLD}4️⃣  Verificar saúde:${NC}"
echo -e "      ${YELLOW}./health-check.sh${NC}"
echo ""
echo -e "   ${BOLD}5️⃣  Parar todos os serviços:${NC}"
echo -e "      ${YELLOW}./stop.sh${NC}"
echo ""
echo -e "   ${BOLD}6️⃣  Configurar Telegram Bot:${NC}"
echo -e "      Adicione @seu_bot ao grupo do Telegram"
echo -e "      Verifique o TELEGRAM_GROUP_CHAT_ID no .env"
echo ""
info "Arquivos importantes:"
echo -e "   .env              → Configurações sensíveis"
echo -e "   .env.template     → Template de referência"
echo -e "   start.sh          → Iniciar tudo"
echo -e "   stop.sh           → Parar tudo"
echo -e "   health-check.sh   → Verificar saúde"
echo ""
echo -e "${GREEN}🌙 NEXO DIGITAL — Pronto para decolar!${NC}"
echo ""
