#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
# NEXO DIGITAL — Start All Services
# Dashboard PRO + Luna Kernel v5.0
# ═══════════════════════════════════════════════════════════════════════════

set -uo pipefail

# ── Colors ──
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

log()     { echo -e "${BLUE}[START]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }
info()    { echo -e "${CYAN}[INFO]${NC} $1"; }

# ── Directories ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# ── Load .env ──
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs) 2>/dev/null || true
fi

DASHBOARD_PORT="${DASHBOARD_PORT:-3456}"
LUNA_PORT="${LUNA_PORT:-3458}"
VITE_PORT="${VITE_PORT:-5173}"
NODE_ENV="${NODE_ENV:-production}"

PID_FILE="$SCRIPT_DIR/.nexo-pids"

# ═══════════════════════════════════════════════════════════════════════════
# HEADER
# ═══════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${CYAN}║   🚀  Iniciando NEXO DIGITAL                                  ║${NC}"
echo -e "${BOLD}${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# ── Clear old PIDs ──
> "$PID_FILE" 2>/dev/null || true

# ═══════════════════════════════════════════════════════════════════════════
# 1. POSTGRESQL (local only)
# ═══════════════════════════════════════════════════════════════════════════
if command -v systemctl &>/dev/null && systemctl is-active --quiet postgresql 2>/dev/null; then
    success "PostgreSQL já está rodando"
elif command -v pg_isready &>/dev/null && pg_isready -q 2>/dev/null; then
    success "PostgreSQL já está rodando"
else
    if command -v systemctl &>/dev/null; then
        log "Iniciando PostgreSQL..."
        sudo systemctl start postgresql 2>/dev/null || warn "Não foi possível iniciar PostgreSQL via systemctl"
    fi
fi

# ═══════════════════════════════════════════════════════════════════════════
# 2. NEXO DASHBOARD BACKEND
# ═══════════════════════════════════════════════════════════════════════════
log "Iniciando Dashboard Backend (porta $DASHBOARD_PORT)..."
cd "$SCRIPT_DIR/dashboard/backend"
if [ -f "server.js" ]; then
    nohup node server.js > "$SCRIPT_DIR/logs/dashboard-backend.log" 2>&1 &
    DASHBOARD_PID=$!
    echo "dashboard:$DASHBOARD_PID" >> "$PID_FILE"
    success "Dashboard Backend PID: $DASHBOARD_PID"
else
    error "server.js não encontrado em dashboard/backend/"
fi

# ── Wait for backend ──
sleep 2
if curl -s "http://localhost:$DASHBOARD_PORT/api/health" >/dev/null 2>&1 || curl -s "http://localhost:$DASHBOARD_PORT/" >/dev/null 2>&1; then
    success "Dashboard Backend respondendo na porta $DASHBOARD_PORT"
else
    warn "Dashboard Backend ainda não respondeu (aguarde alguns segundos)"
fi

# ═══════════════════════════════════════════════════════════════════════════
# 3. LUNA WEB SERVER
# ═══════════════════════════════════════════════════════════════════════════
log "Iniciando Luna Web Server (porta $LUNA_PORT)..."
cd "$SCRIPT_DIR/dashboard/backend"
if [ -f "luna-server.js" ]; then
    nohup node luna-server.js > "$SCRIPT_DIR/logs/luna-server.log" 2>&1 &
    LUNA_PID=$!
    echo "luna:$LUNA_PID" >> "$PID_FILE"
    success "Luna Server PID: $LUNA_PID"
else
    error "luna-server.js não encontrado em dashboard/backend/"
fi

sleep 1

# ═══════════════════════════════════════════════════════════════════════════
# 4. LUNA WEB VITE DEV (optional)
# ═══════════════════════════════════════════════════════════════════════════
if [ "$NODE_ENV" = "development" ]; then
    log "Iniciando Luna Web Vite Dev (porta $VITE_PORT)..."
    cd "$SCRIPT_DIR/luna-kernel/luna-web"
    if [ -f "package.json" ]; then
        nohup npm run dev > "$SCRIPT_DIR/logs/luna-vite.log" 2>&1 &
        VITE_PID=$!
        echo "vite:$VITE_PID" >> "$PID_FILE"
        success "Luna Vite Dev PID: $VITE_PID"
    fi
else
    info "Modo production — Vite dev não iniciado (use NODE_ENV=development para ativar)"
fi

# ═══════════════════════════════════════════════════════════════════════════
# 5. CADDY (if available)
# ═══════════════════════════════════════════════════════════════════════════
if command -v caddy &>/dev/null && [ -f "$SCRIPT_DIR/shared/caddy/Caddyfile" ]; then
    log "Iniciando Caddy..."
    cd "$SCRIPT_DIR/shared/caddy"
    nohup caddy run --config Caddyfile > "$SCRIPT_DIR/logs/caddy.log" 2>&1 &
    CADDY_PID=$!
    echo "caddy:$CADDY_PID" >> "$PID_FILE"
    success "Caddy PID: $CADDY_PID"
else
    info "Caddy não configurado ou não encontrado"
fi

# ═══════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════
echo ""
echo -e "${BOLD}${GREEN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║   ✅ SERVIÇOS INICIADOS                                       ║${NC}"
echo -e "${BOLD}${GREEN}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
info "URLs de acesso:"
echo -e "   🖥️  Dashboard:     ${CYAN}http://localhost:$DASHBOARD_PORT${NC}"
echo -e "   🌙 Luna Web:      ${CYAN}http://localhost:$LUNA_PORT${NC}"
if [ "$NODE_ENV" = "development" ]; then
    echo -e "   ⚡ Vite Dev:      ${CYAN}http://localhost:$VITE_PORT${NC}"
fi
echo ""
info "Logs:"
echo -e "   ${YELLOW}$SCRIPT_DIR/logs/${NC}"
echo ""
info "Comandos úteis:"
echo -e "   ${YELLOW}./stop.sh${NC}         → Parar todos"
echo -e "   ${YELLOW}./health-check.sh${NC} → Verificar saúde"
echo -e "   ${YELLOW}cat .nexo-pids${NC}    → Ver PIDs"
echo ""
