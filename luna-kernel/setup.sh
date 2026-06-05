#!/bin/bash
# ═══════════════════════════════════════════════════════════════════════════
# Luna Kernel — Setup Script para PC do Pai (ou qualquer clone)
# NEXO DIGITAL S.L.
# ═══════════════════════════════════════════════════════════════════════════

set -e

REPO_URL="https://github.com/Jhin1v9/nexo-digital"
NODE_MIN_VERSION=20
LUNA_PORT=3458
DASHBOARD_PORT=3456

echo ""
echo "🌙 ╔══════════════════════════════════════════════════════════════╗"
echo "🌙 ║   Luna Kernel — Setup Automático                              ║"
echo "🌙 ║   NEXO DIGITAL S.L. — Clone do Repo Oficial                  ║"
echo "🌙 ╚══════════════════════════════════════════════════════════════╝"
echo ""

# ── 1. Verificar Node.js ──
echo "📦 Verificando Node.js..."
if ! command -v node &> /dev/null; then
    echo "❌ Node.js não encontrado."
    echo "   Instale: sudo apt-get install nodejs npm"
    echo "   Ou: https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v | sed 's/v//;s/\..*//')
if [ "$NODE_VERSION" -lt "$NODE_MIN_VERSION" ]; then
    echo "❌ Node.js v${NODE_VERSION} encontrado, mas v${NODE_MIN_VERSION}+ é obrigatório."
    exit 1
fi
echo "✅ Node.js $(node -v)"

# ── 2. Verificar Git ──
echo ""
echo "📦 Verificando Git..."
if ! command -v git &> /dev/null; then
    echo "❌ Git não encontrado."
    echo "   Instale: sudo apt-get install git"
    exit 1
fi
echo "✅ Git $(git --version | awk '{print $3}')"

# ── 3. Verificar Google Chrome ──
echo ""
echo "🔍 Verificando Chrome/Chromium..."
CHROME_FOUND=false
if command -v google-chrome &> /dev/null; then
    echo "✅ Google Chrome encontrado"
    CHROME_FOUND=true
elif command -v chromium-browser &> /dev/null; then
    echo "✅ Chromium Browser encontrado"
    CHROME_FOUND=true
elif command -v chromium &> /dev/null; then
    echo "✅ Chromium encontrado"
    CHROME_FOUND=true
fi

if [ "$CHROME_FOUND" = false ]; then
    echo "⚠️  Chrome/Chromium NÃO encontrado."
    echo "   A Luna precisa do Chrome para o Kimi Web Bridge."
    echo "   Instale: sudo apt-get install google-chrome-stable"
    echo ""
    read -p "Continuar mesmo assim? (s/n): " CONTINUE
    if [ "$CONTINUE" != "s" ] && [ "$CONTINUE" != "S" ]; then
        exit 1
    fi
fi

# ── 4. Clonar ou atualizar repo ──
echo ""
echo "📥 Clonando repo nexo-digital..."
INSTALL_DIR="${HOME}/nexo-digital"
if [ -d "$INSTALL_DIR" ]; then
    echo "   Diretório existe. Atualizando..."
    cd "$INSTALL_DIR"
    git pull origin main
else
    echo "   Clonando..."
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

# ── 5. Instalar dependências da Luna ──
echo ""
echo "📦 Instalando dependências da Luna Kernel..."
cd luna-kernel
npm install 2>&1 | tail -5

# ── 6. Ajustar paths no package.json ──
echo ""
echo "🔧 Ajustando paths para ambiente local..."
# O package.json original aponta pra /home/jhin/NEXO_DASHBOARD_PRO/...
# Precisamos ajustar pro path relativo do clone
if [ -f "package.json" ]; then
    # Backup do original
    cp package.json package.json.backup
    # Ajustar o path do start script
    sed -i "s|/home/jhin/NEXO_DASHBOARD_PRO/backend/luna-server.js|../dashboard/backend/luna-server.js|g" package.json
    echo "✅ Paths ajustados no package.json"
fi

# ── 7. Criar .env (se não existir) ──
echo ""
echo "📝 Configurando ambiente..."
if [ ! -f ".env" ]; then
    cat > .env << 'ENVEOF'
# ═══════════════════════════════════════════════════════════════════════════
# Luna Kernel v5.0 — Environment Configuration
# NEXO DIGITAL S.L.
# ═══════════════════════════════════════════════════════════════════════════

# ── REQUIRED ──

# Telegram Bot Token (get from @BotFather: https://t.me/BotFather)
# Create a bot, copy the token, paste here
TELEGRAM_BOT_TOKEN=your_telegram_bot_token_here

# Internal API Token for NEXO Dashboard
# Used for dashboardCreateTask, dashboardListTasks, etc.
INTERNAL_API_TOKEN=your_dashboard_api_token_here

# JWT Secret for web sessions (min 32 chars)
JWT_SECRET=your_jwt_secret_here_min_32_chars

# ── OPTIONAL (have defaults) ──

# Kimi Bridge Settings
KIMI_TIMEOUT=120000
KIMI_MAX_PAGES=5
KIMI_IDLE_TIMEOUT=600000
KIMI_COOLDOWN_MS=5000
KIMI_MAX_TYPE_LENGTH=500
KIMI_LOG_MAX_MB=10

# Context Auto-Compaction
LUNA_COMPACT_THRESHOLD=24
LUNA_COMPACT_TOKEN_THRESHOLD=120000

# Chrome Path (auto-detected if not set)
# LUNA_CHROME_PATH=/usr/bin/google-chrome

# Debug Mode
# LUNA_DEBUG=true

# Web Server Port
LUNA_CONFIG_PORT=3458

# Dashboard Port
DASHBOARD_PORT=3456
ENVEOF
    echo "✅ .env template criado."
    echo "   ⚠️  IMPORTANTE: Edite o .env e preencha seus tokens!"
    echo ""
    echo "   nano luna-kernel/.env"
    echo ""
else
    echo "✅ .env já existe. Mantido o atual."
fi

# ── 8. Instalar dependências do Dashboard (opcional) ──
echo ""
echo "📦 Instalando dependências do Dashboard (opcional)..."
cd ../dashboard
if [ -f "package.json" ]; then
    npm install 2>&1 | tail -5
    echo "✅ Dashboard dependencies instaladas"
else
    echo "⚠️  package.json do dashboard não encontrado"
fi

# ── 9. Done ──
echo ""
echo "🌙 ╔══════════════════════════════════════════════════════════════╗"
echo "🌙 ║   Setup completo!                                            ║"
echo "🌙 ╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📋 Estrutura criada:"
echo ""
echo "   ${HOME}/nexo-digital/"
echo "   ├── dashboard/          ← NEXO Dashboard Pro"
echo "   ├── luna-kernel/        ← Luna AI Kernel"
echo "   │   ├── .env            ← CONFIGURAR!"
echo "   │   └── ..."
echo "   └── .agents/            ← Documentação"
echo ""
echo "🚀 Próximos passos:"
echo ""
echo "   1️⃣  Configure o .env:"
echo "       cd ~/nexo-digital/luna-kernel"
echo "       nano .env"
echo ""
echo "   2️⃣  Inicie a Luna:"
echo ""
echo "       🌐 WEB INTERFACE (recomendado):"
echo "       npm start"
echo "       → Abra: http://localhost:3458"
echo ""
echo "       💬 TELEGRAM BOT:"
echo "       npm run telegram"
echo ""
echo "       💻 CLI (terminal):"
echo "       npm run cli"
echo ""
echo "   3️⃣  Inicie o Dashboard (opcional):"
echo "       cd ~/nexo-digital/dashboard"
echo "       npm run dev"
echo "       → Abra: http://localhost:3456"
echo ""
echo "⚠️  IMPORTANTE:"
echo "   - O .env precisa ser configurado manualmente"
echo "   - Copie os tokens do seu PC atual pro PC do seu pai"
echo "   - O Kimi Bridge precisa de login no Kimi (cookies)"
echo ""
echo "🌙 Luna pronta para usar! 🚀"
echo ""
