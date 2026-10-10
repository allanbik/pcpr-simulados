<?php
/**
 * API RESTful - Portal de Provas e Simulados PC PR 2026 (Banca FGV)
 * Agente de Polícia e Papiloscopista Policial
 */

declare(strict_types=1);

require_once __DIR__ . '/db.php';

// Headers para API REST e CORS
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

// Responder requisições OPTIONS (pre-flight CORS)
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

/**
 * Controller/Service do Simulado
 */
class SimuladoController {
    private PDO $pdo;

    public function __construct() {
        $this->pdo = Database::getConnection();
    }

    /**
     * Endpoint: GET /gerar-prova
     * Busca questões aleatórias respeitando as cotas por disciplina e une em 100 questões embaralhadas
     */
    public function gerarProva(): void {
        try {
            // 1. Busca todas as disciplinas cadastradas e suas respectivas cotas
            $stmtDisc = $this->pdo->query("SELECT id, nome, tipo, peso_questoes FROM disciplinas ORDER BY id ASC");
            $disciplinas = $stmtDisc->fetchAll();

            if (empty($disciplinas)) {
                $this->sendJson(404, [
                    'sucesso' => false,
                    'erro'    => 'Nenhuma disciplina encontrada no banco de dados. Execute o script database.sql.'
                ]);
                return;
            }

            $todasQuestoes = [];
            $distribuicaoReal = [];

            // 2. Para cada disciplina, busca as questões aleatórias respeitando a cota
            $sqlQuestao = "
                SELECT 
                    q.id,
                    q.disciplina_id,
                    d.nome AS disciplina_nome,
                    d.tipo AS disciplina_tipo,
                    q.enunciado,
                    q.alt_a,
                    q.alt_b,
                    q.alt_c,
                    q.alt_d,
                    q.alt_e,
                    q.gabarito,
                    q.comentario
                FROM questoes q
                INNER JOIN disciplinas d ON q.disciplina_id = d.id
                WHERE q.disciplina_id = :disciplina_id
                ORDER BY RAND()
                LIMIT :limite
            ";

            $stmtQ = $this->pdo->prepare($sqlQuestao);

            foreach ($disciplinas as $d) {
                $disciplinaId = (int)$d['id'];
                $cota = (int)$d['peso_questoes'];

                $stmtQ->bindValue(':disciplina_id', $disciplinaId, PDO::PARAM_INT);
                $stmtQ->bindValue(':limite', $cota, PDO::PARAM_INT);
                $stmtQ->execute();
                
                $questoesDisciplina = $stmtQ->fetchAll();
                $totalEncontradas = count($questoesDisciplina);

                $distribuicaoReal[] = [
                    'disciplina_id' => $disciplinaId,
                    'disciplina'    => $d['nome'],
                    'tipo'          => $d['tipo'],
                    'cota_esperada' => $cota,
                    'questoes_obtidas' => $totalEncontradas
                ];

                foreach ($questoesDisciplina as $item) {
                    $todasQuestoes[] = $item;
                }
            }

            if (empty($todasQuestoes)) {
                $this->sendJson(404, [
                    'sucesso' => false,
                    'erro'    => 'Não há questões cadastradas na base para gerar a prova.'
                ]);
                return;
            }

            // 3. Embaralha o array completo para simular uma prova objetiva dinâmica
            shuffle($todasQuestoes);

            // 4. Renumera as questões de 1 a N
            $questoesFormatadas = [];
            foreach ($todasQuestoes as $index => $q) {
                $q['numero'] = $index + 1;
                $questoesFormatadas[] = $q;
            }

            $this->sendJson(200, [
                'sucesso'        => true,
                'edital'         => 'PC PR 2026 - Concurso Agente de Polícia e Papiloscopista',
                'banca'          => 'FGV - Fundação Getulio Vargas',
                'total_questoes' => count($questoesFormatadas),
                'duracao_horas'  => 5,
                'duracao_segundos' => 5 * 3600,
                'distribuicao'   => $distribuicaoReal,
                'questoes'       => $questoesFormatadas
            ]);

        } catch (Throwable $e) {
            $this->sendJson(500, [
                'sucesso' => false,
                'erro'    => 'Erro ao gerar o simulado: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Endpoint: POST /salvar-resultado
     * Recebe o JSON com as respostas do usuário, calcula a correção e armazena o histórico
     */
    public function salvarResultado(): void {
        try {
            $inputRaw = file_get_contents('php://input');
            $data = json_decode($inputRaw, true);

            if (!$data || !is_array($data)) {
                $this->sendJson(400, [
                    'sucesso' => false,
                    'erro'    => 'JSON inválido ou corpo da requisição vazio.'
                ]);
                return;
            }

            $usuarioNome        = trim((string)($data['usuario_nome'] ?? 'Candidato PC PR'));
            if ($usuarioNome === '') {
                $usuarioNome = 'Candidato PC PR';
            }
            $tempoGastoSegundos = (int)($data['tempo_gasto_segundos'] ?? 0);
            $respostasUsuario   = $data['respostas'] ?? []; // Array associativo questao_id => resposta ou lista de objetos

            if (empty($respostasUsuario) || !is_array($respostasUsuario)) {
                $this->sendJson(400, [
                    'sucesso' => false,
                    'erro'    => 'Nenhuma resposta de questão informada no payload.'
                ]);
                return;
            }

            // Normaliza as respostas para o formato: questao_id => resposta
            $mapRespostas = [];
            foreach ($respostasUsuario as $key => $val) {
                if (is_array($val) && isset($val['questao_id'])) {
                    $mapRespostas[(int)$val['questao_id']] = strtoupper(trim((string)($val['resposta_usuario'] ?? '')));
                } else {
                    $mapRespostas[(int)$key] = strtoupper(trim((string)$val));
                }
            }

            $questaoIds = array_keys($mapRespostas);
            if (empty($questaoIds)) {
                $this->sendJson(400, [
                    'sucesso' => false,
                    'erro'    => 'IDs de questões inválidos.'
                ]);
                return;
            }

            // Busca as questões no banco de dados para conferir o gabarito oficial de forma idônea
            $placeholders = implode(',', array_fill(0, count($questaoIds), '?'));
            $sql = "
                SELECT 
                    q.id,
                    q.disciplina_id,
                    d.nome AS disciplina_nome,
                    d.tipo AS disciplina_tipo,
                    q.enunciado,
                    q.alt_a, q.alt_b, q.alt_c, q.alt_d, q.alt_e,
                    q.gabarito,
                    q.comentario
                FROM questoes q
                INNER JOIN disciplinas d ON q.disciplina_id = d.id
                WHERE q.id IN ($placeholders)
            ";

            $stmt = $this->pdo->prepare($sql);
            $stmt->execute($questaoIds);
            $questoesOficiais = $stmt->fetchAll();

            $totalQuestoes = count($questoesOficiais);
            $totalAcertos  = 0;
            $totalErros    = 0;
            $detalhesCorrecao = [];
            $desempenhoDisciplinas = [];

            foreach ($questoesOficiais as $q) {
                $qid = (int)$q['id'];
                $respUsuario = $mapRespostas[$qid] ?? '';
                $gabarito    = strtoupper((string)$q['gabarito']);
                $acertou     = ($respUsuario !== '' && $respUsuario === $gabarito);

                if ($acertou) {
                    $totalAcertos++;
                } else {
                    $totalErros++;
                }

                $discNome = $q['disciplina_nome'];
                if (!isset($desempenhoDisciplinas[$discNome])) {
                    $desempenhoDisciplinas[$discNome] = [
                        'disciplina'    => $discNome,
                        'tipo'          => $q['disciplina_tipo'],
                        'total'         => 0,
                        'acertos'       => 0,
                        'erros'         => 0,
                        'percentual'    => 0.0
                    ];
                }

                $desempenhoDisciplinas[$discNome]['total']++;
                if ($acertou) {
                    $desempenhoDisciplinas[$discNome]['acertos']++;
                } else {
                    $desempenhoDisciplinas[$discNome]['erros']++;
                }

                $detalhesCorrecao[] = [
                    'questao_id'       => $qid,
                    'disciplina'       => $discNome,
                    'tipo'             => $q['disciplina_tipo'],
                    'enunciado'        => $q['enunciado'],
                    'alt_a'            => $q['alt_a'],
                    'alt_b'            => $q['alt_b'],
                    'alt_c'            => $q['alt_c'],
                    'alt_d'            => $q['alt_d'],
                    'alt_e'            => $q['alt_e'],
                    'resposta_usuario' => $respUsuario,
                    'gabarito_oficial' => $gabarito,
                    'acertou'          => $acertou,
                    'comentario'       => $q['comentario']
                ];
            }

            // Calcula percentuais por disciplina e diagnósticos
            $melhoresDisciplinas = [];
            $pioresDisciplinas   = [];

            foreach ($desempenhoDisciplinas as $k => &$item) {
                $item['percentual'] = $item['total'] > 0 
                    ? round(($item['acertos'] / $item['total']) * 100, 1) 
                    : 0.0;

                if ($item['percentual'] >= 75.0) {
                    $melhoresDisciplinas[] = $item['disciplina'] . " ({$item['percentual']}%)";
                } elseif ($item['percentual'] < 60.0) {
                    $pioresDisciplinas[] = $item['disciplina'] . " ({$item['percentual']}%)";
                }
            }
            unset($item);

            $percentualGlobal = $totalQuestoes > 0 
                ? round(($totalAcertos / $totalQuestoes) * 100, 2) 
                : 0.0;

            // Gera o feedback inteligente solicitado no edital
            $feedbackTexto = $this->gerarFeedbackTexto($desempenhoDisciplinas, $percentualGlobal);

            // 4. Salva no banco de dados na tabela simulados_realizados
            $sqlInsert = "
                INSERT INTO simulados_realizados (
                    usuario_nome,
                    total_questoes,
                    total_acertos,
                    total_erros,
                    percentual_acerto,
                    tempo_gasto_segundos,
                    desempenho_disciplinas,
                    respostas_usuario
                ) VALUES (
                    :usuario_nome,
                    :total_questoes,
                    :total_acertos,
                    :total_erros,
                    :percentual_acerto,
                    :tempo_gasto_segundos,
                    :desempenho_disciplinas,
                    :respostas_usuario
                )
            ";

            $stmtInsert = $this->pdo->prepare($sqlInsert);
            $stmtInsert->execute([
                ':usuario_nome'           => $usuarioNome,
                ':total_questoes'         => $totalQuestoes,
                ':total_acertos'          => $totalAcertos,
                ':total_erros'            => $totalErros,
                ':percentual_acerto'      => $percentualGlobal,
                ':tempo_gasto_segundos'   => $tempoGastoSegundos,
                ':desempenho_disciplinas' => json_encode(array_values($desempenhoDisciplinas), JSON_UNESCAPED_UNICODE),
                ':respostas_usuario'      => json_encode($mapRespostas, JSON_UNESCAPED_UNICODE)
            ]);

            $simuladoId = (int)$this->pdo->lastInsertId();

            $this->sendJson(201, [
                'sucesso'                => true,
                'simulado_id'            => $simuladoId,
                'usuario_nome'           => $usuarioNome,
                'total_questoes'         => $totalQuestoes,
                'total_acertos'          => $totalAcertos,
                'total_erros'            => $totalErros,
                'percentual_acerto'      => $percentualGlobal,
                'tempo_gasto_segundos'   => $tempoGastoSegundos,
                'tempo_formatado'        => $this->formatarTempo($tempoGastoSegundos),
                'feedback_diagnostico'   => $feedbackTexto,
                'desempenho_disciplinas' => array_values($desempenhoDisciplinas),
                'questoes_corrigidas'    => $detalhesCorrecao
            ]);

        } catch (Throwable $e) {
            $this->sendJson(500, [
                'sucesso' => false,
                'erro'    => 'Erro ao salvar o resultado do simulado: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Endpoint: GET /historico
     * Lista o histórico dos simulados salvos
     */
    public function listarHistorico(): void {
        try {
            $sql = "
                SELECT 
                    id,
                    usuario_nome,
                    total_questoes,
                    total_acertos,
                    total_erros,
                    percentual_acerto,
                    tempo_gasto_segundos,
                    desempenho_disciplinas,
                    DATE_FORMAT(created_at, '%d/%m/%Y %H:%i') as data_formatada
                FROM simulados_realizados
                ORDER BY id DESC
                LIMIT 15
            ";

            $stmt = $this->pdo->query($sql);
            $registros = $stmt->fetchAll();

            $formatados = array_map(function ($row) {
                $row['desempenho_disciplinas'] = json_decode((string)$row['desempenho_disciplinas'], true);
                $row['tempo_formatado'] = $this->formatarTempo((int)$row['tempo_gasto_segundos']);
                return $row;
            }, $registros);

            $this->sendJson(200, [
                'sucesso'   => true,
                'historico' => $formatados
            ]);
        } catch (Throwable $e) {
            $this->sendJson(500, [
                'sucesso' => false,
                'erro'    => 'Erro ao carregar histórico: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Endpoint: GET /disciplinas
     * Lista as disciplinas cadastradas no banco
     */
    public function listarDisciplinas(): void {
        try {
            $stmt = $this->pdo->query("SELECT id, nome, tipo, peso_questoes FROM disciplinas ORDER BY id ASC");
            $this->sendJson(200, [
                'sucesso'     => true,
                'disciplinas' => $stmt->fetchAll()
            ]);
        } catch (Throwable $e) {
            $this->sendJson(500, [
                'sucesso' => false,
                'erro'    => 'Erro ao listar disciplinas: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Endpoint: POST /importar-apostilas
     * Importa automaticamente as questões extraídas das apostilas para o banco de dados
     * Caso o banco ainda não esteja inicializado, cria automaticamente a estrutura (auto-setup)
     */
    public function importarApostilas(): void {
        try {
            // 1. Verifica se a estrutura de tabelas existe; se não, inicializa com database.sql
            $tabelasExistem = false;
            try {
                $check = $this->pdo->query("SHOW TABLES LIKE 'questoes'")->fetch();
                $tabelasExistem = !empty($check);
            } catch (Throwable $e) {
                $tabelasExistem = false;
            }

            if (!$tabelasExistem) {
                $schemaFile = __DIR__ . '/database.sql';
                if (file_exists($schemaFile)) {
                    $schemaSql = file_get_contents($schemaFile);
                    $this->pdo->exec($schemaSql);
                }
            }

            // 2. Importa as questões das apostilas
            $sqlFile = __DIR__ . '/questoes_apostilas.sql';
            if (!file_exists($sqlFile)) {
                $this->sendJson(404, [
                    'sucesso' => false,
                    'erro'    => 'Arquivo questoes_apostilas.sql não encontrado. Execute o script extrator primeiro.'
                ]);
                return;
            }

            $sqlContent = file_get_contents($sqlFile);
            // Split compatível com CRLF (Windows) e LF (Linux/Mac)
            $rawStatements = preg_split('/;\s*(\r\n|\n|\r)/', $sqlContent);
            
            $statements = array_filter(
                array_map('trim', $rawStatements ?: []),
                fn($q) => !empty($q) && !str_starts_with($q, '--') && !str_starts_with(strtoupper($q), 'USE ')
            );

            $this->pdo->beginTransaction();
            $importadas = 0;

            foreach ($statements as $stmtSql) {
                $stmtSqlTrim = trim($stmtSql);
                if ($stmtSqlTrim !== '') {
                    $this->pdo->exec($stmtSqlTrim);
                    $importadas++;
                }
            }

            $this->pdo->commit();

            $totalNoBanco = (int)$this->pdo->query("SELECT COUNT(*) FROM questoes")->fetchColumn();

            $this->sendJson(200, [
                'sucesso'         => true,
                'mensagem'        => "{$importadas} questões das apostilas foram importadas com sucesso!",
                'importadas'      => $importadas,
                'total_no_banco'  => $totalNoBanco
            ]);
        } catch (Throwable $e) {
            if ($this->pdo->inTransaction()) {
                $this->pdo->rollBack();
            }
            $this->sendJson(500, [
                'sucesso' => false,
                'erro'    => 'Erro ao importar questões das apostilas: ' . $e->getMessage()
            ]);
        }
    }

    /**
     * Gera mensagem analítica personalizada sobre o desempenho do candidato
     */
    private function gerarFeedbackTexto(array $disciplinas, float $global): string {
        $destaquesPositivos = [];
        $pontosAtencao      = [];

        foreach ($disciplinas as $d) {
            if ($d['percentual'] >= 70.0) {
                $destaquesPositivos[] = "{$d['disciplina']} ({$d['percentual']}%)";
            } elseif ($d['percentual'] < 60.0) {
                $pontosAtencao[] = "{$d['disciplina']} ({$d['percentual']}%)";
            }
        }

        $msg = "";
        if ($global >= 80.0) {
            $msg .= "Desempenho excelente! Você está com pontuação muito competitiva para a nota de corte da PC PR.";
        } elseif ($global >= 65.0) {
            $msg .= "Bom aproveitamento geral! Com ajustes finos nas matérias certas, você garante sua vaga na PC PR.";
        } else {
            $msg .= "Atenção: aproveitamento geral abaixo da média esperada para a banca FGV. Intensifique o cronograma de revisão.";
        }

        if (!empty($destaquesPositivos) && !empty($pontosAtencao)) {
            $msg .= " Diagnóstico: Você foi muito bem em " . implode(', ', $destaquesPositivos) . 
                    ", mas precisa concentrar mais estudos em " . implode(', ', $pontosAtencao) . ".";
        } elseif (!empty($pontosAtencao)) {
            $msg .= " Diagnóstico: Redobre a atenção nas disciplinas: " . implode(', ', $pontosAtencao) . ".";
        } elseif (!empty($destaquesPositivos)) {
            $msg .= " Diagnóstico: Domínio sólido em todas as matérias avaliadas!";
        }

        return $msg;
    }

    /**
     * Formata segundos em formato legível HH:MM:SS
     */
    private function formatarTempo(int $segundos): string {
        $h = floor($segundos / 3600);
        $m = floor(($segundos % 3600) / 60);
        $s = $segundos % 60;
        return sprintf('%02dh %02dm %02ds', $h, $m, $s);
    }

    /**
     * Helper para resposta JSON
     */
    private function sendJson(int $statusCode, array $payload): void {
        http_response_code($statusCode);
        echo json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        exit;
    }
}

// ------------------------------------------------------------------------------
// ROTEAMENTO DINÂMICO DA API
// Suporta tanto rotas limpas (/gerar-prova) quanto query string (?action=gerar-prova)
// ------------------------------------------------------------------------------
$method = $_SERVER['REQUEST_METHOD'];

// Captura a rota requisitada
$uri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH) ?? '';
$action = $_GET['action'] ?? '';

// Normalização da rota
if ($action === '') {
    if (preg_match('#/(gerar-prova|salvar-resultado|historico|disciplinas|importar-apostilas)#', $uri, $matches)) {
        $action = $matches[1];
    }
}

$controller = new SimuladoController();

switch ($action) {
    case 'importar-apostilas':
        if ($method === 'POST' || $method === 'GET') {
            $controller->importarApostilas();
        } else {
            http_response_code(405);
            echo json_encode(['sucesso' => false, 'erro' => 'Método não permitido.']);
        }
        break;

    case 'gerar-prova':
        if ($method === 'GET') {
            $controller->gerarProva();
        } else {
            http_response_code(405);
            echo json_encode(['sucesso' => false, 'erro' => 'Método não permitido. Utilize GET.']);
        }
        break;

    case 'salvar-resultado':
        if ($method === 'POST') {
            $controller->salvarResultado();
        } else {
            http_response_code(405);
            echo json_encode(['sucesso' => false, 'erro' => 'Método não permitido. Utilize POST.']);
        }
        break;

    case 'historico':
        if ($method === 'GET') {
            $controller->listarHistorico();
        } else {
            http_response_code(405);
            echo json_encode(['sucesso' => false, 'erro' => 'Método não permitido. Utilize GET.']);
        }
        break;

    case 'disciplinas':
        if ($method === 'GET') {
            $controller->listarDisciplinas();
        } else {
            http_response_code(405);
            echo json_encode(['sucesso' => false, 'erro' => 'Método não permitido. Utilize GET.']);
        }
        break;

    default:
        http_response_code(200);
        echo json_encode([
            'nome'    => 'API Portal de Provas e Simulados PC PR 2026',
            'versao'  => '1.0.0',
            'status'  => 'Operacional',
            'rotas_disponiveis' => [
                'GET  api.php?action=gerar-prova'    => 'Gera o simulado de 100 questões com cotas FGV',
                'POST api.php?action=salvar-resultado' => 'Recebe as respostas, corrige e salva no histórico',
                'GET  api.php?action=historico'       => 'Lista os últimos simulados realizados',
                'GET  api.php?action=disciplinas'     => 'Lista as disciplinas e cotas do edital'
            ]
        ], JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT);
        break;
}
