/**
 * Script standalone para enviar mensagens Telegram via NEXO Dashboard
 * Usa o serviço telegram-notification.service.js existente
 */

require('dotenv').config({ path: '../../.env' });

const { sendCustomMessage } = require('../services/telegram-notification.service.js');

const message = process.argv[2] || '📢 Mensagem de teste do NEXO Dashboard';

async function main() {
  console.log('[SendTelegram] Enviando mensagem...');
  console.log('[SendTelegram] Mensagem:', message);
  
  try {
    const result = await sendCustomMessage(message, { parse_mode: 'MarkdownV2' });
    console.log('[SendTelegram] Resultado:', result);
    
    if (result.sent) {
      console.log('✅ Mensagem enviada com sucesso!');
      process.exit(0);
    } else {
      console.error('❌ Falha ao enviar:', result.reason || 'unknown');
      process.exit(1);
    }
  } catch (e) {
    console.error('❌ Erro:', e.message);
    process.exit(1);
  }
}

main();
