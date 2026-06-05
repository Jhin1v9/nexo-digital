const fs = require('fs');
const path = '/home/jhin/.luna-kernel/luna-soul.cjs';
let content = fs.readFileSync(path, 'utf8');

const oldFunc = 'function isIncompleteResponse(text) {\n  if (!text || text.length < 20) return false;\n  const t = text.trim();';

const newFunc = `function isJsonResponseComplete(text) {
  try {
    const trimmed = text.trim();
    const cleaned = trimmed
      .replace(/^\`\`\`json\\s*/i, '')
      .replace(/^\`\`\`\\s*/i, '')
      .replace(/\`\`\`\\s*$/i, '')
      .trim();
    const parsed = JSON.parse(cleaned);
    if (parsed.response !== undefined || parsed.tool !== undefined || parsed.script !== undefined) {
      return true;
    }
  } catch {}
  return false;
}

function isIncompleteResponse(text) {
  if (!text || text.length < 20) return false;
  if (isJsonResponseComplete(text)) return false;
  const t = text.trim();`;

if (content.includes(oldFunc)) {
  content = content.replace(oldFunc, newFunc);
  fs.writeFileSync(path, content);
  console.log('PATCH APLICADO: isJsonResponseComplete adicionado');
} else {
  console.log('PATCH FALHOU: oldFunc não encontrado');
  console.log('Procurando por:', oldFunc.slice(0, 50));
}
