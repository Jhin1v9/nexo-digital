#!/usr/bin/env node
/**
 * Test Suite — Dashboard Tools
 * Testa todas as tools do dashboard via luna-tools.cjs
 */

const tools = require('./luna-tools.cjs');
const fs = require('fs');

const RESULTS = [];
const TEST_TIMESTAMP = Date.now();
const TEST_PREFIX = `[TEST-${TEST_TIMESTAMP}]`;

function log(category, name, status, detail = '') {
  RESULTS.push({ category, name, status, detail, time: new Date().toISOString() });
  const icon = status === 'PASS' ? '✅' : status === 'FAIL' ? '❌' : status === 'WARN' ? '⚠️' : '⏭️';
  console.log(`${icon} [${category}] ${name}${detail ? ' — ' + detail : ''}`);
}

async function runTest(category, name, fn, ...args) {
  try {
    const result = await fn(...args);
    if (result && result.success === false) {
      log(category, name, 'FAIL', result.error || 'Unknown error');
      return { ok: false, error: result.error };
    }
    const detail = result?.stdout || result?.message || (typeof result === 'object' ? JSON.stringify(result).slice(0, 100) : String(result).slice(0, 100));
    log(category, name, 'PASS', detail);
    return { ok: true, result };
  } catch (e) {
    log(category, name, 'FAIL', e.message);
    return { ok: false, error: e.message };
  }
}

async function main() {
  console.log('='.repeat(70));
  console.log('  LUNA DASHBOARD TOOLS — TEST SUITE');
  console.log('  ' + new Date().toISOString());
  console.log('='.repeat(70));
  console.log();

  // ─── HEALTH CHECK ───
  console.log('--- HEALTH CHECK ---');
  await runTest('Health', 'getSystemStatus', tools.dashboardGetSystemStatus);
  await runTest('Health', 'getSystemLogs', tools.dashboardGetSystemLogs, { lines: 5 });
  console.log();

  // ─── TASKS ───
  console.log('--- TASKS ---');
  const taskTitle = `${TEST_PREFIX} Tarefa de Teste`;
  const taskCreate = await runTest('Tasks', 'createTask', tools.dashboardCreateTask, {
    title: taskTitle, description: 'Descrição de teste automatizado',
    priority: 'medium', taskType: 'one_time', assignedTo: 'TestBot'
  });

  await runTest('Tasks', 'listTasks', tools.dashboardListTasks, {});

  let taskId = taskCreate.ok ? taskCreate.result?.id : null;
  if (!taskId && taskCreate.ok) {
    // Try to extract ID from stdout
    const match = taskCreate.result?.stdout?.match(/ID:\s*(\w+)/);
    if (match) taskId = match[1];
  }

  if (taskId) {
    await runTest('Tasks', 'updateTask', tools.dashboardUpdateTask, { id: taskId, status: 'in_progress' });
    await runTest('Tasks', 'addComment', tools.dashboardAddComment, { id: taskId, comment: 'Comentário de teste' });
    await runTest('Tasks', 'completeTask', tools.dashboardCompleteTask, { id: taskId });
    await runTest('Tasks', 'deleteTask', tools.dashboardDeleteTask, { id: taskId });
  } else {
    log('Tasks', 'update/addComment/complete/delete', 'SKIP', 'No task ID from creation');
  }
  console.log();

  // ─── LEADS ───
  console.log('--- LEADS ---');
  const leadName = `${TEST_PREFIX} Lead de Teste`;
  const leadCreate = await runTest('Leads', 'createLead', tools.dashboardCreateLead, {
    name: leadName, email: 'test@luna.bot', phone: '+5511999999999',
    source: 'luna-test', estimatedValue: 1000
  });

  await runTest('Leads', 'listLeads', tools.dashboardListLeads, {});

  let leadId = null;
  if (leadCreate.ok) {
    const match = leadCreate.result?.stdout?.match(/ID:\s*(\w+)/);
    if (match) leadId = match[1];
  }

  if (leadId) {
    await runTest('Leads', 'updateLead', tools.dashboardUpdateLead, { id: leadId, pipelineStatus: 'contacted' });
    await runTest('Leads', 'convertLead', tools.dashboardConvertLead, { id: leadId });
    await runTest('Leads', 'deleteLead', tools.dashboardDeleteLead, { id: leadId });
  } else {
    log('Leads', 'update/convert/delete', 'SKIP', 'No lead ID from creation');
  }
  console.log();

  // ─── FINANCE ───
  console.log('--- FINANCE ---');
  await runTest('Finance', 'getFinanceSummary', tools.dashboardGetFinanceSummary, {});
  await runTest('Finance', 'getCashBox', tools.dashboardGetCashBox, {});
  await runTest('Finance', 'listPayments', tools.dashboardListPayments, {});
  await runTest('Finance', 'listExpenses', tools.dashboardListExpenses, {});
  await runTest('Finance', 'listCashHistory', tools.dashboardListCashHistory, {});

  const paymentCreate = await runTest('Finance', 'createPayment', tools.dashboardCreatePayment, {
    clientName: 'Cliente Teste', description: 'Pagamento de teste',
    amount: 99.99, dueDate: new Date().toISOString().split('T')[0]
  });

  const expenseCreate = await runTest('Finance', 'createExpense', tools.dashboardCreateExpense, {
    description: 'Despesa de teste', amount: 49.99,
    category: 'teste', dueDate: new Date().toISOString().split('T')[0]
  });

  let paymentId = null;
  if (paymentCreate.ok) {
    const match = paymentCreate.result?.stdout?.match(/ID:\s*(\w+)/);
    if (match) paymentId = match[1];
  }
  if (paymentId) {
    await runTest('Finance', 'updatePayment', tools.dashboardUpdatePayment, { id: paymentId, status: 'paid' });
    await runTest('Finance', 'deletePayment', tools.dashboardDeletePayment, { id: paymentId });
  }

  let expenseId = null;
  if (expenseCreate.ok) {
    const match = expenseCreate.result?.stdout?.match(/ID:\s*(\w+)/);
    if (match) expenseId = match[1];
  }
  if (expenseId) {
    await runTest('Finance', 'updateExpense', tools.dashboardUpdateExpense, { id: expenseId, status: 'paid' });
    await runTest('Finance', 'deleteExpense', tools.dashboardDeleteExpense, { id: expenseId });
  }
  console.log();

  // ─── IDEAS ───
  console.log('--- IDEAS ---');
  const ideaCreate = await runTest('Ideas', 'createIdea', tools.dashboardCreateIdea, {
    title: `${TEST_PREFIX} Ideia de Teste`,
    description: 'Descrição da ideia de teste',
    category: 'teste', priority: 'low'
  });
  await runTest('Ideas', 'listIdeas', tools.dashboardListIdeas, {});
  console.log();

  // ─── QUOTES ───
  console.log('--- QUOTES ---');
  const quoteCreate = await runTest('Quotes', 'createQuote', tools.dashboardCreateQuote, {
    clientName: 'Cliente Teste', projectDescription: 'Projeto de teste',
    estimatedValue: 5000, currency: 'EUR'
  });
  await runTest('Quotes', 'listQuotes', tools.dashboardListQuotes, {});
  let quoteId = null;
  if (quoteCreate.ok) {
    const match = quoteCreate.result?.stdout?.match(/ID:\s*(\w+)/);
    if (match) quoteId = match[1];
  }
  if (quoteId) {
    await runTest('Quotes', 'updateQuote', tools.dashboardUpdateQuote, { id: quoteId, status: 'sent' });
    await runTest('Quotes', 'deleteQuote', tools.dashboardDeleteQuote, { id: quoteId });
  }
  console.log();

  // ─── PROJECTS / CLIENTS ───
  console.log('--- PROJECTS / CLIENTS ---');
  await runTest('Projects', 'listProjects', tools.dashboardListProjects, {});
  await runTest('Clients', 'listClients', tools.dashboardListClients, {});
  console.log();

  // ─── LINKS ───
  console.log('--- LINKS ---');
  const linkCreate = await runTest('Links', 'addLink', tools.dashboardAddLink, {
    url: 'https://example.com/luna-test', title: 'Link de Teste', category: 'teste'
  });
  await runTest('Links', 'listLinks', tools.dashboardListLinks, {});
  await runTest('Links', 'getLinksStats', tools.dashboardGetLinksStats, {});
  let linkId = null;
  if (linkCreate.ok) {
    const match = linkCreate.result?.stdout?.match(/ID:\s*(\w+)/);
    if (match) linkId = match[1];
  }
  if (linkId) {
    await runTest('Links', 'deleteLink', tools.dashboardDeleteLink, { id: linkId });
  }
  console.log();

  // ─── EMAILS / WHATSAPP ───
  console.log('--- EMAILS / WHATSAPP ---');
  await runTest('Emails', 'listEmails', tools.dashboardListEmails, {});
  await runTest('WhatsApp', 'getWhatsAppStatus', tools.dashboardGetWhatsAppStatus, {});
  await runTest('WhatsApp', 'getWhatsAppHistory', tools.dashboardGetWhatsAppHistory, {});
  await runTest('WhatsApp', 'getWhatsAppClassifications', tools.dashboardGetWhatsAppClassifications, {});
  console.log();

  // ─── NOTIFICATIONS ───
  console.log('--- NOTIFICATIONS ---');
  await runTest('Notifications', 'listNotifications', tools.dashboardListNotifications, {});
  await runTest('Notifications', 'markAllNotificationsRead', tools.dashboardMarkAllNotificationsRead, {});
  console.log();

  // ─── USERS / MEMBERS ───
  console.log('--- USERS / MEMBERS ---');
  await runTest('Users', 'listUsers', tools.dashboardListUsers, {});
  await runTest('Members', 'listMembers', tools.dashboardListMembers, {});
  console.log();

  // ─── BUG REPORTS ───
  console.log('--- BUG REPORTS ---');
  await runTest('BugReports', 'listBugReports', tools.dashboardListBugReports, {});
  console.log();

  // ─── GITHUB / VERCEL ───
  console.log('--- GITHUB / VERCEL ---');
  await runTest('GitHub', 'listGitHubRepos', tools.dashboardListGitHubRepos, {});
  await runTest('Vercel', 'listVercelProjects', tools.dashboardListVercelProjects, {});
  console.log();

  // ─── OPS ALERTS ───
  console.log('--- OPS ALERTS ---');
  await runTest('OpsAlerts', 'listOpsAlerts', tools.dashboardListOpsAlerts, {});
  console.log();

  // ─── TRANSACTIONS / STATE ───
  console.log('--- TRANSACTIONS / STATE ---');
  await runTest('Transactions', 'listTransactions', tools.dashboardListTransactions, {});
  await runTest('State', 'getNexoState', tools.dashboardGetNexoState, {});
  await runTest('Config', 'getConfig', tools.dashboardGetConfig, {});
  console.log();

  // ─── VOTING ───
  console.log('--- VOTING ---');
  await runTest('Voting', 'listVotingSessions', tools.dashboardListVotingSessions, {});
  console.log();

  // ─── ROADMAPS ───
  console.log('--- ROADMAPS ---');
  await runTest('Roadmaps', 'listRoadmaps', tools.dashboardListRoadmaps, {});
  console.log();

  // ─── PROJECT TYPES / TIMELINE ───
  console.log('--- PROJECT TYPES ---');
  await runTest('ProjectTypes', 'listProjectTypes', tools.dashboardListProjectTypes, {});
  console.log();

  // ─── REPORT ───
  console.log();
  console.log('='.repeat(70));
  console.log('  RELATÓRIO FINAL');
  console.log('='.repeat(70));

  const total = RESULTS.length;
  const passed = RESULTS.filter(r => r.status === 'PASS').length;
  const failed = RESULTS.filter(r => r.status === 'FAIL').length;
  const skipped = RESULTS.filter(r => r.status === 'SKIP').length;
  const warned = RESULTS.filter(r => r.status === 'WARN').length;

  console.log(`
Total de testes:  ${total}
✅ Passaram:      ${passed}
❌ Falharam:      ${failed}
⚠️  Avisos:        ${warned}
⏭️  Pulados:       ${skipped}
Taxa de sucesso:  ${total > 0 ? ((passed / total) * 100).toFixed(1) : 0}%
`);

  if (failed > 0) {
    console.log('--- FALHAS DETALHADAS ---');
    for (const r of RESULTS.filter(x => x.status === 'FAIL')) {
      console.log(`❌ [${r.category}] ${r.name}`);
      console.log(`   Erro: ${r.detail}`);
    }
  }

  // Save report
  const reportPath = `/home/jhin/.luna-kernel/dashboard-test-report-${TEST_TIMESTAMP}.md`;
  const reportMd = generateMarkdownReport(RESULTS, { total, passed, failed, skipped, warned });
  fs.writeFileSync(reportPath, reportMd, 'utf8');
  console.log(`\n📄 Relatório salvo em: ${reportPath}`);
}

function generateMarkdownReport(results, stats) {
  const lines = [];
  lines.push('# Relatório de Testes — Dashboard Tools');
  lines.push('');
  lines.push(`**Data:** ${new Date().toISOString()}`);
  lines.push(`**Total:** ${stats.total} | ✅ ${stats.passed} | ❌ ${stats.failed} | ⚠️ ${stats.warned} | ⏭️ ${stats.skipped}`);
  lines.push(`**Taxa de sucesso:** ${stats.total > 0 ? ((stats.passed / stats.total) * 100).toFixed(1) : 0}%`);
  lines.push('');

  const categories = [...new Set(results.map(r => r.category))];
  for (const cat of categories) {
    lines.push(`## ${cat}`);
    lines.push('');
    lines.push('| Tool | Status | Detalhe |');
    lines.push('|------|--------|---------|');
    for (const r of results.filter(x => x.category === cat)) {
      const icon = r.status === 'PASS' ? '✅' : r.status === 'FAIL' ? '❌' : r.status === 'WARN' ? '⚠️' : '⏭️';
      const detail = (r.detail || '').replace(/\|/g, '\\|').replace(/\n/g, ' ').slice(0, 80);
      lines.push(`| ${r.name} | ${icon} ${r.status} | ${detail} |`);
    }
    lines.push('');
  }

  if (stats.failed > 0) {
    lines.push('## Falhas Detalhadas');
    lines.push('');
    for (const r of results.filter(x => x.status === 'FAIL')) {
      lines.push(`### ${r.category} — ${r.name}`);
      lines.push(`- **Erro:** ${r.detail}`);
      lines.push(`- **Horário:** ${r.time}`);
      lines.push('');
    }
  }

  return lines.join('\n');
}

main().catch(e => {
  console.error('Test suite failed:', e);
  process.exit(1);
});
