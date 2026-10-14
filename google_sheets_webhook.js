/**
 * ==============================================================================
 * GOOGLE APPS SCRIPT - CAPTURA DE LEADS PC PR 2026
 * ==============================================================================
 * Como usar em 2 minutos (100% Gratuito):
 * 
 * 1. Acesse https://sheets.google.com e crie uma nova planilha com o nome "Leads PC PR 2026".
 * 2. Na primeira linha da planilha (cabeçalho), escreva:
 *    A1: Data e Hora
 *    B1: Evento
 *    C1: E-mail
 *    D1: Nome
 *    E1: Cargo
 *    F1: Acertos
 *    G1: Total Questões
 *    H1: Percentual (%)
 *    I1: Tempo Gasto
 * 
 * 3. No menu superior da planilha, clique em: Extensões > Apps Script.
 * 4. Apague qualquer código existente e cole exatamente o código abaixo.
 * 5. Clique em "Implantar" (canto superior direito) > "Nova implantação".
 * 6. Na engrenagem, selecione o tipo: "App da Web".
 *    - Descrição: "Webhook Leads PC PR"
 *    - Executar como: "Eu (seu email)"
 *    - Quem pode acessar: "Qualquer pessoa" (MUITO IMPORTANTE!)
 * 7. Clique em "Implantar" e autorize o acesso da sua conta Google.
 * 8. Copie a "URL do app da Web" gerada (termina com /exec).
 * 9. Cole essa URL no arquivo js/app.js na linha 17 (CONFIG.WEBHOOK_URL).
 * ==============================================================================
 */

function doPost(e) {
  try {
    var sheet = SpreadsheetApp.getActiveSpreadsheet().getActiveSheet();
    var data = JSON.parse(e.postData.contents);
    
    var dataHora = data.data_hora || new Date().toLocaleString("pt-BR", { timeZone: "America/Sao_Paulo" });
    var evento = data.evento || "lead_identificado";
    var email = data.email || "";
    var nome = data.nome || "";
    var cargo = data.cargo || "";
    var acertos = data.acertos !== undefined ? data.acertos : "";
    var total = data.total_questoes !== undefined ? data.total_questoes : "";
    var percentual = data.percentual !== undefined ? data.percentual + "%" : "";
    var tempo = data.tempo_gasto || "";

    // Adiciona uma nova linha com os dados recebidos do simulado
    sheet.appendRow([
      dataHora,
      evento,
      email,
      nome,
      cargo,
      acertos,
      total,
      percentual,
      tempo
    ]);

    return ContentService.createTextOutput(JSON.stringify({ status: "success" }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService.createTextOutput(JSON.stringify({ status: "error", message: err.toString() }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet(e) {
  return ContentService.createTextOutput("Webhook de Leads PC PR 2026 está ativo e operacional!");
}
