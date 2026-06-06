# 🔧 Resolução de Problemas

Guia de troubleshooting para o NEXO Dashboard PRO + Luna Kernel v5.0.

---

## ❌ Portas em uso

**Erro:** `EADDRINUSE: address already in use :::3456`

**Solução:**
```bash
# Descobrir qual processo está usando a porta
sudo lsof -i :3456
# ou
sudo ss -tlnp | grep :3456

# Matar o processo
sudo kill -9 <PID>

# Ou use o stop.sh
./stop.sh
```

Para mudar as portas, edite o `.env`:
```
DASHBOARD_PORT=3456
LUNA_PORT=3458
VITE_PORT=5173
```

---

## ❌ PostgreSQL não conecta

**Erro:** `connection refused` ou `database does not exist`

**Soluções:**

1. **Verifique se o PostgreSQL está rodando:**
```bash
sudo systemctl status postgresql
sudo systemctl start postgresql
```

2. **Verifique a DATABASE_URL:**
```bash
psql "$(grep DATABASE_URL .env | cut -d= -f2-)" -c "SELECT 1;"
```

3. **Configure PostgreSQL local (Ubuntu/Debian):**
```bash
./dashboard/setup-local-pg.sh
```

4. **Verifique permissões do usuário:**
```bash
sudo -u postgres psql -c "\du"
```

---

## ❌ Build falhando

**Erro:** `Cannot find module` ou `Build failed`

**Solução:**
```bash
# Limpar e reinstalar
rm -rf dashboard/frontend/node_modules dashboard/frontend/dist
rm -rf luna-kernel/luna-web/node_modules luna-kernel/luna-web/dist
rm -rf dashboard/node_modules luna-kernel/node_modules

# Reinstalar tudo
npm run install:all

# Rebuild
npm run build:all
```

---

## ❌ PM2 processos travados

**Erro:** Processos não respondem ou estão em estado `errored`

**Solução:**
```bash
# Limpar todos os processos PM2
pm2 delete all
pm2 save

# Reiniciar
./dashboard/luna-nexo.sh start

# Ver logs
pm2 logs
```

---

## ❌ Chrome/Chromium não encontrado

**Erro:** `Chrome not found` ou Luna Bridge não inicia

**Solução (Ubuntu/Debian):**
```bash
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list'
sudo apt-get update
sudo apt-get install -y google-chrome-stable
```

**Verifique:**
```bash
google-chrome --version
```

---

## ❌ Extensão Chrome não carrega

**Erro:** Extensão não aparece ou não intercepta

**Solução:**
1. Abra Chrome → `chrome://extensions/`
2. Ative "Modo do desenvolvedor" (canto superior direito)
3. Clique em "Carregar sem compactação"
4. Selecione a pasta `luna-kernel/luna-extension/`

**Para atualizar:**
```bash
cd luna-kernel/luna-extension
# Recarregue na página chrome://extensions/
```

---

## ❌ Telegram bot não responde

**Erro:** Mensagens no grupo não são processadas

**Soluções:**

1. **Verifique o token:**
```bash
curl -s "https://api.telegram.org/bot<TOKEN>/getMe"
```

2. **Verifique o chat ID:**
```bash
curl -s "https://api.telegram.org/bot<TOKEN>/getUpdates" | jq ".result[-1].message.chat.id"
```

3. **Verifique se o bot está no grupo**

4. **Verifique logs:**
```bash
pm2 logs telegram-bot
```

---

## ❌ Luna Web não acessível

**Erro:** `Cannot GET /` ou página em branco

**Solução:**
1. Verifique se o build existe:
```bash
ls luna-kernel/luna-web/dist/index.html
```

2. Se não existir:
```bash
cd luna-kernel/luna-web
npm run build
```

3. Verifique se o Luna Server está rodando:
```bash
curl http://localhost:3458/
```

---

## ❌ Health check falha

**Solução:**
```bash
./health-check.sh
```

Se falhar, verifique:
1. `./start.sh` foi executado?
2. As portas estão livres?
3. O `.env` está configurado?
4. PostgreSQL está rodando?

---

## 📞 Ainda com problemas?

1. Verifique os logs em `logs/`
2. Verifique logs do PM2: `pm2 logs`
3. Verifique logs do sistema: `journalctl -u postgresql`
4. Consulte o README principal para links de suporte
