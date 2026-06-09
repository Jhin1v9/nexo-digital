#!/bin/bash
# NEXO + LUNA — Unified Control Script (Universal)
# Uso: ./dashboard/luna-nexo.sh [start|stop|status|logs|restart]
#
# Este script detecta automaticamente o diretório de instalação
# e usa PM2 para gerenciar todos os serviços.

set -e

# ── Auto-detect directories ──
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEXO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DASHBOARD_DIR="$NEXO_DIR/dashboard"
LUNA_KERNEL_DIR="$NEXO_DIR/luna-kernel"
LUNA_WEB="$LUNA_KERNEL_DIR/luna-web"

PID_DIR="/tmp/luna-nexo-pids"
mkdir -p "$PID_DIR"

# ── Load .env ──
if [ -f "$NEXO_DIR/.env" ]; then
    export $(grep -v '^#' "$NEXO_DIR/.env" | xargs) 2>/dev/null || true
fi

DASHBOARD_PORT="${DASHBOARD_PORT:-3456}"
LUNA_PORT="${LUNA_PORT:-3458}"
VITE_PORT="${VITE_PORT:-5173}"

# ── Colors ──
colors() {
  CYAN='\033[0;36m'
  MAGENTA='\033[0;35m'
  YELLOW='\033[1;33m'
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  DIM='\033[2m'
  BOLD='\033[1m'
  NC='\033[0m'
}

start_services() {
  colors
  echo -e "${BOLD}${GREEN}"
  echo "╔══════════════════════════════════════════════════════════════╗"
  echo "║     NEXO DIGITAL PRO + LUNA WEB — Unified Launcher         ║"
  echo "╠══════════════════════════════════════════════════════════════╣"
  printf "║  Dashboard:      http://localhost:%-4s                     ║\n" "$DASHBOARD_PORT"
  printf "║  Luna Web:       http://localhost:%-4s                     ║\n" "$LUNA_PORT"
  printf "║  Luna Web Dev:   http://localhost:%-4s                     ║\n" "$VITE_PORT"
  echo "╚══════════════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "${BOLD}Diretorio de instalacao:${NC} $NEXO_DIR"
  echo ""

  # 1. Nexo Backend
  echo -e "${CYAN}▶ Iniciando NEXO Dashboard (porta ${DASHBOARD_PORT}) via PM2...${NC}"
  cd "$DASHBOARD_DIR/backend"
  pm2 start server.js --name nexo-dashboard --update-env --env PORT="$DASHBOARD_PORT" 2>/dev/null || pm2 restart nexo-dashboard 2>/dev/null

  # 2. Luna Web Server
  echo -e "${MAGENTA}▶ Iniciando Luna Web Server (porta ${LUNA_PORT}) via PM2...${NC}"
  cd "$DASHBOARD_DIR/backend"
  pm2 start luna-server.js --name luna-server --update-env --env LUNA_PORT="$LUNA_PORT" 2>/dev/null || pm2 restart luna-server 2>/dev/null

  # 3. Luna Web Vite (dev mode — optional)
  if [ -f "$LUNA_WEB/node_modules/.bin/vite" ]; then
    echo -e "${YELLOW}▶ Iniciando Luna Web Vite (porta ${VITE_PORT}) via PM2...${NC}"
    cd "$LUNA_WEB"
    pm2 start "npx vite --host --port $VITE_PORT" --name luna-vite 2>/dev/null || pm2 restart luna-vite 2>/dev/null
  fi

  # 4. Telegram Bot
  if [ -f "$DASHBOARD_DIR/agents/telegram-luna-adapter.cjs" ]; then
    echo -e "${GREEN}▶ Iniciando Telegram Bot via PM2...${NC}"
    cd "$DASHBOARD_DIR/agents"
    pm2 start telegram-luna-adapter.cjs --name telegram-bot 2>/dev/null || pm2 restart telegram-bot 2>/dev/null
  elif [ -f "$LUNA_KERNEL_DIR/telegram-luna-adapter.cjs" ]; then
    echo -e "${GREEN}▶ Iniciando Telegram Bot via PM2...${NC}"
    cd "$LUNA_KERNEL_DIR"
    pm2 start telegram-luna-adapter.cjs --name telegram-bot 2>/dev/null || pm2 restart telegram-bot 2>/dev/null
  fi

  pm2 save > /dev/null 2>&1

  sleep 2
  echo ""
  echo -e "${GREEN}${BOLD}✓ Todos os servicos iniciados via PM2!${NC}"
  echo -e "${DIM}  Use './dashboard/luna-nexo.sh status' para verificar${NC}"
  echo -e "${DIM}  Use './dashboard/luna-nexo.sh stop' para encerrar${NC}"
  echo -e "${DIM}  Use 'pm2 logs' para ver logs em tempo real${NC}"
  echo ""
}

stop_services() {
  colors
  echo -e "${BOLD}${RED}Encerrando todos os servicos via PM2...${NC}"
  pm2 stop luna-server nexo-dashboard luna-vite telegram-bot 2>/dev/null || true
  echo -e "${GREEN}✓ Todos os servicos parados.${NC}"
}

status_services() {
  colors
  echo -e "${BOLD}Status dos Servicos (PM2):${NC}\n"
  pm2 status
  echo ""
  echo -e "${DIM}URLs:${NC}"
  echo -e "  ${CYAN}http://localhost:${DASHBOARD_PORT}${NC} — Dashboard"
  echo -e "  ${MAGENTA}http://localhost:${LUNA_PORT}${NC} — Luna Web"
  echo -e "  ${YELLOW}http://localhost:${VITE_PORT}${NC} — Luna Web Dev (Vite)"
}

show_logs() {
  colors
  echo -e "${BOLD}Logs em tempo real via PM2 (Ctrl+C para sair):${NC}\n"
  pm2 logs
}

case "${1:-start}" in
  start)
    start_services
    ;;
  stop)
    stop_services
    ;;
  restart)
    stop_services
    sleep 2
    start_services
    ;;
  status)
    status_services
    ;;
  logs)
    show_logs
    ;;
  *)
    echo "Uso: $0 [start|stop|restart|status|logs]"
    echo ""
    echo "  start   — Inicia todos os servicos em background"
    echo "  stop    — Encerra todos os servicos"
    echo "  restart — Reinicia todos os servicos"
    echo "  status  — Mostra status de cada servico"
    echo "  logs    — Inicia em foreground com logs coloridos"
    exit 1
    ;;
esac
