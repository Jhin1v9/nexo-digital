#!/usr/bin/env bash
# ═══════════════════════════════════════════════════════════════════════════
# NEXO DIGITAL — Stop All Services
# ═══════════════════════════════════════════════════════════════════════════

set -uo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

log()     { echo -e "${BLUE}[STOP]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$SCRIPT_DIR/.nexo-pids"

echo ""
echo -e "${BOLD}${BLUE}🛑 Parando serviços NEXO DIGITAL...${NC}"
echo ""

STOPPED=0

# ── Stop by PID file ──
if [ -f "$PID_FILE" ]; then
    while IFS=: read -r name pid; do
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            log "Parando $name (PID: $pid)..."
            kill "$pid" 2>/dev/null && success "$name parado" || warn "$name já havia parado"
            STOPPED=$((STOPPED + 1))
        fi
    done < "$PID_FILE"
    rm -f "$PID_FILE"
fi

# ── Fallback: kill by port ──
for port in 3456 3458 5173; do
    PIDS=$(lsof -ti :$port 2>/dev/null || ss -tlnp 2>/dev/null | grep ":$port" | grep -oP 'pid=\K[0-9]+' || true)
    if [ -n "$PIDS" ]; then
        for p in $PIDS; do
            log "Matando processo na porta $port (PID: $p)..."
            kill -9 "$p" 2>/dev/null || true
            STOPPED=$((STOPPED + 1))
        done
    fi
done

# ── PM2 fallback ──
if command -v pm2 &>/dev/null; then
    pm2 stop all 2>/dev/null || true
    pm2 delete all 2>/dev/null || true
fi

if [ "$STOPPED" -gt 0 ]; then
    echo ""
    success "$STOPPED serviço(s) parado(s)."
else
    warn "Nenhum serviço ativo encontrado."
fi

echo ""
