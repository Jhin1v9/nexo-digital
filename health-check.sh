#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
# NEXO DIGITAL — Health Check
# ═══════════════════════════════════════════════════════════════════════════

set -uo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

ok()   { echo -e "${GREEN}✅${NC} $1"; }
fail() { echo -e "${RED}❌${NC} $1"; }
warn() { echo -e "${YELLOW}⚠️${NC} $1"; }
info() { echo -e "${BLUE}ℹ️${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Load .env ──
if [ -f "$SCRIPT_DIR/.env" ]; then
    export $(grep -v '^#' "$SCRIPT_DIR/.env" | xargs) 2>/dev/null || true
fi

DASHBOARD_PORT="${DASHBOARD_PORT:-3456}"
LUNA_PORT="${LUNA_PORT:-3458}"
VITE_PORT="${VITE_PORT:-5173}"

EXIT_CODE=0

echo ""
echo -e "${BOLD}${BLUE}🏥 Health Check — NEXO DIGITAL${NC}"
echo ""

# ── Port checks ──
info "Verificando portas..."

if curl -s "http://localhost:$DASHBOARD_PORT/" >/dev/null 2>&1; then
    ok "Dashboard Backend (porta $DASHBOARD_PORT)"
else
    fail "Dashboard Backend (porta $DASHBOARD_PORT)"
    EXIT_CODE=1
fi

if curl -s "http://localhost:$LUNA_PORT/" >/dev/null 2>&1; then
    ok "Luna Server (porta $LUNA_PORT)"
else
    fail "Luna Server (porta $LUNA_PORT)"
    EXIT_CODE=1
fi

# ── API checks ──
info "Verificando APIs..."

if curl -s "http://localhost:$DASHBOARD_PORT/api/health" >/dev/null 2>&1; then
    ok "Dashboard API /health"
else
    warn "Dashboard API /health (endpoint pode não existir)"
fi

# ── Database check ──
info "Verificando banco de dados..."
DB_URL="${DATABASE_URL:-}"
if [ -n "$DB_URL" ] && command -v psql &>/dev/null; then
    if psql "$DB_URL" -c "SELECT 1;" >/dev/null 2>&1; then
        ok "PostgreSQL"
    else
        fail "PostgreSQL"
        EXIT_CODE=1
    fi
else
    warn "PostgreSQL (DATABASE_URL não configurada ou psql não encontrado)"
fi

# ── File checks ──
info "Verificando arquivos essenciais..."

[ -f "$SCRIPT_DIR/dashboard/backend/server.js" ] && ok "server.js" || { fail "server.js"; EXIT_CODE=1; }
[ -f "$SCRIPT_DIR/dashboard/backend/luna-server.js" ] && ok "luna-server.js" || { fail "luna-server.js"; EXIT_CODE=1; }
[ -f "$SCRIPT_DIR/dashboard/frontend/dist/index.html" ] && ok "Dashboard build" || warn "Dashboard build não encontrado (rode npm run build:all)"
[ -f "$SCRIPT_DIR/luna-kernel/luna-web/dist/index.html" ] && ok "Luna Web build" || warn "Luna Web build não encontrado (rode npm run build:all)"
[ -f "$SCRIPT_DIR/.env" ] && ok ".env configurado" || { fail ".env não encontrado"; EXIT_CODE=1; }

# ── Summary ──
echo ""
if [ "$EXIT_CODE" -eq 0 ]; then
    echo -e "${BOLD}${GREEN}✅ Todos os serviços estão saudáveis!${NC}"
else
    echo -e "${BOLD}${RED}❌ Alguns serviços precisam de atenção.${NC}"
    echo -e "   Execute ${YELLOW}./start.sh${NC} para iniciar os serviços."
fi
echo ""

exit $EXIT_CODE
