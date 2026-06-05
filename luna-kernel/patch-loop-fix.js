const fs = require('fs');
const path = '/home/jhin/.luna-kernel/luna-soul.cjs';
let content = fs.readFileSync(path, 'utf8');

const oldText = '    if (lastLine.length > 15 && !lineEnd.test(lastLine)) return true;\n  }