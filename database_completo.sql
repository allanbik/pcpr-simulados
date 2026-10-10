-- ==============================================================================
-- PORTAL DE PROVAS E SIMULADOS - PC PR 2026 (BANCA FGV)
-- Agente de PolÃ­cia e Papiloscopista Policial
-- ==============================================================================
-- Script de CriaÃ§Ã£o e PopulaÃ§Ã£o do Banco de Dados MySQL
-- ==============================================================================

CREATE DATABASE IF NOT EXISTS `pcpr_simulados` 
DEFAULT CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;

USE `pcpr_simulados`;

-- ------------------------------------------------------------------------------
-- 1. TABELA DE DISCIPLINAS
-- ------------------------------------------------------------------------------
DROP TABLE IF EXISTS `simulados_realizados`;
DROP TABLE IF EXISTS `questoes`;
DROP TABLE IF EXISTS `disciplinas`;

CREATE TABLE `disciplinas` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `nome` VARCHAR(100) NOT NULL UNIQUE,
  `tipo` ENUM('Gerais', 'Especificos') NOT NULL,
  `peso_questoes` INT NOT NULL DEFAULT 10,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 2. TABELA DE QUESTÃ•ES
-- ------------------------------------------------------------------------------
CREATE TABLE `questoes` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `disciplina_id` INT NOT NULL,
  `enunciado` TEXT NOT NULL,
  `alt_a` TEXT NOT NULL,
  `alt_b` TEXT NOT NULL,
  `alt_c` TEXT NOT NULL,
  `alt_d` TEXT NOT NULL,
  `alt_e` TEXT NOT NULL,
  `gabarito` ENUM('A', 'B', 'C', 'D', 'E') NOT NULL,
  `comentario` TEXT NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_questoes_disciplinas` 
    FOREIGN KEY (`disciplina_id`) REFERENCES `disciplinas` (`id`) 
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX `idx_questoes_disciplina` (`disciplina_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------------------------
-- 3. TABELA DE HISTÃ“RICO DE SIMULADOS REALIZADOS
-- ------------------------------------------------------------------------------
CREATE TABLE `simulados_realizados` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `usuario_nome` VARCHAR(120) NOT NULL DEFAULT 'Candidato PC PR',
  `total_questoes` INT NOT NULL DEFAULT 100,
  `total_acertos` INT NOT NULL,
  `total_erros` INT NOT NULL,
  `percentual_acerto` DECIMAL(5,2) NOT NULL,
  `tempo_gasto_segundos` INT NOT NULL,
  `desempenho_disciplinas` JSON NOT NULL,
  `respostas_usuario` JSON NOT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_simulados_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ==============================================================================
-- 4. SEED: DISCIPLINAS COM COTAS OFICIAIS DO EDITAL PC PR 2026
-- Total: 100 questÃµes (35 Conhecimentos Gerais + 65 Conhecimentos EspecÃ­ficos)
-- ==============================================================================
INSERT INTO `disciplinas` (`id`, `nome`, `tipo`, `peso_questoes`) VALUES
(1, 'LÃ­ngua Portuguesa', 'Gerais', 15),
(2, 'RaciocÃ­nio LÃ³gico-MatemÃ¡tico', 'Gerais', 10),
(3, 'Realidade do PR', 'Gerais', 10),
(4, 'Direito Administrativo', 'Especificos', 10),
(5, 'Direito Constitucional', 'Especificos', 10),
(6, 'Direito Penal', 'Especificos', 15),
(7, 'Direito Processual Penal', 'Especificos', 15),
(8, 'LegislaÃ§Ã£o Penal Especial', 'Especificos', 15);


-- ==============================================================================
-- 5. SEED: BANCO DE QUESTÃ•ES NO PADRÃƒO BANCA FGV (PC PR)
-- 100 QuestÃµes completas com 5 alternativas e comentÃ¡rios fundamentados
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- DISCIPLINA 1: LÃNGUA PORTUGUESA (15 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(1, 
'Considere o perÃ­odo: "O Delegado de PolÃ­cia, ciente de que as investigaÃ§Ãµes preliminares demandavam sigilo absoluto, determinou que os autos permanecessem sob custÃ³dia rigorosa." A oraÃ§Ã£o "de que as investigaÃ§Ãµes preliminares demandavam sigilo absoluto" exerce a funÃ§Ã£o sintÃ¡tica de:',
'Objeto direto da forma verbal "determinou".',
'Complemento nominal do adjetivo "ciente".',
'Adjunto adnominal do substantivo "Delegado".',
'Objeto indireto da forma verbal "ciente".',
'Aposto explicativo do sujeito oracional.',
'B',
'A oraÃ§Ã£o subordinada substantiva completa o sentido do adjetivo "ciente" (nome), sendo introduzida pela preposiÃ§Ã£o "de" exigida pela regÃªncia nominal. Portanto, trata-se de uma OraÃ§Ã£o Subordinada Substantiva Complemento Nominal.'),

(1, 
'Assinale a opÃ§Ã£o em que o emprego do acento indicativo de crase atende rigorosamente Ã  norma-padrÃ£o da lÃ­ngua portuguesa:',
'O perito encaminhou o laudo Ã  uma comissÃ£o parlamentar de inquÃ©rito.',
'O suspeito prestou esclarecimentos Ã  PolÃ­cia Civil logo apÃ³s o ocorrido.',
'As diligÃªncias foram realizadas de ponta Ã  ponta da comarca de Curitiba.',
'O mandado de busca foi entregue Ã  ele durante o cumprimento da ordem.',
'Os agentes permaneceram Ã  postos aguardando autorizaÃ§Ã£o judicial.',
'B',
'Em "encaminhou o laudo Ã  PolÃ­cia Civil", o verbo encaminhar rege preposiÃ§Ã£o "a" e a expressÃ£o feminina "PolÃ­cia Civil" aceita artigo definido "a" (a + a = Ã ). Nas demais opÃ§Ãµes: antes de artigo indefinido (A), entre palavras repetidas (C), antes de pronome pessoal masculino (D) e antes de palavra masculina "postos" (E) nÃ£o ocorre crase.'),

(1, 
'No fragmento: "Embora os indÃ­cios fossem veementes, o MinistÃ©rio PÃºblico optou por requisitar novas diligÃªncias periciais", a conjunÃ§Ã£o subordinativa destacada estabelece relaÃ§Ã£o de sentido de:',
'Causa.',
'ConcessÃ£o.',
'CondiÃ§Ã£o.',
'Conformidade.',
'Proporcionalidade.',
'B',
'"Embora" Ã© conjunÃ§Ã£o subordinativa concessiva por excelÃªncia, introduzindo uma ideia que se opÃµe Ã  principal sem impedir a sua realizaÃ§Ã£o. Equivale a "conquanto", "ainda que", "posto que".'),

(1, 
'Observe a frase: "Havia muitos manifestantes na frente da delegacia geral, mas nenhum deles pretendia invadir o prÃ©dio pÃºblico." Se substituirmos a forma verbal "Havia" pelo verbo "Existir", mantendo o mesmo tempo e modo verbal, a redaÃ§Ã£o correta serÃ¡:',
'Existiam muitos manifestantes...',
'Existia muitos manifestantes...',
'Houveram muitos manifestantes...',
'Existiam-se muitos manifestantes...',
'Existisse muitos manifestantes...',
'A',
'O verbo "haver" no sentido de existir Ã© impessoal e fica na 3Âª pessoa do singular. PorÃ©m, o verbo "existir" Ã© pessoal e flexiona normalmente com o sujeito ("muitos manifestantes existiam" -> "Existiam muitos manifestantes").'),

(1, 
'Assinale a alternativa em que a palavra destacada foi grafada de acordo com o Novo Acordo OrtogrÃ¡fico vigente:',
'O papiloscopista utilizou um micro-ondas para aquecer o reagente quÃ­mico.',
'O investigado mantinha um comportamento anti-social durante as oitivas.',
'A autoridade policial solicitou a auto-defesa preliminar do indiciado.',
'O policial civil agiu com extrema auto-estima durante a operaÃ§Ã£o.',
'Os agentes precisavam de um pÃ¡ra-raios instalado no prÃ©dio da delegacia.',
'A',
'Pelo Acordo OrtogrÃ¡fico, usa-se hÃ­fen quando o segundo elemento comeÃ§a com a mesma vogal que termina o prefixo ("micro-ondas"). Nas demais: "antissocial" (duplica o s), "autodefesa" (junto sem hÃ­fen), "autoestima" (vogais diferentes juntam-se sem hÃ­fen), "para-raios" perdeu o acento diferencial ("para-raios").'),

(1, 
'Analise a concordÃ¢ncia na seguinte oraÃ§Ã£o: "Seguem ________ aos autos as fotografias e o laudo pericial, pois sÃ£o necessÃ¡rias providÃªncias ________ para a elucidaÃ§Ã£o do delito." As lacunas sÃ£o preenchidas corretamente por:',
'anexo - urgentes',
'anexas - urgente',
'anexos - urgentes',
'anexo - urgente',
'anexas - urgentes',
'C',
'A palavra "anexo" concorda em gÃªnero e nÃºmero com os substantivos a que se refere ("as fotografias e o laudo" = masculino plural -> anexos). "ProvidÃªncias" Ã© substantivo feminino plural, logo o adjetivo concorda em "urgentes".'),

(1, 
'A ambiguidade Ã© um vÃ­cio de linguagem frequentemente explorado em provas da FGV. Assinale a frase que apresenta dupla possibilidade de interpretaÃ§Ã£o (ambiguidade):',
'O delegado solicitou com urgÃªncia o depoimento do suspeito.',
'A perÃ­cia tÃ©cnica concluiu a anÃ¡lise do material apreendido na residÃªncia.',
'O investigador encontrou a vÃ­tima em sua sala de trabalho.',
'Os policiais civis cumpriram o mandado com serenidade e presteza.',
'A testemunha reconheceu prontamente o autor do furto na delegacia.',
'C',
'Em "O investigador encontrou a vÃ­tima em sua sala de trabalho", o pronome possessivo "sua" gera ambiguidade, pois a sala pode ser do investigador ou da vÃ­tima.'),

(1, 
'Na passagem: "A sociedade paranaense nÃ£o apenas exige seguranÃ§a, mas tambÃ©m cobra transparÃªncia nas aÃ§Ãµes policiais", os conectivos em destaque estabelecem nexo coordenado de:',
'AdiÃ§Ã£o enfÃ¡tica.',
'OposiÃ§Ã£o contrastiva.',
'ConclusÃ£o lÃ³gica.',
'AlternÃ¢ncia conjuntiva.',
'ExplicaÃ§Ã£o justificativa.',
'A',
'A estrutura correlativa "nÃ£o apenas... mas tambÃ©m" expressa relaÃ§Ã£o sintÃ¡tico-semÃ¢ntica de adiÃ§Ã£o com Ãªnfase (soma de duas ideias complementares).'),

(1, 
'Quanto Ã  regÃªncia verbal, assinale a opÃ§Ã£o que estÃ¡ em estrita conformidade com a norma culta:',
'O novo agente policial aspira ao cargo de chefia do departamento de homicÃ­dios.',
'A autoridade policial visava o bem-estar de toda a equipe de plantÃ£o.',
'Os papiloscopistas obedeceram o protocolo tÃ©cnico estabelecido pelo instituto.',
'O escrivÃ£o de polÃ­cia esqueceu do documento sobre o balcÃ£o da repartiÃ§Ã£o.',
'O delegado preferiu abrir novo inquÃ©rito do que arquivar os autos.',
'A',
'O verbo "aspirar" no sentido de pretender/almejar Ã© transitivo indireto e exige a preposiÃ§Ã£o "a" ("aspirar ao cargo"). "Visar" com sentido de almejar rege "a"; "obedecer" rege "a"; "esquecer" sem pronome nÃ£o aceita preposiÃ§Ã£o ("esqueceu o documento"); "preferir" rege "a" e nÃ£o "do que".'),

(1, 
'Identifique a oraÃ§Ã£o com pontuaÃ§Ã£o inteiramente correta:',
'Em Londrina, os policiais civis apreenderam ontem, duas toneladas de entorpecentes.',
'Em Londrina os policiais civis, apreenderam ontem duas toneladas de entorpecentes.',
'Em Londrina, os policiais civis apreenderam, ontem, duas toneladas de entorpecentes.',
'Em Londrina os policiais civis apreenderam ontem duas toneladas, de entorpecentes.',
'Em Londrina, os policiais civis, apreenderam ontem, duas toneladas de entorpecentes.',
'C',
'O adjunto adverbial de lugar deslocado ("Em Londrina") deve vir isolado por vÃ­rgula, e o adjunto adverbial de tempo intercalado ("ontem") pode figurar devidamente entre vÃ­rgulas. Nunca se separa sujeito do verbo com vÃ­rgula Ãºnica.'),

(1, 
'Assinale a alternativa em que a transposiÃ§Ã£o da voz ativa para a passiva analÃ­tica foi realizada de maneira correta: "Os peritos do Instituto de IdentificaÃ§Ã£o analisarÃ£o as impressÃµes digitais colhidas no local."',
'As impressÃµes digitais colhidas no local seriam analisadas pelos peritos do Instituto de IdentificaÃ§Ã£o.',
'As impressÃµes digitais colhidas no local foram analisadas pelos peritos do Instituto de IdentificaÃ§Ã£o.',
'As impressÃµes digitais colhidas no local serÃ£o analisadas pelos peritos do Instituto de IdentificaÃ§Ã£o.',
'As impressÃµes digitais colhidas no local tinham sido analisadas pelos peritos do Instituto de IdentificaÃ§Ã£o.',
'As impressÃµes digitais colhidas no local estÃ£o sendo analisadas pelos peritos do Instituto de IdentificaÃ§Ã£o.',
'C',
'O verbo ativo "analisarÃ£o" estÃ¡ no Futuro do Presente do Indicativo. A voz passiva analÃ­tica correspondente exige o verbo auxiliar "ser" no mesmo tempo: "serÃ£o analisadas".'),

(1, 
'Em "A decisÃ£o do magistrado foi sobremaneira elogiada pela comunidade jurÃ­dica", o vocÃ¡bulo sublinhado expressa circunstÃ¢ncia de:',
'Modo atenuado.',
'Intensidade.',
'Tempo pretÃ©rito.',
'Instrumento decisÃ³rio.',
'DÃºvida razoÃ¡vel.',
'B',
'"Sobremaneira" Ã© advÃ©rbio de intensidade, sinÃ´nimo de "em alto grau", "excessivamente", "muito", "extremamente".'),

(1, 
'Considere o trecho: "O policial agiu com cautela, pois a situaÃ§Ã£o era de extremo risco." O termo "pois" introduz uma oraÃ§Ã£o coordenada:',
'Conclusiva.',
'Explicativa.',
'Adversativa.',
'Alternativa.',
'Aditiva.',
'B',
'O "pois" anteposto ao verbo introduz uma justificativa ou explicaÃ§Ã£o para o fato expresso na oraÃ§Ã£o anterior ("O policial agiu com cautela"), configurando oraÃ§Ã£o coordenada sindÃ©tica explicativa.'),

(1, 
'Assinale a frase que NÃƒO contÃ©m erro de colocaÃ§Ã£o pronominal segundo a norma gramatical padrÃ£o:',
'Nunca disseram-me que o plantÃ£o seria prorrogado atÃ© o amanhecer.',
'O delegado nÃ£o se manifestou antes da conclusÃ£o do relatÃ³rio final.',
'Em tratando-se de crimes contra a vida, a resposta estatal deve ser cÃ©lere.',
'Me entregaram os autos do inquÃ©rito na manhÃ£ desta terÃ§a-feira.',
'Os agentes tinham deslocado-se para a cidade de Ponta Grossa.',
'B',
'A palavra de sentido negativo "nÃ£o" atrai obrigatoriamente a prÃ³clise ("nÃ£o se manifestou"). "Nunca" tambÃ©m atrai prÃ³clise (erro em A); "Em se tratando de" Ã© a forma correta com gerÃºndio precedido de preposiÃ§Ã£o "em" (erro em C); nÃ£o se inicia frase com pronome oblÃ­quo Ã¡tono (erro em D); nÃ£o cabe Ãªnclise ao particÃ­pio (erro em E).'),

(1, 
'No tÃ­tulo de uma notÃ­cia hipotÃ©tica: "InvestigaÃ§Ãµes sobre quadrilha especializada revelam elo com lavagem de dinheiro", a palavra "elo" foi empregada em sentido conotativo com o significado de:',
'Argola metÃ¡lica de correntes.',
'ConexÃ£o ou vÃ­nculo probatÃ³rio.',
'Instrumento de contenÃ§Ã£o fÃ­sica.',
'Dispositivo de telecomunicaÃ§Ã£o.',
'SubdivisÃ£o de uma carceragem.',
'B',
'Em sentido figurado (conotativo), a palavra "elo" representa uma conexÃ£o, ligaÃ§Ã£o, vÃ­nculo ou ponto de contato entre dois fatos ou elementos de uma apuraÃ§Ã£o policial.');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 2: RACIOCÃNIO LÃ“GICO-MATEMÃTICO (10 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(2, 
'Considere a proposiÃ§Ã£o condicional: "Se o suspeito mente no interrogatÃ³rio, entÃ£o o delegado requisita a perÃ­cia papiloscÃ³pica." Uma proposiÃ§Ã£o logicamente equivalente a essa condicional Ã©:',
'Se o delegado requisita a perÃ­cia papiloscÃ³pica, entÃ£o o suspeito mente no interrogatÃ³rio.',
'Se o suspeito nÃ£o mente no interrogatÃ³rio, entÃ£o o delegado nÃ£o requisita a perÃ­cia papiloscÃ³pica.',
'Se o delegado nÃ£o requisita a perÃ­cia papiloscÃ³pica, entÃ£o o suspeito nÃ£o mente no interrogatÃ³rio.',
'O suspeito mente no interrogatÃ³rio e o delegado nÃ£o requisita a perÃ­cia papiloscÃ³pica.',
'O suspeito nÃ£o mente no interrogatÃ³rio ou o delegado nÃ£o requisita a perÃ­cia papiloscÃ³pica.',
'C',
'Pela regra da contrapositiva (equivalÃªncia de P -> Q), temos ~Q -> ~P. Logo, "Se o delegado NÃƒO requisita a perÃ­cia, entÃ£o o suspeito NÃƒO mente no interrogatÃ³rio".'),

(2, 
'A negaÃ§Ã£o lÃ³gica da proposiÃ§Ã£o "Todo policial civil Ã© dedicado e nenhum agente falta ao plantÃ£o" Ã©:',
'Nenhum policial civil Ã© dedicado e todo agente falta ao plantÃ£o.',
'Pelo menos um policial civil nÃ£o Ã© dedicado ou pelo menos um agente falta ao plantÃ£o.',
'Todo policial civil nÃ£o Ã© dedicado ou algum agente nÃ£o falta ao plantÃ£o.',
'Algum policial civil nÃ£o Ã© dedicado e todo agente falta ao plantÃ£o.',
'Nenhum policial civil falta ao plantÃ£o ou todo agente Ã© dedicado.',
'B',
'Para negar uma conjunÃ§Ã£o (P e Q), utiliza-se a Lei de De Morgan: ~(P e Q) = ~P ou ~Q. A negaÃ§Ã£o de "Todo A Ã© B" Ã© "Pelo menos um A nÃ£o Ã© B" (ou algum). A negaÃ§Ã£o de "Nenhum C Ã© D" Ã© "Pelo menos um C Ã© D" (algum agente falta ao plantÃ£o). Portanto: "Pelo menos um policial civil nÃ£o Ã© dedicado OU pelo menos um agente falta ao plantÃ£o".'),

(2, 
'Em uma delegacia de Curitiba trabalham 8 agentes e 6 escrivÃ£es. Para realizar uma operaÃ§Ã£o especial sigilosa, o delegado precisa formar uma comissÃ£o de 3 agentes e 2 escrivÃ£es. O nÃºmero total de comissÃµes distintas que podem ser formadas Ã©:',
'840',
'560',
'1.120',
'420',
'720',
'A',
'CombinaÃ§Ã£o simples de agentes: C(8, 3) = (8*7*6)/(3*2*1) = 56. CombinaÃ§Ã£o simples de escrivÃ£es: C(6, 2) = (6*5)/(2*1) = 15. Pelo princÃ­pio fundamental da contagem, multiplicam-se as possibilidades: 56 * 15 = 840 comissÃµes distintas.'),

(2, 
'Num grupo de 100 policiais civis do ParanÃ¡, constatou-se que 65 sÃ£o habilitados para dirigir viaturas operacionais blindadas, 45 possuem certificado de tiro de precisÃ£o (sniper) e 20 possuem ambas as qualificaÃ§Ãµes. Selecionando-se aleatoriamente um desses 100 policiais, qual Ã© a probabilidade de ele NÃƒO possuir nenhuma dessas duas qualificaÃ§Ãµes?',
'10%',
'15%',
'20%',
'25%',
'30%',
'A',
'UniÃ£o dos conjuntos: N(A U B) = N(A) + N(B) - N(A âˆ© B) = 65 + 45 - 20 = 90 policiais possuem pelo menos uma qualificaÃ§Ã£o. O nÃºmero de policiais sem nenhuma das duas qualificaÃ§Ãµes Ã© 100 - 90 = 10. A probabilidade Ã© de 10/100 = 10%.'),

(2, 
'Considere a sequÃªncia lÃ³gica de nÃºmeros inteiros: 3, 7, 15, 31, 63, X... O valor do prÃ³ximo termo X Ã© igual a:',
'127',
'125',
'126',
'95',
'129',
'A',
'O padrÃ£o da sequÃªncia pode ser obtido por 2*n + 1 (ou somando potÃªncias de 2: +4, +8, +16, +32, +64). Logo: 63 * 2 + 1 = 127 (ou 63 + 64 = 127).'),

(2, 
'Em um cofre de evidÃªncias da polÃ­cia hÃ¡ 5 envelopes pardos, 7 envelopes brancos e 8 envelopes amarelos. Um perito precisa retirar envelopes no escuro, um a um, sem olhar. Quantos envelopes ele deve retirar, no mÃ­nimo, para ter certeza absoluta de que retirou pelo menos um envelope de cada cor?',
'13',
'15',
'16',
'18',
'20',
'C',
'Pelo PrincÃ­pio da Casa dos Pombos (pior cenÃ¡rio possÃ­vel): o perito pode retirar primeiramente todos os 8 envelopes amarelos e em seguida todos os 7 envelopes brancos (8 + 7 = 15 envelopes) sem pegar nenhum pardo. Ao retirar mais 1 envelope (o 16Âº), ele serÃ¡ obrigatoriamente pardo, garantindo pelo menos um de cada cor: 8 + 7 + 1 = 16.'),

(2, 
'Se Ã© verdade que "Todos os investigadores sÃ£o astutos" e "Alguns motoristas nÃ£o sÃ£o astutos", entÃ£o conclui-se necessariamente que:',
'Nenhum motorista Ã© investigador.',
'Alguns motoristas nÃ£o sÃ£o investigadores.',
'Todos os astutos sÃ£o motoristas.',
'Alguns investigadores nÃ£o sÃ£o astutos.',
'Todo motorista Ã© astuto.',
'B',
'Se todo investigador pertence ao conjunto dos astutos, qualquer indivÃ­duo que NÃƒO seja astuto estÃ¡ necessariamente fora do conjunto dos investigadores. Como "alguns motoristas nÃ£o sÃ£o astutos", esses motoristas especÃ­ficos certamente nÃ£o sÃ£o investigadores.'),

(2, 
'TrÃªs agentes policiais, Carlos, Daniel e Eduardo, prestaram concurso para cidades diferentes: Londrina, MaringÃ¡ e Cascavel, nÃ£o necessariamente nessa ordem. Sabe-se que: I. Carlos nÃ£o foi lotado em Londrina; II. Quem foi para Cascavel nÃ£o Ã© Daniel; III. Eduardo foi lotado em MaringÃ¡. Ã‰ correto afirmar que:',
'Carlos foi para Londrina e Daniel foi para Cascavel.',
'Carlos foi para Cascavel e Daniel foi para Londrina.',
'Carlos foi para MaringÃ¡ e Daniel foi para Cascavel.',
'Daniel foi para MaringÃ¡ e Eduardo foi para Londrina.',
'Eduardo foi para Cascavel e Carlos foi para Londrina.',
'B',
'Sabemos diretamente que Eduardo = MaringÃ¡. Restam Londrina e Cascavel para Carlos e Daniel. Como Daniel nÃ£o foi para Cascavel (premissa II), Daniel foi para Londrina. Resta para Carlos ir para Cascavel (o que Ã© compatÃ­vel com a premissa I). Portanto, Carlos = Cascavel e Daniel = Londrina.'),

(2, 
'Um carro de perÃ­cia percorre uma distÃ¢ncia de 240 km entre duas delegacias regionais com velocidade mÃ©dia de 80 km/h. No retorno pelo mesmo trajeto, devido a fortes chuvas na serra, sua velocidade mÃ©dia foi de 60 km/h. A velocidade mÃ©dia do veÃ­culo considerando o trajeto completo de ida e volta foi de aproximadamente:',
'70,0 km/h',
'68,6 km/h',
'67,5 km/h',
'72,0 km/h',
'65,0 km/h',
'B',
'DistÃ¢ncia total = 240 + 240 = 480 km. Tempo de ida = 240/80 = 3h. Tempo de volta = 240/60 = 4h. Tempo total = 3 + 4 = 7h. Velocidade mÃ©dia global = 480 / 7 â‰ˆ 68,57 km/h (mÃ©dia harmÃ´nica das velocidades).'),

(2, 
'A proposiÃ§Ã£o condicional "Se nÃ£o chove em Curitiba, entÃ£o o trÃ¡fego flui normalmente" Ã© dada como FALSA. A partir dessa informaÃ§Ã£o, Ã© correto concluir que:',
'Chove em Curitiba e o trÃ¡fego flui normalmente.',
'NÃ£o chove em Curitiba e o trÃ¡fego nÃ£o flui normalmente.',
'Chove em Curitiba e o trÃ¡fego nÃ£o flui normalmente.',
'NÃ£o chove em Curitiba e o trÃ¡fego flui normalmente.',
'Tanto a premissa quanto a conclusÃ£o sÃ£o falsas.',
'B',
'Na tabela-verdade da condicional (P -> Q), a proposiÃ§Ã£o sÃ³ Ã© FALSA em uma Ãºnica situaÃ§Ã£o: quando a primeira parte (antecedente) Ã© VERDADEIRA e a segunda (consequente) Ã© FALSA. Logo, "NÃ£o chove em Curitiba" Ã© Verdadeiro e "o trÃ¡fego flui normalmente" Ã© Falso (ou seja, o trÃ¡fego nÃ£o flui normalmente).');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 3: REALIDADE DO PARANÃ (10 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(3, 
'A emancipaÃ§Ã£o polÃ­tica da ProvÃ­ncia do ParanÃ¡, que marcou o seu desmembramento definitivo da ProvÃ­ncia de SÃ£o Paulo, ocorreu no contexto imperial do Segundo Reinado no ano de:',
'1822',
'1853',
'1889',
'1930',
'1808',
'B',
'A criaÃ§Ã£o da ProvÃ­ncia do ParanÃ¡ deu-se por meio da Lei Imperial nÂº 704 de 29 de agosto de 1853, com a instalaÃ§Ã£o oficial da nova provÃ­ncia e posse de seu primeiro presidente, Zacarias de GÃ³es e Vasconcellos, em 19 de dezembro de 1853.'),

(3, 
'Um dos conflitos socioeconÃ´micos e agrÃ¡rios mais expressivos da histÃ³ria do ParanÃ¡ no sÃ©culo XX ocorreu na regiÃ£o Sudoeste do Estado no ano de 1957, motivado por litÃ­gios entre companhias de terras e pequenos agricultores familiares. Esse episÃ³dio Ã© historicamente denominado:',
'Guerra dos Farrapos.',
'Revolta dos Posseiros.',
'Guerra de Canudos.',
'RevoluÃ§Ã£o Federalista.',
'Coluna Prestes.',
'B',
'A Revolta dos Posseiros de 1957 foi uma insurreiÃ§Ã£o de pequenos colonos e posseiros no Sudoeste do ParanÃ¡ contra companhias colonizadoras grileiras, culminando na posterior intervenÃ§Ã£o do governo federal e regularizaÃ§Ã£o das terras pelo GETSOP.'),

(3, 
'O conflito bÃ©lico de carÃ¡ter messiÃ¢nico e fronteiriÃ§o ocorrido entre 1912 e 1916 envolvendo disputa territorial entre os estados do ParanÃ¡ e Santa Catarina, alÃ©m de interesses da ferrovia Brazil Railway Company, denominou-se:',
'Guerra da Cisplatina.',
'Guerra do Contestado.',
'RevoluÃ§Ã£o Praieira.',
'Guerra dos Emboabas.',
'Balaiada.',
'B',
'A Guerra do Contestado (1912-1916) ocorreu na regiÃ£o fronteiriÃ§a disputada entre ParanÃ¡ e Santa Catarina, congregando milhares de camponeses seguidores do monge JoÃ£o Maria contra as tropas federais e estaduais e a ferrovia.'),

(3, 
'Historicamente, os ciclos econÃ´micos moldaram a ocupaÃ§Ã£o territorial do ParanÃ¡. No sÃ©culo XIX e inÃ­cio do sÃ©culo XX, o produto extrativo e agrÃ­cola que impulsionou o desenvolvimento de Curitiba, do litoral e a construÃ§Ã£o da Estrada de Ferro Curitiba-ParanaguÃ¡ foi:',
'O ciclo do cafÃ©.',
'O ciclo da erva-mate.',
'O ciclo do ouro de lavra.',
'O ciclo da cana-de-aÃ§Ãºcar.',
'O ciclo do lÃ¡tex da borracha.',
'B',
'A economia da erva-mate foi a grande propulsora da autonomia econÃ´mica e da modernizaÃ§Ã£o urbana paranaense, motivando os engenheiros AntÃ´nio e AndrÃ© RebouÃ§as a projetarem a ousada Ferrovia Curitiba-ParanaguÃ¡ para escoamento no porto.'),

(3, 
'Em relaÃ§Ã£o Ã  geomorfologia e ao relevo paranaense, o Estado Ã© tradicionalmente subdividido em compartimentos topogrÃ¡ficos conhecidos como Planaltos Paranaenses. Assinale a alternativa que indica corretamente a sequÃªncia altimÃ©trica do Leste para o Oeste apÃ³s a Serra do Mar:',
'Primeiro Planalto (Curitiba), Segundo Planalto (Ponta Grossa) e Terceiro Planalto (Guarapuava/Norte/Oeste).',
'Planalto Central, Planalto Meridional e DepressÃ£o Pantaneira.',
'Planalto das AraucÃ¡rias, Planalto AtlÃ¢ntico e Planalto do IguaÃ§u.',
'Terceiro Planalto (Curitiba), Segundo Planalto (Londrina) e Primeiro Planalto (Foz do IguaÃ§u).',
'PlanÃ­cie LitorÃ¢nea, Chapada Diamantina e Planalto da Borborema.',
'A',
'O relevo do ParanÃ¡, segundo a classificaÃ§Ã£o clÃ¡ssica de Reinhard Maack, estrutura-se a partir do Litoral/Serra do Mar em: Primeiro Planalto Paranaense (Curitiba), Segundo Planalto Paranaense (Campos Gerais/Ponta Grossa) e Terceiro Planalto Paranaense (Arenito-BasÃ¡ltico, que abrange Guarapuava, MaringÃ¡, Londrina, Cascavel e Foz).'),

(3, 
'O principal porto do Estado do ParanÃ¡, situado estrategicamente na baÃ­a de mesmo nome e considerado um dos maiores e mais eficientes corredores de exportaÃ§Ã£o de grÃ£os e contÃªineres da AmÃ©rica Latina, Ã© o Porto de:',
'Antonina.',
'ParanaguÃ¡.',
'Santos.',
'ItajaÃ­.',
'SÃ£o Francisco do Sul.',
'B',
'O Porto de ParanaguÃ¡ Ã© a principal infraestrutura portuÃ¡ria e logÃ­stica do ParanÃ¡ e um dos mais importantes complexos portuÃ¡rios do mundo no escoamento de soja, milho, farelo, fertilizantes e cargas conteinerizadas.'),

(3, 
'A bacia hidrogrÃ¡fica mais importante localizada no interior do territÃ³rio paranaense, que nasce na confluÃªncia dos rios Atuba e IraÃ­ na RegiÃ£o Metropolitana de Curitiba e desÃ¡gua na fronteira internacional com a Argentina formando famosas quedas d''Ã¡gua mundiais, Ã© a bacia do Rio:',
'TietÃª.',
'IguaÃ§u.',
'Tibagi.',
'IvaÃ­.',
'Paranapanema.',
'B',
'O Rio IguaÃ§u nasce prÃ³ximo a Curitiba, corta o Estado no sentido leste-oeste e desÃ¡gua no Rio ParanÃ¡, onde suas cataratas formam o Parque Nacional do IguaÃ§u em Foz do IguaÃ§u.'),

(3, 
'Sobre a colonizaÃ§Ã£o do Norte do ParanÃ¡ na primeira metade do sÃ©culo XX, Ã© correto afirmar que o avanÃ§o da fronteira agrÃ­cola foi fortemente impulsionado pela expansÃ£o da cultura do:',
'Trigo e do cacau no vale do Ribeira.',
'CafÃ© em solos de "terra roxa" derivados de rochas basÃ¡lticas.',
'Tabaco com mÃ£o de obra aÃ§oriana na costa litorÃ¢nea.',
'Arroz irrigado nas margens do Rio Piquiri.',
'AlgodÃ£o herbÃ¡ceo patrocinado por companhias britÃ¢nicas de mineraÃ§Ã£o.',
'B',
'O Norte Paranaense ("Norte Pioneiro" e "Norte Novo/NovÃ­ssimo") viveu uma intensa corrida demogrÃ¡fica e desenvolvimento urbano (Londrina, MaringÃ¡) decorrente da cafeicultura sobre os fÃ©rteis solos de terra roxa (latossolos basÃ¡lticos).'),

(3, 
'A usina hidrelÃ©trica binacional situada no Rio ParanÃ¡, construÃ­da conjuntamente pelo Brasil e pelo Paraguai na cidade de Foz do IguaÃ§u, sendo uma das maiores geradoras de energia limpa e renovÃ¡vel do planeta, Ã© a Usina HidrelÃ©trica de:',
'Belo Monte.',
'Itaipu.',
'TucuruÃ­.',
'Jirau.',
'Santo AntÃ´nio.',
'B',
'Itaipu Binacional Ã© a colossal usina hidrelÃ©trica situada na fronteira entre Brasil (Foz do IguaÃ§u/PR) e Paraguai (Hernandarias), marco da geopolÃ­tica e da matriz energÃ©tica nacional.'),

(3, 
'A Lei OrgÃ¢nica da PolÃ­cia Civil do Estado do ParanÃ¡ institui princÃ­pios e normas regimentais. No que tange Ã  atuaÃ§Ã£o e circunscriÃ§Ã£o policial em territÃ³rio paranaense, a instituiÃ§Ã£o Ã© administrativamente vinculada Ã :',
'Secretaria de Estado da SeguranÃ§a PÃºblica (SESP/PR).',
'Procuradoria-Geral do Estado do ParanÃ¡ (PGE/PR).',
'Secretaria de Estado da Fazenda (SEFA/PR).',
'SuperintendÃªncia do MinistÃ©rio da JustiÃ§a no ParanÃ¡.',
'Casa Civil do Gabinete do Governador.',
'A',
'A PolÃ­cia Civil do ParanÃ¡ (PCPR) Ã© Ã³rgÃ£o permanente do Poder Executivo subordinado diretamente Ã  Secretaria de Estado da SeguranÃ§a PÃºblica do ParanÃ¡ (SESP/PR).');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 4: DIREITO ADMINISTRATIVO (10 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(4, 
'Acerca dos atos administrativos, considere a situaÃ§Ã£o em que um Delegado de PolÃ­cia constata um vÃ­cio de competÃªncia em um ato praticado que nÃ£o envolva competÃªncia exclusiva por lei. De acordo com a doutrina administrativa e a jurisprudÃªncia dominante, tal ato:',
'Deve ser compulsoriamente revogado, produzindo efeitos ex nunc.',
'Ã‰ absolutamente nulo e insanÃ¡vel, nÃ£o admitindo convalidaÃ§Ã£o sob nenhuma hipÃ³tese.',
'Pode ser convalidado pela autoridade competente, desde que nÃ£o acarrete lesÃ£o ao interesse pÃºblico nem prejuÃ­zo a terceiros.',
'Extingue-se por caducidade no prazo decadencial de noventa dias.',
'SÃ³ pode ser desconstituÃ­do mediante prÃ©via autorizaÃ§Ã£o judicial expressa.',
'C',
'Os vÃ­cios sanÃ¡veis (como defeito de competÃªncia quando nÃ£o exclusiva e vÃ­cio de forma quando nÃ£o essencial Ã  validade do ato) admitem a convalidaÃ§Ã£o, dotada de efeitos retroativos (ex tunc), caso nÃ£o tragam lesÃ£o ao interesse pÃºblico nem prejuÃ­zo a terceiros (art. 55 da Lei 9.784/99).'),

(4, 
'No tocante ao Poder de PolÃ­cia da AdministraÃ§Ã£o PÃºblica, Ã© correto afirmar que sÃ£o atributos clÃ¡ssicos desse poder:',
'Exclusividade, gratuidade e imperatividade.',
'Discricionariedade, autoexecutoriedade e coercibilidade.',
'Legalidade estrita, presunÃ§Ã£o de culpa e indelegabilidade irrestrita.',
'VinculaÃ§Ã£o absoluta, publicidade mitigada e imediatidade.',
'Irrevogabilidade, intangibilidade e retroatividade tÃ¡cita.',
'B',
'A doutrina administrativista clÃ¡ssica (Hely Lopes Meirelles, Maria Sylvia Di Pietro) elenca como atributos inerentes ao poder de polÃ­cia: a discricionariedade (margem de atuaÃ§Ã£o dentro da lei), a autoexecutoriedade (execuÃ§Ã£o direta sem necessidade de chancela judicial prÃ©via) e a coercibilidade (imposiÃ§Ã£o forÃ§ada da medida coercitiva).'),

(4, 
'Um cidadÃ£o sofreu graves lesÃµes corporais ao ser atingido por uma viatura da PolÃ­cia Civil que ultrapassou o sinal vermelho durante uma perseguiÃ§Ã£o policial de rotina, sem acionamento de sirene luminosa/sonora. Segundo o art. 37, Â§ 6Âº, da CF/1988 e a jurisprudÃªncia pacÃ­fica do STF, a responsabilidade civil do Estado no caso concreto Ã©:',
'Subjetiva com presunÃ§Ã£o relativa de culpa, cabendo ao particular comprovar o dolo do motorista.',
'Objetiva, sob a modalidade do risco administrativo, ensejando dever de indenizar independentemente da demonstraÃ§Ã£o de culpa individual do policial.',
'Inexistente, haja vista o estrito cumprimento do dever legal na perseguiÃ§Ã£o de infratores da lei.',
'Objetiva com base na teoria do risco integral, vedando qualquer alegaÃ§Ã£o de culpa da vÃ­tima ou forÃ§a maior.',
'SubsidiÃ¡ria, de modo que o cidadÃ£o lesado deve ajuizar a aÃ§Ã£o primeiramente contra a pessoa fÃ­sica do policial condutor.',
'B',
'As pessoas jurÃ­dicas de direito pÃºblico respondem objetivamente pelos danos que seus agentes causarem a terceiros nessa qualidade (CF, art. 37, Â§ 6Âº), sob a teoria do risco administrativo. NÃ£o hÃ¡ necessidade de provar culpa do agente pÃºblico, e o STF pacificou no Tema 940 que a aÃ§Ã£o indenizatÃ³ria deve ser proposta diretamente contra o Estado, e nÃ£o contra o agente pÃºblico diretamente.'),

(4, 
'De acordo com as recentes alteraÃ§Ãµes promovidas pela Lei nÂº 14.230/2021 na Lei de Improbidade Administrativa (Lei nÂº 8.429/1992), para a configuraÃ§Ã£o de qualquer ato de improbidade administrativa exige-se, na esfera subjetiva:',
'A presenÃ§a de culpa grave ou inescusÃ¡vel do agente estatal.',
'A comprovaÃ§Ã£o de dolo genÃ©rico de violar norma regulamentar.',
'A comprovaÃ§Ã£o do dolo especÃ­fico, consubstanciado na vontade livre e consciente de alcanÃ§ar o resultado ilÃ­cito tipificado em lei.',
'A presunÃ§Ã£o iuris tantum de mÃ¡-fÃ© pela simples prÃ¡tica da conduta descrita.',
'A ocorrÃªncia concomitante de dano material ao erÃ¡rio e enriquecimento ilÃ­cito do agente.',
'C',
'A Lei 14.230/2021 revogou expressamente as modalidades culposas de improbidade administrativa, exigindo em todos os atos (arts. 9Âº, 10 e 11) a presenÃ§a do dolo especÃ­fico, demonstrado pela vontade livre e consciente de alcanÃ§ar o resultado ilÃ­cito.'),

(4, 
'O princÃ­pio da AdministraÃ§Ã£o PÃºblica que veda a promoÃ§Ã£o pessoal de autoridades ou servidores em publicidades, obras e programas de governo, expressamente previsto no art. 37, Â§ 1Âº, da ConstituiÃ§Ã£o da RepÃºblica, decorre diretamente do princÃ­pio da:',
'EficiÃªncia.',
'Impessoalidade.',
'Moralidade estrita.',
'Publicidade institucional.',
'Legalidade orÃ§amentÃ¡ria.',
'B',
'O princÃ­pio da impessoalidade manifesta-se tambÃ©m na vedaÃ§Ã£o de promoÃ§Ã£o pessoal de agentes e mandatÃ¡rios pÃºblicos em atos governamentais, assegurando que a atuaÃ§Ã£o pertenÃ§a ao Ã³rgÃ£o e Ã  AdministraÃ§Ã£o, e nÃ£o Ã  pessoa fÃ­sica do administrador.'),

(4, 
'Sobre os bens pÃºblicos, assinale a assertiva juridicamente correta:',
'Os bens pÃºblicos de uso comum do povo podem ser adquiridos por particular mediante usucapiÃ£o ordinÃ¡rio.',
'Os prÃ©dios ocupados por Delegacias de PolÃ­cia Civil sÃ£o considerados bens pÃºblicos de uso especial e sÃ£o inalienÃ¡veis enquanto mantiverem essa afetaÃ§Ã£o.',
'Os bens dominicais nÃ£o integram o patrimÃ´nio pÃºblico disponÃ­vel do Estado.',
'Qualquer bem pÃºblico Ã© passÃ­vel de penhora judicial para garantia de dÃ­vidas fazendÃ¡rias.',
'Os bens dominicais sÃ£o imprescritÃ­veis, mas podem sofrer gravame de hipoteca comercial.',
'B',
'Os edifÃ­cios onde funcionam delegacias de polÃ­cia e repartiÃ§Ãµes pÃºblicas sÃ£o bens de uso especial (afetados ao serviÃ§o pÃºblico). Enquanto mantiverem essa destinaÃ§Ã£o, sÃ£o inalienÃ¡veis e impenhorÃ¡veis (art. 100 do CÃ³digo Civil). Ressalta-se que bens pÃºblicos nunca sofrem usucapiÃ£o (CF, art. 183, Â§ 3Âº e 191, parÃ¡grafo Ãºnico).'),

(4, 
'Em tema de licitaÃ§Ãµes pÃºblicas regidas pela Lei nÂº 14.133/2021 (Nova Lei de LicitaÃ§Ãµes), a modalidade de licitaÃ§Ã£o destinada Ã  contrataÃ§Ã£o de obras, serviÃ§os e compras em que a AdministraÃ§Ã£o PÃºblica realiza diÃ¡logos com licitantes previamente selecionados com o intuito de desenvolver alternativas para atender Ã s suas necessidades denomina-se:',
'PregÃ£o eletrÃ´nico.',
'ConcorrÃªncia internacional.',
'DiÃ¡logo competitivo.',
'Concurso pericial.',
'LeilÃ£o de bens pÃºblicos.',
'C',
'O diÃ¡logo competitivo Ã© a nova modalidade licitatÃ³ria introduzida no ordenamento pela Lei 14.133/2021 (art. 6Âº, XLII), voltada a inovaÃ§Ãµes tecnolÃ³gicas ou soluÃ§Ãµes complexas em que a AdministraÃ§Ã£o dialoga com os concorrentes para definir as melhores especificaÃ§Ãµes.'),

(4, 
'A avocaÃ§Ã£o de competÃªncia no Ã¢mbito da hierarquia administrativa consiste:',
'No ato discricionÃ¡rio de repassar competÃªncias de um superior para um Ã³rgÃ£o subalterno em carÃ¡ter definitivo.',
'No ato excepcional, devidamente motivado e por tempo determinado, pelo qual um superior hierÃ¡rquico atrai para si a competÃªncia decisÃ³ria de um Ã³rgÃ£o subordinado.',
'Na renÃºncia irretratÃ¡vel de competÃªncia atribuÃ­da por lei a uma autoridade policial.',
'Na transmissÃ£o simultÃ¢nea de atribuiÃ§Ãµes regulamentares entre autoridades de mesmo nÃ­vel funcional.',
'Na anulaÃ§Ã£o imediata de todas as ordens expedidas por Ã³rgÃ£os colegiados deliberativos.',
'B',
'A avocaÃ§Ã£o Ã© ato privativo de superior hierÃ¡rquico sobre subordinado, de natureza temporÃ¡ria, motivada e excepcional, por motivos relevantes devidamente justificados, conforme dispÃµe a Lei de Processo Administrativo (art. 15 da Lei 9.784/99).'),

(4, 
'O servidor pÃºblico estÃ¡vel do Estado do ParanÃ¡ somente perderÃ¡ o cargo em virtude de:',
'DecisÃ£o monocrÃ¡tica informal do seu chefe imediato por conveniÃªncia do serviÃ§o.',
'SentenÃ§a judicial transitada em julgado, processo administrativo disciplinar em que lhe seja assegurada ampla defesa ou procedimento de avaliaÃ§Ã£o periÃ³dica de desempenho.',
'Portaria do SecretÃ¡rio de SeguranÃ§a PÃºblica, sem necessidade de contraditÃ³rio em situaÃ§Ãµes de emergÃªncia.',
'Apenas sentenÃ§a judicial transitada em julgado na vara criminal.',
'Falta injustificada por mais de 5 dias consecutivos sem direito a recurso hierÃ¡rquico.',
'B',
'Conforme o art. 41, Â§ 1Âº da ConstituiÃ§Ã£o Federal, o servidor pÃºblico estÃ¡vel sÃ³ perde o cargo em virtude de sentenÃ§a judicial transitada em julgado, processo administrativo disciplinar (PAD) com ampla defesa e contraditÃ³rio, ou procedimento de avaliaÃ§Ã£o periÃ³dica de desempenho na forma de lei complementar.'),

(4, 
'Quando a autoridade policial remove um investigador de polÃ­cia como forma de puniÃ§Ã£o disfarÃ§ada por desafeto pessoal, utilizando-se formalmente do argumento da "necessidade do serviÃ§o", resta caracterizada a seguinte modalidade de abuso de poder:',
'Excesso de poder.',
'Desvio de finalidade (ou desvio de poder).',
'UsurpaÃ§Ã£o de funÃ§Ã£o pÃºblica.',
'IncompetÃªncia em razÃ£o da matÃ©ria.',
'Falta de proporcionalidade formal.',
'B',
'O desvio de finalidade ocorre quando o agente atua dentro dos limites de sua competÃªncia legal, mas pratica o ato buscando um fim diverso daquele previsto na lei ou contrÃ¡rio ao interesse pÃºblico (como uma vinganÃ§a ou retaliaÃ§Ã£o pessoal).');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 5: DIREITO CONSTITUCIONAL (10 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(5, 
'Nos termos do art. 5Âº, XI, da ConstituiÃ§Ã£o Federal de 1988 e da jurisprudÃªncia fixada pelo STF (Tema 280 da RepercussÃ£o Geral), a inviolabilidade domiciliar:',
'Ã‰ absoluta durante a noite, nÃ£o admitindo ingresso policial nem mesmo em caso de flagrante delito sem mandado.',
'Permite o ingresso policial forÃ§ado no domicÃ­lio, sem mandado judicial, a qualquer hora do dia ou da noite, em caso de flagrante delito, desde que amparado em fundadas razÃµes prÃ©vias devidamente justificadas a posteriori.',
'Exige sempre mandado judicial expedido pelo juiz competente, que sÃ³ pode ser cumprido durante a noite.',
'Autoriza o ingresso por simples intuiÃ§Ã£o da equipe policial, dispensando registro formal das razÃµes em relatÃ³rio.',
'NÃ£o se estende a escritÃ³rios comerciais, consultÃ³rios profissionais ou quartos de hotel ocupados.',
'B',
'O art. 5Âº, XI da CF estabelece que a casa Ã© asilo inviolÃ¡vel, mas ressalva flagrante delito, desastre ou socorro a qualquer hora. No Tema 280, o STF fixou: "A entrada forÃ§ada em domicÃ­lio sem mandado judicial sÃ³ Ã© lÃ­cita, mesmo em perÃ­odo noturno, quando amparada em fundadas razÃµes, devidamente justificadas a posteriori, que indiquem que dentro da casa ocorre situaÃ§Ã£o de flagrante delito".'),

(5, 
'De acordo com o art. 144 da ConstituiÃ§Ã£o Federal de 1988, compete expressamente Ã s PolÃ­cias Civis, dirigidas por delegados de polÃ­cia de carreira:',
'O policiamento ostensivo e a preservaÃ§Ã£o da ordem pÃºblica militar no territÃ³rio do Estado.',
'A apuraÃ§Ã£o de infraÃ§Ãµes penais contra a ordem polÃ­tica e social ou em detrimento de bens, serviÃ§os e interesses da UniÃ£o.',
'Ressalvada a competÃªncia da UniÃ£o, as funÃ§Ãµes de polÃ­cia judiciÃ¡ria e a apuraÃ§Ã£o de infraÃ§Ãµes penais, exceto as militares.',
'A guarda das fronteiras marÃ­timas, fluviais e secas da federaÃ§Ã£o brasileira.',
'O patrulhamento ostensivo das rodovias federais e estaduais delegadas.',
'C',
'O art. 144, Â§ 4Âº da Carta Magna estabelece textualmente: "Ã€s polÃ­cias civis, dirigidas por delegados de polÃ­cia de carreira, incumbem, ressalvada a competÃªncia da UniÃ£o, as funÃ§Ãµes de polÃ­cia judiciÃ¡ria e a apuraÃ§Ã£o de infraÃ§Ãµes penais, exceto as militares".'),

(5, 
'Assinale a opÃ§Ã£o que indica o remÃ©dio constitucional cabÃ­vel para assegurar o conhecimento de informaÃ§Ãµes relativas Ã  pessoa do impetrante, constantes de registros ou bancos de dados de entidades governamentais ou de carÃ¡ter pÃºblico:',
'Mandado de SeguranÃ§a.',
'Habeas Corpus.',
'Habeas Data.',
'Mandado de InjunÃ§Ã£o.',
'AÃ§Ã£o Popular.',
'C',
'O Habeas Data (CF, art. 5Âº, LXXII, "a") Ã© a aÃ§Ã£o constitucional destinada especificamente a assegurar o conhecimento e/ou retificaÃ§Ã£o de informaÃ§Ãµes relativas Ã  pessoa do impetrante constantes de bancos de dados estatais ou de carÃ¡ter pÃºblico.'),

(5, 
'Em relaÃ§Ã£o Ã  eficÃ¡cia e aplicabilidade das normas constitucionais (segundo a consagrada classificaÃ§Ã£o de JosÃ© Afonso da Silva), uma norma constitucional que produz efeitos plenos e imediatos desde a promulgaÃ§Ã£o, sem necessidade de lei integradora posterior para seu exercÃ­cio, classifica-se como:',
'Norma de eficÃ¡cia contida.',
'Norma de eficÃ¡cia limitada.',
'Norma de eficÃ¡cia plena.',
'Norma programÃ¡tica postergada.',
'Norma de eficÃ¡cia exaurida.',
'C',
'As normas constitucionais de eficÃ¡cia plena possuem aplicabilidade direta, imediata e integral, incidindo plenamente no mundo jurÃ­dico desde a sua entrada em vigor, sem depender de complementaÃ§Ã£o legislativa infraconstitucional.'),

(5, 
'No que tange aos direitos e garantias fundamentais individuais, a ConstituiÃ§Ã£o Federal veda expressamente no art. 5Âº a pena de:',
'Multa pecuniÃ¡ria cominatÃ³ria.',
'Perda de bens auferidos ilicitamente.',
'CarÃ¡ter perpÃ©tuo, de trabalhos forÃ§ados, de banimento e cruÃ©is.',
'PrestaÃ§Ã£o social alternativa Ã  comunidade.',
'InterdiÃ§Ã£o temporÃ¡ria de direitos funcionais.',
'C',
'O art. 5Âº, XLVII da CF veda taxativamente as penas: a) de morte (salvo em caso de guerra declarada); b) de carÃ¡ter perpÃ©tuo; c) de trabalhos forÃ§ados; d) de banimento; e) cruÃ©is.'),

(5, 
'Determinado partido polÃ­tico com representaÃ§Ã£o no Congresso Nacional pretende impugnar diretamente perante o Supremo Tribunal Federal uma lei estadual do ParanÃ¡ que supostamente viola a ConstituiÃ§Ã£o Federal. A aÃ§Ã£o do controle concentrado de constitucionalidade pertinente a essa hipÃ³tese Ã© a:',
'AÃ§Ã£o Civil PÃºblica OriginÃ¡ria.',
'ArguiÃ§Ã£o de Impedimento Federativo.',
'AÃ§Ã£o Direta de Inconstitucionalidade (ADI).',
'AÃ§Ã£o DeclaratÃ³ria de Constitucionalidade (ADC).',
'ReclamaÃ§Ã£o Disciplinar Correcional.',
'C',
'A AÃ§Ã£o Direta de Inconstitucionalidade (ADI), prevista no art. 102, I, "a" da CF, tem por objeto leis ou atos normativos federais ou estaduais que contrariem a ConstituiÃ§Ã£o da RepÃºblica. Partidos polÃ­ticos com representaÃ§Ã£o no Congresso Nacional possuem legitimidade ativa universal (CF, art. 103, VIII). A ADC cabe apenas em face de lei federal.'),

(5, 
'Uma ComissÃ£o Parlamentar de InquÃ©rito (CPI) regularmente instalada na Assembleia Legislativa do ParanÃ¡ possui poderes de investigaÃ§Ã£o prÃ³prios das autoridades judiciais. Ã€ luz da doutrina e da jurisprudÃªncia do STF, Ã© lÃ­cito Ã  CPI determinar diretamente:',
'A interceptaÃ§Ã£o telefÃ´nica das conversas privadas de investigados.',
'A quebra dos sigilos bancÃ¡rio e fiscal de investigados, mediante decisÃ£o colegiada motivada.',
'A busca e apreensÃ£o domiciliar noturna sem mandado judicial.',
'A decretaÃ§Ã£o de prisÃ£o preventiva preventiva como garantia da instruÃ§Ã£o parlamentar.',
'A indisponibilidade cautelar perpÃ©tua de todos os bens dos envolvidos.',
'B',
'As CPIs detÃªm poderes instrutÃ³rios judiciais, podendo decretar quebra de sigilo bancÃ¡rio, fiscal e telemÃ¡tico (dados cadastrais). Contudo, matÃ©rias submetidas Ã  clÃ¡usula de reserva de jurisdiÃ§Ã£o NÃƒO podem ser determinadas por CPI: interceptaÃ§Ã£o telefÃ´nica (escuta), busca domiciliar e decretaÃ§Ã£o de prisÃµes cautelares (salvo flagrante delito).'),

(5, 
'Segundo o texto constitucional, a competÃªncia para legislar privativamente sobre Direito Penal e Direito Processual Penal pertence:',
'Aos MunicÃ­pios em conjunto com o Distrito Federal.',
'Concorrentemente Ã  UniÃ£o, aos Estados e ao Distrito Federal.',
'Privativamente Ã  UniÃ£o.',
'Aos Estados-membros em suas respectivas cartas constitucionais.',
'Ao Conselho Nacional de JustiÃ§a.',
'C',
'O art. 22, inciso I, da ConstituiÃ§Ã£o Federal estabelece que compete privativamente Ã  UniÃ£o legislar sobre direito civil, comercial, penal, processual, eleitoral, agrÃ¡rio, marÃ­timo, aeronÃ¡utico, espacial e do trabalho.'),

(5, 
'O princÃ­pio constitucional segundo o qual "ninguÃ©m serÃ¡ considerado culpado atÃ© o trÃ¢nsito em julgado de sentenÃ§a penal condenatÃ³ria" (art. 5Âº, LVII, CF) consagra o princÃ­pio da:',
'PresunÃ§Ã£o de inocÃªncia (ou nÃ£o culpabilidade).',
'InÃ©rcia da jurisdiÃ§Ã£o.',
'Identidade fÃ­sica do magistrado.',
'Verdade real absoluta.',
'Obrigatoriedade da aÃ§Ã£o civil.',
'A',
'Trata-se do postulado fundamental da presunÃ§Ã£o de inocÃªncia ou princÃ­pio do estado de nÃ£o culpabilidade, baluarte civilizatÃ³rio garantidor da dignidade humana no processo penal brasileiro.'),

(5, 
'Em relaÃ§Ã£o Ã  organizaÃ§Ã£o do Estado brasileiro e Ã  intervenÃ§Ã£o da UniÃ£o nos Estados-membros, a decretaÃ§Ã£o de intervenÃ§Ã£o federal Ã© ato privativo do:',
'Presidente do Supremo Tribunal Federal.',
'Presidente do Senado Federal.',
'Presidente da RepÃºblica.',
'Procurador-Geral da RepÃºblica.',
'Conselho da RepÃºblica ouvido o Conselho de Defesa Nacional.',
'C',
'Compete privativamente ao Presidente da RepÃºblica decretar e executar a intervenÃ§Ã£o federal (CF, art. 84, X), observadas as hipÃ³teses taxativas e o procedimento estatuÃ­do no art. 36 da ConstituiÃ§Ã£o Federal.');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 6: DIREITO PENAL (15 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(6, 
'Lucas, com inequÃ­voca intenÃ§Ã£o homicida (animus necandi), dispara cinco tiros de revÃ³lver contra seu desafeto Mateus. Mateus Ã© socorrido com vida e levado ao hospital de pronto-socorro. Enquanto recebia tratamento mÃ©dico adequado, um incÃªndio imprevisÃ­vel de causas fortuitas destrÃ³i a ala hospitalar, vindo Mateus a falecer exclusivamente em virtude das queimaduras e asfixia pela fumaÃ§a. De acordo com o art. 13 do CÃ³digo Penal e a teoria da causalidade adequada, Lucas responderÃ¡ por:',
'HomicÃ­dio consumado simples.',
'HomicÃ­dio consumado qualificado.',
'Tentativa de homicÃ­dio.',
'HomicÃ­dio culposo com perdÃ£o judicial.',
'LesÃ£o corporal gravÃ­ssima seguida de morte.',
'C',
'Trata-se de hipÃ³tese clÃ¡ssica de concausa superveniente relativamente independente que, por si sÃ³, produziu o resultado (art. 13, Â§ 1Âº, CP). O incÃªndio no hospital foge ao desdobramento natural dos disparos, rompendo o nexo de causalidade quanto ao resultado morte. Portanto, o agente responde apenas pelos atos anteriores: tentativa de homicÃ­dio.'),

(6, 
'TÃ­cio, agente de polÃ­cia civil, durante o cumprimento de mandado de prisÃ£o, exige de familiares do investigado a quantia de R$ 10.000,00 para "amenizar o relatÃ³rio policial e nÃ£o efetuar a conduÃ§Ã£o Ã  delegacia". A conduta praticada por TÃ­cio subsume-se perfeitamente ao tipo penal de:',
'CorrupÃ§Ã£o passiva (art. 317, CP).',
'ConcussÃ£o (art. 316, CP).',
'PrevaricaÃ§Ã£o (art. 319, CP).',
'Advocacia administrativa (art. 321, CP).',
'ExtorsÃ£o mediante sequestro (art. 159, CP).',
'B',
'O verbo nÃºcleo do tipo na concussÃ£o Ã© EXIGIR vantagem indevida em razÃ£o da funÃ§Ã£o pÃºblica (art. 316, CP). Na corrupÃ§Ã£o passiva (art. 317, CP), os verbos sÃ£o solicitar, receber ou aceitar promessa. Tendo o policial exigido o valor, comete o crime de concussÃ£o.'),

(6, 
'MÃ©vio, funcionÃ¡rio pÃºblico lotado no setor de almoxarifado da PolÃ­cia Civil, valendo-se da facilidade que lhe proporciona o cargo que ocupa, subtrai e leva para sua residÃªncia dois computadores novos pertencentes ao patrimÃ´nio pÃºblico do Estado. MÃ©vio praticou o crime de:',
'Peculato-apropriaÃ§Ã£o (art. 312, caput, primeira parte, CP).',
'Peculato-furto ou peculato imprÃ³prio (art. 312, Â§ 1Âº, CP).',
'Furto qualificado por abuso de confianÃ§a comum (art. 155, Â§ 4Âº, II, CP).',
'PrevaricaÃ§Ã£o patrimonial (art. 319, CP).',
'CondescendÃªncia criminosa qualificada (art. 320, CP).',
'B',
'Quando o funcionÃ¡rio pÃºblico NÃƒO tem a posse ou detenÃ§Ã£o do bem em razÃ£o do cargo, mas o SUBTRAI (ou concorre para que seja subtraÃ­do) valendo-se de facilidade proporcionada pela qualidade de funcionÃ¡rio, comete peculato-furto (art. 312, Â§ 1Âº do CÃ³digo Penal).'),

(6, 
'Em tema de Teoria do Crime e Excludentes de Ilicitude, assinale a opÃ§Ã£o correta Ã  luz do CÃ³digo Penal brasileiro:',
'O estado de necessidade admite que o agente invoque a excludente mesmo quando tinha o dever legal de enfrentar o perigo.',
'A legÃ­tima defesa putativa Ã© causa excludente de ilicitude, excluindo a tipicidade formal da conduta.',
'Entende-se em legÃ­tima defesa quem, usando moderadamente dos meios necessÃ¡rios, repele injusta agressÃ£o, atual ou iminente, a direito seu ou de outrem.',
'O estrito cumprimento do dever legal afasta a culpabilidade do sujeito por inexigibilidade de conduta diversa.',
'O consentimento do ofendido Ã© excludente expressa de culpabilidade positivada na Parte Geral do CÃ³digo Penal.',
'C',
'O art. 25 do CP define expressamente: "Entende-se em legÃ­tima defesa quem, usando moderadamente dos meios necessÃ¡rios, repele injusta agressÃ£o, atual ou iminente, a direito seu ou de outrem".'),

(6, 
'No que concerne ao iter criminis (caminho do crime), a desistÃªncia voluntÃ¡ria e o arrependimento eficaz produzem como consequÃªncia jurÃ­dica:',
'A exclusÃ£o da ilicitude do fato tÃ­pico.',
'A atenuaÃ§Ã£o obrigatÃ³ria da pena de um a dois terÃ§os no crime tentado.',
'O agente sÃ³ responde pelos atos jÃ¡ praticados (tentativa abandonada / ponte de ouro).',
'A extinÃ§Ã£o da punibilidade pelo perdÃ£o tÃ¡cito estatal.',
'A exclusÃ£o da culpabilidade por inexigibilidade de conduta diversa.',
'C',
'Nos termos do art. 15 do CP: "O agente que, voluntariamente, desiste de prosseguir na execuÃ§Ã£o (desistÃªncia voluntÃ¡ria) ou impede que o resultado se produza (arrependimento eficaz), sÃ³ responde pelos atos jÃ¡ praticados". Ã‰ a clÃ¡ssica "ponte de ouro" de Von Liszt.'),

(6, 
'A respeito do crime de homicÃ­dio qualificado pelo feminicÃ­dio (art. 121, Â§ 2Âº, VI, CP), Ã© correto afirmar que:',
'Trata-se de qualificadora de natureza subjetiva, ligada aos motivos Ã­ntimos e torpes do agente.',
'Possui natureza jurÃ­dica de circunstÃ¢ncia objetiva, caracterizando-se por razÃµes da condiÃ§Ã£o de sexo feminino quando o crime envolve violÃªncia domÃ©stica e familiar ou menosprezo/discriminaÃ§Ã£o Ã  condiÃ§Ã£o de mulher.',
'Ã‰ incompatÃ­vel com a incidÃªncia de qualquer outra qualificadora subjetiva, como o motivo fÃºtil.',
'Aplica-se unicamente quando a vÃ­tima mantinha matrimÃ´nio civil formal com o agressor.',
'NÃ£o admite aumento de pena se o crime for praticado na presenÃ§a fÃ­sica ou virtual de descendente ou de ascendente da vÃ­tima.',
'B',
'O feminicÃ­dio tem natureza eminentemente OBJETIVA, pois decorre da condiÃ§Ã£o do sexo feminino (situaÃ§Ã£o fÃ¡tica de violÃªncia domÃ©stica e familiar ou menosprezo/discriminaÃ§Ã£o Ã  condiÃ§Ã£o de mulher - art. 121, Â§ 2Âº-A). Por ter natureza objetiva, o STJ pacificou que Ã© compatÃ­vel com qualificadoras subjetivas como motivo fÃºtil ou torpe.'),

(6, 
'Caio aborda uma pedestre em via pÃºblica, aponta simulacro de arma de fogo e exige a entrega de sua bolsa e aparelho celular. A vÃ­tima, amedrontada, entrega os bens. Segundo a jurisprudÃªncia pacÃ­fica do Superior Tribunal de JustiÃ§a (STJ):',
'O uso de arma de brinquedo ou simulacro configura roubo com majorante de emprego de arma de fogo.',
'A conduta Ã© atÃ­pica por ausÃªncia de potencial lesivo real.',
'O uso de simulacro de arma de fogo configura grave ameaÃ§a, tipificando o crime de roubo simples (art. 157, caput), mas nÃ£o autoriza a incidÃªncia da majorante do art. 157, Â§ 2Âº-A, I, do CP.',
'O fato amolda-se exclusivamente ao crime de estelionato qualificado pela surpresa.',
'Trata-se de mera contravenÃ§Ã£o penal de porte de rÃ©plica de arma.',
'C',
'O STJ cancelou a SÃºmula 174. O simulacro serve para caracterizar a grave ameaÃ§a (configurando o crime de roubo em vez de furto), mas NÃƒO incide a majorante de arma de fogo, pois nÃ£o hÃ¡ lesividade e potencial lesivo real.'),

(6, 
'O funcionÃ¡rio pÃºblico que deixa, por indulgÃªncia, de responsabilizar subordinado que cometeu infraÃ§Ã£o no exercÃ­cio do cargo comete o delito de:',
'PrevaricaÃ§Ã£o.',
'CondescendÃªncia criminosa.',
'Peculato culposo.',
'ConcussÃ£o omissiva.',
'CorrupÃ§Ã£o passiva atenuada.',
'B',
'O art. 320 do CÃ³digo Penal tipifica expressamente a CondescendÃªncia Criminosa: "Deixar o funcionÃ¡rio, por indulgÃªncia, de responsabilizar subordinado que cometeu infraÃ§Ã£o no exercÃ­cio do cargo ou, quando lhe falte competÃªncia, nÃ£o levar o fato ao conhecimento da autoridade competente".'),

(6, 
'Sobre o concurso de pessoas no Direito Penal brasileiro, o CÃ³digo Penal adotou como regra geral em seu art. 29 a teoria:',
'Pluralista ou estritamente individualista.',
'Dualista.',
'Monista ou unitÃ¡ria temperada.',
'Extensiva da autoria.',
'Objetivo-material irrestrita.',
'C',
'O CÃ³digo Penal brasileiro adotou expressamente a Teoria Monista (ou UnitÃ¡ria) mitigada/temperada: todos os que concorrem para o crime incidem nas penas a este cominadas na medida de sua culpabilidade (art. 29 do CP), distinguindo autor, coautor e partÃ­cipe com causas de diminuiÃ§Ã£o para participaÃ§Ã£o de menor importÃ¢ncia.'),

(6, 
'Bruno subtrai um relÃ³gio avaliado em R$ 80,00 de um grande shopping center em Curitiba. Bruno Ã© primÃ¡rio, sem antecedentes, e a res furtiva foi restituÃ­da intacta Ã  loja. O princÃ­pio que afasta a tipicidade material da conduta em razÃ£o da inexpressividade da lesÃ£o ao bem jurÃ­dico Ã© o princÃ­pio da:',
'Legalidade estrita.',
'AdequaÃ§Ã£o social primÃ¡ria.',
'InsignificÃ¢ncia (ou bagatela prÃ³pria).',
'Proporcionalidade inversa.',
'Culpabilidade mitigada.',
'C',
'O princÃ­pio da insignificÃ¢ncia (excludente da tipicidade material) afasta a intervenÃ§Ã£o penal quando preenchidos os requisitos consolidados pelo STF: mÃ­nima ofensividade da conduta, ausÃªncia de periculosidade social da aÃ§Ã£o, reduzidÃ­ssimo grau de reprovabilidade do comportamento e inexpressividade da lesÃ£o jurÃ­dica.'),

(6, 
'JoÃ£o, supondo erroneamente que caÃ§ava um animal silvestre na mata fechada de uma fazenda, efetua um disparo certeiro contra um arbusto e atinge mortalmente seu companheiro de expediÃ§Ã£o que ali se encontrava camuflado. No caso em tela, ocorreu:',
'Erro de proibiÃ§Ã£o direto escusÃ¡vel.',
'Erro sobre elemento constitutivo do tipo penal (erro de tipo essencial).',
'Aberratio ictus com dolo eventual.',
'Descriminante putativa sobre a ilicitude.',
'Crime impossÃ­vel por ineficÃ¡cia absoluta do meio.',
'B',
'O erro de tipo essencial (art. 20, caput, CP) incide sobre os dados da realidade descritos como elementares do tipo (o agente nÃ£o sabia que matava um homem, achava que atirava em animal). O erro de tipo sempre exclui o dolo, permitindo a puniÃ§Ã£o por culpa se previsto em lei (homicÃ­dio culposo).'),

(6, 
'O crime de extorsÃ£o mediante sequestro (art. 159 do CÃ³digo Penal) classifica-se doutrinariamente como crime:',
'Material e instantÃ¢neo de efeitos permanentes.',
'Formal e permanente, cuja consumaÃ§Ã£o dÃ¡-se com a privaÃ§Ã£o da liberdade da vÃ­tima independentemente da obtenÃ§Ã£o do resgate.',
'Mera conduta de resultado instantÃ¢neo condicional.',
'Culposo continuado plurissubsistente.',
'De perigo abstrato instantÃ¢neo.',
'B',
'A extorsÃ£o mediante sequestro consuma-se no momento em que a vÃ­tima tem sua liberdade privada para a finalidade de obtenÃ§Ã£o de vantagem como resgate. A obtenÃ§Ã£o do resgate Ã© mero exaurimento (crime formal). AlÃ©m disso, a privaÃ§Ã£o prolonga-se no tempo (crime permanente).'),

(6, 
'A apropriaÃ§Ã£o indÃ©bita (art. 168 do CÃ³digo Penal) distingue-se fundamentalmente do crime de estelionato (art. 171 do CÃ³digo Penal) pelo fato de que:',
'No estelionato a posse inicial Ã© lÃ­cita, ao passo que na apropriaÃ§Ã£o indÃ©bita hÃ¡ sempre violÃªncia fÃ­sica.',
'Na apropriaÃ§Ã£o indÃ©bita o dolo do agente Ã© superveniente Ã  posse legÃ­tima e desvigiada do bem, ao passo que no estelionato o dolo Ã© anterior, obtendo o bem mediante fraude.',
'A apropriaÃ§Ã£o indÃ©bita Ã© crime hediondo inafianÃ§Ã¡vel, enquanto o estelionato Ã© infraÃ§Ã£o de menor potencial ofensivo.',
'O estelionato sÃ³ pode ser praticado por funcionÃ¡rio pÃºblico no exercÃ­cio de suas funÃ§Ãµes.',
'Na apropriaÃ§Ã£o indÃ©bita a vÃ­tima nunca entrega a coisa espontaneamente.',
'B',
'Na apropriaÃ§Ã£o indÃ©bita, o agente recebe a coisa legitimamente sem fraude; posteriormente, inverte o Ã¢nimo (animus rem sibi habendi). No estelionato, o agente emprega a fraude desde o inÃ­cio para induzir ou manter a vÃ­tima em erro a fim de obter o bem (dolo antecedente).'),

(6, 
'O agente que dolosamente destrÃ³i, inutiliza ou deteriora coisa alheia comete o crime de dano (art. 163, CP). O dano cometido contra o patrimÃ´nio do Estado do ParanÃ¡ (como a viatura ou sede da PolÃ­cia Civil) configura:',
'Crime contra a seguranÃ§a nacional.',
'Dano simples sujeito Ã  transaÃ§Ã£o penal do JECRIM.',
'Dano qualificado (art. 163, parÃ¡grafo Ãºnico, III, do CP).',
'Ato de improbidade nÃ£o tipificado penalmente.',
'ContravenÃ§Ã£o de vandalismo urbano.',
'C',
'Nos termos do art. 163, parÃ¡grafo Ãºnico, III do CP, o dano Ã© qualificado se cometido contra o patrimÃ´nio da UniÃ£o, de Estado, do Distrito Federal, de MunicÃ­pio ou de autarquia, fundaÃ§Ã£o pÃºblica, empresa pÃºblica ou sociedade de economia mista.'),

(6, 
'Nos crimes contra a honra, a imputaÃ§Ã£o a alguÃ©m de fato definido como crime, sabendo-o inverÃ­dico, tipifica:',
'DifamaÃ§Ã£o.',
'InjÃºria real.',
'CalÃºnia.',
'Desacato.',
'Falso testemunho.',
'C',
'A calÃºnia (art. 138, CP) consiste em imputar falsamente a outrem fato determinado definido como crime. A difamaÃ§Ã£o (art. 139) Ã© imputar fato desonroso nÃ£o criminoso; a injÃºria (art. 140) Ã© ofender a dignidade ou o decoro.');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 7: DIREITO PROCESSUAL PENAL (15 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(7, 
'Sobre as caracterÃ­sticas doutrinÃ¡rias e legais do InquÃ©rito Policial no ordenamento jurÃ­dico brasileiro, Ã© correto afirmar que:',
'Ã‰ um procedimento judicial contraditÃ³rio e indisponÃ­vel para o MinistÃ©rio PÃºblico.',
'A autoridade policial (Delegado de PolÃ­cia) nÃ£o poderÃ¡ mandar arquivar autos de inquÃ©rito policial (princÃ­pio da indisponibilidade).',
'O inquÃ©rito policial Ã© obrigatÃ³rio para o oferecimento de toda e qualquer aÃ§Ã£o penal pÃºblica incondicionada.',
'O defensor do indiciado nÃ£o possui direito de acesso aos elementos de prova jÃ¡ documentados no procedimento investigatÃ³rio.',
'O inquÃ©rito policial admite a aplicaÃ§Ã£o irrestrita do princÃ­pio da ampla defesa prÃ©via com oitiva obrigatÃ³ria de peritos em audiÃªncia judicial.',
'B',
'Conforme o art. 17 do CÃ³digo de Processo Penal: "A autoridade policial nÃ£o poderÃ¡ mandar arquivar autos de inquÃ©rito policial". Trata-se do princÃ­pio da indisponibilidade do inquÃ©rito policial pelo Delegado. AlÃ©m disso, a SÃºmula Vinculante 14 garante ao defensor acesso aos autos jÃ¡ documentados.'),

(7, 
'No que concerne ao Acordo de NÃ£o PersecuÃ§Ã£o Penal (ANPP), inserido no art. 28-A do CÃ³digo de Processo Penal pelo Pacote Anticrime (Lei nÂº 13.964/2019), assinale o requisito indispensÃ¡vel para a sua celebraÃ§Ã£o:',
'O crime ter sido cometido com violÃªncia real ou grave ameaÃ§a Ã  pessoa.',
'O investigado ter confessado formal e circunstancialmente a prÃ¡tica da infraÃ§Ã£o penal, cuja pena mÃ­nima cominada seja inferior a 4 anos.',
'A pena mÃ¡xima em abstrato do delito nÃ£o ultrapassar 2 anos.',
'Ser o rÃ©u reincidente especÃ­fico em crimes contra o patrimÃ´nio.',
'Haver manifestaÃ§Ã£o favorÃ¡vel prÃ©via e vinculante do juiz antes do oferecimento pelo MinistÃ©rio PÃºblico.',
'B',
'O art. 28-A do CPP estabelece que, nÃ£o sendo caso de arquivamento e tendo o investigado confessado formal e circunstancialmente a prÃ¡tica de infraÃ§Ã£o penal sem violÃªncia ou grave ameaÃ§a e com pena mÃ­nima inferior a 4 anos, o MinistÃ©rio PÃºblico poderÃ¡ propor o ANPP.'),

(7, 
'A respeito do instituto da Cadeia de CustÃ³dia da prova, regulamentada nos arts. 158-A a 158-F do CPP, a etapa que consiste no ato de distinguir um elemento como de potencial interesse para a produÃ§Ã£o da prova pericial denomina-se:',
'Reconhecimento.',
'Isolamento.',
'FixaÃ§Ã£o.',
'Coleta.',
'Rastreamento.',
'A',
'O art. 158-B, I, do CPP define: "reconhecimento: ato de distinguir um elemento como de potencial interesse para a produÃ§Ã£o da prova pericial". O isolamento (II) Ã© evitar que se altere o estado das coisas; a fixaÃ§Ã£o (III) Ã© a descriÃ§Ã£o detalhada; a coleta (IV) Ã© o recolhimento do vestÃ­gio.'),

(7, 
'Segundo o art. 302 do CÃ³digo de Processo Penal, considera-se em flagrante delito quem:',
'Ã‰ surpreendido dias apÃ³s o fato em conversa telefÃ´nica interceptada sobre o delito.',
'EstÃ¡ cometendo a infraÃ§Ã£o penal ou acaba de cometÃª-la.',
'Apenas confessa em cartÃ³rio a prÃ¡tica delitiva apÃ³s intimaÃ§Ã£o regular.',
'Foi indiciado pelo delegado de polÃ­cia com base em denÃºncia anÃ´nima.',
'Possui parentesco de primeiro grau com o mandante do homicÃ­dio.',
'B',
'O art. 302 do CPP define flagrante prÃ³prio ou perfeito (incisos I e II): "I - estÃ¡ cometendo a infraÃ§Ã£o penal; II - acaba de cometÃª-la". O inciso III trata do flagrante imprÃ³prio e o IV do flagrante presumido.'),

(7, 
'De acordo com as regras processuais que regem a PrisÃ£o Preventiva (arts. 311 e 312 do CPP com as reformas vigentes):',
'O juiz pode decretar a prisÃ£o preventiva de ofÃ­cio durante a fase do inquÃ©rito policial.',
'O juiz pode decretar a prisÃ£o preventiva de ofÃ­cio durante a fase judicial do processo penal.',
'Ã‰ vedada expressamente a decretaÃ§Ã£o da prisÃ£o preventiva de ofÃ­cio pelo magistrado em qualquer fase (tanto no inquÃ©rito quanto no processo penal).',
'A prisÃ£o preventiva pode ser decretada com a finalidade exclusiva de antecipaÃ§Ã£o de cumprimento de pena.',
'A prisÃ£o preventiva Ã© admitida automaticamente em qualquer crime culposo.',
'C',
'Com a Lei 13.964/2019 (Pacote Anticrime), o juiz nÃ£o pode mais decretar prisÃ£o preventiva de ofÃ­cio em nenhuma fase da persecuÃ§Ã£o penal (art. 311 do CPP). Depende sempre de requerimento do MP, querelante ou representaÃ§Ã£o da autoridade policial.'),

(7, 
'Em relaÃ§Ã£o Ã  PrisÃ£o TemporÃ¡ria (regulamentada pela Lei nÂº 7.960/1989 e interpretada conjuntamente pelo STF nas ADIs 3360 e 4109), seu prazo de duraÃ§Ã£o em crimes comuns Ã© de:',
'10 dias prorrogÃ¡veis por mais 10.',
'5 dias prorrogÃ¡veis por igual perÃ­odo em caso de extrema e comprovada necessidade.',
'15 dias improrrogÃ¡veis.',
'30 dias prorrogÃ¡veis por atÃ© 90 dias.',
'24 horas prorrogÃ¡veis atÃ© a audiÃªncia de custÃ³dia.',
'B',
'A Lei 7.960/1989, art. 2Âº, estabelece que a prisÃ£o temporÃ¡ria terÃ¡ o prazo de 5 (cinco) dias, prorrogÃ¡vel por igual perÃ­odo em caso de extrema e comprovada necessidade. Se o crime for hediondo ou equiparado, o prazo Ã© de 30 dias prorrogÃ¡veis por mais 30 (Lei 8.072/90, art. 2Âº, Â§ 4Âº).'),

(7, 
'Conforme preceitua o art. 157 do CPP, as provas ilÃ­citas (obtidas com violaÃ§Ã£o a normas constitucionais ou legais) e as provas delas derivadas (teoria dos frutos da Ã¡rvore envenenada):',
'SÃ£o plenamente admissÃ­veis no processo se demonstrarem a verdade real do fato.',
'SÃ£o nulas apenas relativamente e dependem de preclusÃ£o da defesa tÃ©cnica.',
'SÃ£o inadmissÃ­veis e devem ser desentranhadas dos autos, salvo quando nÃ£o evidenciado o nexo de causalidade ou quando as derivadas puderem ser obtidas por fonte independente.',
'Podem ser valoradas pelo magistrado com eficÃ¡cia mitigada na dosimetria da pena.',
'Tornam-se lÃ­citas caso haja autorizaÃ§Ã£o posterior da comissÃ£o disciplinar.',
'C',
'O art. 157 do CPP positiva que sÃ£o inadmissÃ­veis as provas ilÃ­citas, devendo ser desentranhadas do processo, estendendo-se a nulidade Ã s provas derivadas, salvo quando nÃ£o houver nexo causal ou quando derivadas de fonte independente (fruits of the poisonous tree).'),

(7, 
'O mandado de busca e apreensÃ£o domiciliar, ressalvada a hipÃ³tese de consentimento do morador ou flagrante delito, sÃ³ pode ser executado:',
'A qualquer momento do dia ou da noite, bastando autorizaÃ§Ã£o escrita do delegado.',
'Durante o dia, compreendido entre a aurora e o crepÃºsculo (ou das 5h Ã s 21h nos termos da Lei de Abuso de Autoridade).',
'Apenas aos finais de semana e feriados com escolta especial.',
'Exclusivamente na presenÃ§a do Promotor de JustiÃ§a e do Juiz de Direito.',
'Durante o perÃ­odo noturno mediante lacraÃ§Ã£o das portas da residÃªncia.',
'B',
'Conforme o art. 5Âº, XI da CF e o art. 245 do CPP, as buscas domiciliares com mandado serÃ£o executadas de dia. A Lei de Abuso de Autoridade (Lei 13.869/19, art. 22, III) pune expressamente o cumprimento de mandado de busca e apreensÃ£o domiciliar apÃ³s as 21h ou antes das 5h.'),

(7, 
'A AudiÃªncia de CustÃ³dia deve ser realizada no prazo improrrogÃ¡vel de:',
'48 horas contadas da lavratura da nota de culpa.',
'24 horas apÃ³s a realizaÃ§Ã£o da prisÃ£o, com a apresentaÃ§Ã£o do preso ao juiz competente.',
'72 horas nos crimes inafianÃ§Ã¡veis.',
'5 dias apÃ³s a conclusÃ£o do inquÃ©rito policial.',
'10 dias se o autuado tiver advogado constituÃ­do.',
'B',
'O art. 310 do CPP e os tratados internacionais de direitos humanos (Pacto de San JosÃ© da Costa Rica) estipulam que a autoridade deve encaminhar o preso Ã  presenÃ§a do juiz em atÃ© 24 horas apÃ³s a efetivaÃ§Ã£o da prisÃ£o.'),

(7, 
'Nos crimes de aÃ§Ã£o penal pÃºblica condicionada Ã  representaÃ§Ã£o, o prazo decadencial para que o ofendido ou seu representante legal exerÃ§a o direito de representaÃ§Ã£o perante a autoridade Ã© de:',
'30 dias a contar da consumaÃ§Ã£o do delito.',
'6 meses a contar do dia em que veio a saber quem Ã© o autor do crime.',
'1 ano contado da data da instauraÃ§Ã£o da portaria policial.',
'3 meses da ciÃªncia da decisÃ£o de pronÃºncia.',
'90 dias da oitiva pericial.',
'B',
'O art. 38 do CPP e o art. 103 do CP determinam que o direito de representaÃ§Ã£o decai no prazo de 6 (seis) meses, contados do dia em que a vÃ­tima veio a saber quem Ã© o autor do delito.'),

(7, 
'Quando a infraÃ§Ã£o penal deixar vestÃ­gios materiais (delicta facti permanentis), Ã© indispensÃ¡vel no processo penal:',
'A confissÃ£o espontÃ¢nea do acusado para suprir qualquer laudo pericial.',
'O exame de corpo de delito, direto ou indireto, nÃ£o podendo supri-lo a confissÃ£o do acusado.',
'A juntada de termo de declaraÃ§Ã£o de duas testemunhas sem exame pericial.',
'Apenas fotografia anexada ao boletim de ocorrÃªncia.',
'O parecer vinculante da ouvidoria de polÃ­cia.',
'B',
'O art. 158 do CPP determina textualmente: "Quando a infraÃ§Ã£o deixar vestÃ­gios, serÃ¡ indispensÃ¡vel o exame de corpo de delito, direto ou indireto, nÃ£o podendo supri-lo a confissÃ£o do acusado".'),

(7, 
'Em relaÃ§Ã£o Ã  competÃªncia territorial no processo penal, a regra geral insculpida no art. 70 do CPP determina que a competÃªncia serÃ¡ firmada pelo:',
'DomicÃ­lio da vÃ­tima.',
'Lugar em que se consumar a infraÃ§Ã£o penal ou, no caso de tentativa, pelo lugar em que for praticado o Ãºltimo ato de execuÃ§Ã£o.',
'Local onde o mandado de prisÃ£o for primeiramente cumprido.',
'Tribunal de JustiÃ§a do Estado sede da delegacia geral.',
'EndereÃ§o do perito mÃ©dico-legista responsÃ¡vel pelo caso.',
'B',
'O art. 70, caput, do CPP consagra a Teoria do Resultado para a fixaÃ§Ã£o do foro ratione loci: a competÃªncia serÃ¡, de regra, determinada pelo lugar em que se consumar a infraÃ§Ã£o, ou, no caso de tentativa, pelo lugar em que for praticado o Ãºltimo ato executÃ³rio.'),

(7, 
'A incomunicabilidade do preso no inquÃ©rito policial:',
'Pode ser decretada livremente pelo delegado de polÃ­cia por atÃ© 10 dias.',
'Foi revogada e nÃ£o foi recepcionada pela ConstituiÃ§Ã£o Federal de 1988, sendo vedada em qualquer circunstÃ¢ncia.',
'Aplica-se compulsoriamente a todos os presos em flagrante delito por trÃ¡fico de entorpecentes.',
'Pode abranger as conversas reservadas entre o preso e seu advogado legalmente constituÃ­do.',
'Depende exclusivamente de portaria do secretÃ¡rio de seguranÃ§a pÃºblica.',
'B',
'O art. 136, Â§ 3Âº, IV da CF veda a incomunicabilidade do preso atÃ© mesmo sob estado de defesa. Logo, a doutrina e jurisprudÃªncia afirmam categoricamente que o art. 21 do CPP nÃ£o foi recepcionado pela CF/88, sendo inadmissÃ­vel no ordenamento constitucional vigente.'),

(7, 
'O assistente de acusaÃ§Ã£o, no processo penal brasileiro, pode intervir:',
'Apenas na fase do inquÃ©rito policial antes do relatÃ³rio do delegado.',
'Na aÃ§Ã£o penal pÃºblica, apÃ³s o recebimento da denÃºncia, nÃ£o podendo intervir antes de iniciada a aÃ§Ã£o judicial.',
'Exclusivamente na execuÃ§Ã£o penal para fiscalizar o cumprimento da pena.',
'Em qualquer fase sem autorizaÃ§Ã£o do MinistÃ©rio PÃºblico ou do juiz.',
'Apenas quando o rÃ©u estiver foragido fora do territÃ³rio nacional.',
'B',
'O art. 268 do CPP dispÃµe que em todos os termos da aÃ§Ã£o pÃºblica Ã© admissÃ­vel a intervenÃ§Ã£o do ofendido como assistente do MP. O assistente sÃ³ ingressa a partir da deflagraÃ§Ã£o da aÃ§Ã£o penal, nÃ£o existindo a figura na fase preliminar do inquÃ©rito policial.'),

(7, 
'Sobre o princÃ­pio da oportunidade e da obrigatoriedade da aÃ§Ã£o penal pÃºblica, cabe ao MinistÃ©rio PÃºblico:',
'Propor a aÃ§Ã£o penal pÃºblica incondicionada compulsoriamente diante de justa causa (indÃ­cios suficientes de autoria e prova da materialidade).',
'Escolher livremente segundo conveniÃªncia polÃ­tica se processa ou nÃ£o o indiciado.',
'Submeter a denÃºncia previamente Ã  apreciaÃ§Ã£o da CÃ¢mara Municipal de Vereadores.',
'Recusar o oferecimento de denÃºncia com base na falta de recursos financeiros do rÃ©u.',
'Arquivar os autos por decisÃ£o monocrÃ¡tica irrecorrÃ­vel sem chancela do juÃ­zo de garantias.',
'A',
'A aÃ§Ã£o penal pÃºblica rege-se pelo princÃ­pio da obrigatoriedade (ou legalidade processual): presentes a materialidade do fato delituoso e indÃ­cios suficientes de autoria (justa causa), o dominus litis (MP) tem o dever de promover a denÃºncia, ressalvadas as hipÃ³teses consensuais estritas da lei (como o ANPP e transaÃ§Ã£o penal).');

-- ------------------------------------------------------------------------------
-- DISCIPLINA 8: LEGISLAÃ‡ÃƒO PENAL ESPECIAL (15 QuestÃµes)
-- ------------------------------------------------------------------------------
INSERT INTO `questoes` (`disciplina_id`, `enunciado`, `alt_a`, `alt_b`, `alt_c`, `alt_d`, `alt_e`, `gabarito`, `comentario`) VALUES
(8, 
'De acordo com a Lei de Drogas (Lei nÂº 11.343/2006), o agente que adquire, guarda ou transporta drogas para consumo pessoal (art. 28):',
'Pratica conduta atÃ­pica, tendo ocorrido a descriminalizaÃ§Ã£o formal da posse de entorpecentes.',
'Pratica crime despenalizado, estando sujeito unicamente Ã s penas de advertÃªncia, prestaÃ§Ã£o de serviÃ§os Ã  comunidade e medida educativa de comparecimento a programa ou curso educativo.',
'Sujeita-se Ã  pena privativa de liberdade de reclusÃ£o de 1 a 3 anos, vedada a substituiÃ§Ã£o por restritiva de direitos.',
'Pode ser preso em flagrante delito e recolhido Ã  carceragem comum atÃ© o pagamento de fianÃ§a.',
'Responde pelo crime de trÃ¡fico privilegiado na modalidade culposa.',
'B',
'O STF fixou no RE 430.105 que o art. 28 da Lei 11.343/06 operou uma DESPENALIZAÃ‡ÃƒO (aboliu penas privativas de liberdade de prisÃ£o), e nÃ£o descriminalizaÃ§Ã£o formal da conduta. As sanÃ§Ãµes aplicÃ¡veis sÃ£o advertÃªncia, prestaÃ§Ã£o de serviÃ§os Ã  comunidade e medida educativa. O agente nÃ£o Ã© preso em flagrante (lavra-se TCO e liberaÃ§Ã£o imediata).'),

(8, 
'Para a concessÃ£o da causa de diminuiÃ§Ã£o de pena do chamado "trÃ¡fico privilegiado" (art. 33, Â§ 4Âº da Lei nÂº 11.343/2006), exige-se cumulativamente que o agente:',
'Seja primÃ¡rio, tenha bons antecedentes, nÃ£o se dedique Ã s atividades criminosas nem integre organizaÃ§Ã£o criminosa.',
'Confesse a prÃ¡tica do trÃ¡fico e entregue voluntariamente toda a droga em atÃ© 24 horas.',
'Comprove exercer trabalho com carteira assinada e resida no distrito da culpa hÃ¡ mais de 5 anos.',
'Tenha comercializado exclusivamente maconha ou substÃ¢ncia canabinoide.',
'Comprometa-se a ressarcir as despesas com perÃ­cia e tratamento de dependentes quÃ­micos.',
'A',
'O art. 33, Â§ 4Âº da Lei 11.343/06 prevÃª a reduÃ§Ã£o de um sexto a dois terÃ§os desde que o agente seja primÃ¡rio, de bons antecedentes, nÃ£o se dedique Ã s atividades criminosas nem integre organizaÃ§Ã£o criminosa. Ressalta-se que o STF fixou que o trÃ¡fico privilegiado NÃƒO Ã© crime hediondo.'),

(8, 
'No crime de descumprimento de medidas protetivas de urgÃªncia (art. 24-A da Lei Maria da Penha - Lei nÂº 11.340/2006), caso o agressor seja capturado em flagrante pela PolÃ­cia Civil:',
'A fianÃ§a pode ser concedida diretamente pela autoridade policial (Delegado de PolÃ­cia).',
'A concessÃ£o de fianÃ§a caberÃ¡ exclusivamente Ã  autoridade judicial.',
'Ã‰ vedada a concessÃ£o de fianÃ§a em qualquer hipÃ³tese, mesmo pelo juiz de direito.',
'O fato Ã© considerado de menor potencial ofensivo, dispensando a lavratura de auto de prisÃ£o em flagrante.',
'O agressor Ã© imediatamente posto em liberdade caso a vÃ­tima nÃ£o compareÃ§a Ã  delegacia no mesmo dia.',
'B',
'Conforme o art. 24-A, Â§ 2Âº da Lei 11.340/2006, na hipÃ³tese de prisÃ£o em flagrante pelo descumprimento de medida protetiva, APENAS a autoridade judicial poderÃ¡ conceder fianÃ§a, sendo vedada ao Delegado de PolÃ­cia.'),

(8, 
'Nos termos da Nova Lei de Abuso de Autoridade (Lei nÂº 13.869/2019), para a configuraÃ§Ã£o de qualquer dos crimes nela previstos, exige-se elemento subjetivo especÃ­fico, consistente na intenÃ§Ã£o de:',
'Prejudicar outrem ou beneficiar a si mesmo ou a terceiro, ou, ainda, por mero capricho ou satisfaÃ§Ã£o pessoal.',
'Agir com negligÃªncia manifesta ou imprudÃªncia no manejo de armas e algemas.',
'Discordar fundamentadamente da jurisprudÃªncia predominante dos tribunais superiores.',
'Exercer as funÃ§Ãµes policiais com rigor tÃ©cnico e celeridade investigatÃ³ria.',
'Cumprir ordens superiores mesmo que aparentemente legais.',
'A',
'O art. 1Âº, Â§ 1Âº da Lei 13.869/2019 exige a finalidade especÃ­fica de prejudicar outrem, beneficiar a si ou a terceiro, ou mero capricho/satisfaÃ§Ã£o pessoal. O Â§ 2Âº aduz que a divergÃªncia na interpretaÃ§Ã£o da lei ou avaliaÃ§Ã£o de fatos NÃƒO configura abuso de autoridade (hermenÃªutica nÃ£o Ã© crime).'),

(8, 
'Configura crime de abuso de autoridade punido com detenÃ§Ã£o de 1 a 4 anos e multa (art. 22, III, Lei nÂº 13.869/2019) o cumprimento de mandado de busca e apreensÃ£o domiciliar no seguinte horÃ¡rio:',
'Entre 06h00 e 18h00.',
'ApÃ³s as 21h00 ou antes das 05h00.',
'Apenas entre 12h00 e 13h00 em dias Ãºteis.',
'A qualquer momento de domingos e feriados religiosos.',
'Entre 08h00 e 20h00.',
'B',
'O art. 22, inciso III da Lei 13.869/2019 tipifica a conduta de cumprir mandado de busca e apreensÃ£o domiciliar apÃ³s as 21h (vinte e uma horas) ou antes das 5h (cinco horas).'),

(8, 
'De acordo com a Lei nÂº 12.850/2013, considera-se OrganizaÃ§Ã£o Criminosa a associaÃ§Ã£o de:',
'2 (duas) ou mais pessoas estruturalmente ordenadas para a prÃ¡tica de contravenÃ§Ãµes penais.',
'3 (trÃªs) ou mais pessoas que se reÃºnam eventual ou esporadicamente para crimes patrimoniais.',
'4 (quatro) ou mais pessoas estruturalmente ordenada e caracterizada pela divisÃ£o de tarefas, com objetivo de obter vantagem mediante a prÃ¡tica de infraÃ§Ãµes cujas penas mÃ¡ximas sejam superiores a 4 anos ou que sejam de carÃ¡ter transnacional.',
'5 (cinco) ou mais pessoas com subordinaÃ§Ã£o armada e comando piramidal estrito.',
'Qualquer grupo de pessoas envolvidas em corrupÃ§Ã£o passiva e lavagem de capitais.',
'C',
'O art. 1Âº, Â§ 1Âº da Lei 12.850/2013 define: 4 ou mais pessoas estruturalmente ordenada e caracterizada pela divisÃ£o de tarefas, ainda que informalmente, com objetivo de obter vantagem mediante infraÃ§Ãµes penais com penas mÃ¡ximas superiores a 4 anos ou de carÃ¡ter transnacional.'),

(8, 
'Segundo o Estatuto do Desarmamento (Lei nÂº 10.826/2003), a conduta de "possuir ou manter sob sua guarda arma de fogo, acessÃ³rio ou muniÃ§Ã£o, de uso permitido, no interior de sua residÃªncia ou dependÃªncia desta, ou em seu local de trabalho desde que seja o titular ou responsÃ¡vel legal do estabelecimento", sem autorizaÃ§Ã£o legal, configura:',
'Porte ilegal de arma de fogo de uso permitido (art. 14).',
'Posse irregular de arma de fogo de uso permitido (art. 12).',
'ComÃ©rcio ilegal de arma de fogo e muniÃ§Ãµes (art. 17).',
'Disparo de arma de fogo em recinto habitado (art. 15).',
'Porte de arma de uso proibido (art. 16).',
'B',
'A arma mantida no interior da residÃªncia ou do local de trabalho (sendo titular/responsÃ¡vel legal) configura o crime de POSSE irregular de arma de fogo de uso permitido (art. 12). Se for fora desses locais (em via pÃºblica, no automÃ³vel, etc.), tipifica o PORTE ilegal (art. 14).'),

(8, 
'Em relaÃ§Ã£o Ã  Lei de Crimes Hediondos (Lei nÂº 8.072/1990), assinale a alternativa que indica um delito expressamente classificado no rol dos crimes hediondos:',
'Furto mediante fraude praticado por meio de dispositivo eletrÃ´nico.',
'Roubo circunstanciado pelo emprego de arma de fogo ou qualificado pelo resultado lesÃ£o corporal grave ou morte (latrocÃ­nio).',
'Estelionato praticado contra entidade de direito pÃºblico.',
'ApropriaÃ§Ã£o indÃ©bita previdenciÃ¡ria continuada.',
'ConcussÃ£o praticada por equipe policial de elite.',
'B',
'O art. 1Âº, II da Lei 8.072/1990 inclui expressamente no rol dos crimes hediondos o roubo circunstanciado pelo emprego de arma de fogo (art. 157, Â§ 2Âº-A, I e Â§ 2Âº-B) ou qualificado pelo resultado lesÃ£o corporal grave ou morte (latrocÃ­nio, art. 157, Â§ 3Âº).'),

(8, 
'Nos termos da Lei de Tortura (Lei nÂº 9.455/1997), a condenaÃ§Ã£o definitiva de um policial civil por crime de tortura acarreta, como efeito automÃ¡tico da sentenÃ§a:',
'SuspensÃ£o temporÃ¡ria do porte de arma durante o perÃ­odo de prova.',
'Perda do cargo, funÃ§Ã£o ou emprego pÃºblico e a interdiÃ§Ã£o para seu exercÃ­cio pelo dobro do prazo da pena aplicada.',
'RemoÃ§Ã£o de ofÃ­cio para delegacia de comarca de entrÃ¢ncia inicial.',
'Perda de 50% dos vencimentos brutos depositados em conta judicial.',
'Apenas advertÃªncia formal arquivada na corregedoria geral.',
'B',
'Conforme o art. 1Âº, Â§ 5Âº da Lei 9.455/1997: "A condenaÃ§Ã£o acarretarÃ¡ a perda do cargo, funÃ§Ã£o ou emprego pÃºblico e a interdiÃ§Ã£o para seu exercÃ­cio pelo dobro do prazo da pena aplicada". Ã‰ efeito automÃ¡tico e obrigatÃ³rio da sentenÃ§a condenatÃ³ria.'),

(8, 
'A autoridade policial que se omite em face das condutas tipificadas na Lei de Tortura, quando tinha o dever de evitÃ¡-las ou apurÃ¡-las (art. 1Âº, Â§ 2Âº da Lei nÂº 9.455/1997), responde por tortura por omissÃ£o, cuja pena cominada em lei Ã© de:',
'ReclusÃ£o de 4 a 10 anos e perda imediata de aposentadoria.',
'DetenÃ§Ã£o de um a quatro anos.',
'Pena de morte em caso de morte da vÃ­tima.',
'PrestaÃ§Ã£o pecuniÃ¡ria exclusiva de 10 a 50 salÃ¡rios mÃ­nimos.',
'ReclusÃ£o de 8 a 16 anos com regime fechado obrigatÃ³rio.',
'B',
'Na tortura por omissÃ£o ("aquele que se omite em face dessas condutas, quando tinha o dever de evitÃ¡-las ou apurÃ¡-las"), a pena Ã© substancialmente menor e de DETENÃ‡ÃƒO: 1 a 4 anos (art. 1Âº, Â§ 2Âº da Lei 9.455/97).'),

(8, 
'Com o advento da Lei nÂº 14.532/2023, a conduta de injuriar alguÃ©m ofendendo a dignidade ou o decoro em razÃ£o de raÃ§a, cor, etnia ou procedÃªncia nacional (antiga injÃºria racial do CP):',
'Foi tipificada na Lei de Crimes Resultantes de DiscriminaÃ§Ã£o ou Preconceito (Lei nÂº 7.716/1989), sendo agora equiparada ao racismo, imprescritÃ­vel e inafianÃ§Ã¡vel.',
'Teve sua pena reduzida para prestaÃ§Ã£o de serviÃ§os comunitÃ¡rios perante o JECRIM.',
'Foi totalmente revogada do direito brasileiro.',
'Passou a admitir fianÃ§a policial e transaÃ§Ã£o penal imediata.',
'Exige que a vÃ­tima tenha mais de 60 anos para configurar delito inafianÃ§Ã¡vel.',
'A',
'A Lei 14.532/2023 inseriu a injÃºria racial no art. 2Âº-A da Lei 7.716/1989, com pena de 2 a 5 anos de reclusÃ£o, tornando-a expressamente equiparada aos crimes de racismo, sendo inafianÃ§Ã¡vel e imprescritÃ­vel (CF, art. 5Âº, XLII).'),

(8, 
'No que tange Ã  Lei de Lavagem de Dinheiro (Lei nÂº 9.613/1998 com redaÃ§Ã£o da Lei nÂº 12.683/2012), a persecuÃ§Ã£o penal do delito de lavagem de capitais:',
'Depende da prÃ©via e definitiva condenaÃ§Ã£o transitada em julgado pelo crime antecedente.',
'Ã‰ autÃ´noma e independe do processo e julgamento das infraÃ§Ãµes penais antecedentes, bastando a existÃªncia de indÃ­cios suficientes da prÃ¡tica de infraÃ§Ã£o penal antecedente.',
'Exige que a infraÃ§Ã£o antecedente seja exclusivamente crime contra a administraÃ§Ã£o pÃºblica ou trÃ¡fico internacional.',
'SÃ³ pode ser instaurada se os valores ocultados superarem o montante de um milhÃ£o de reais.',
'Ã‰ de competÃªncia privativa e improrrogÃ¡vel da JustiÃ§a Militar da UniÃ£o.',
'B',
'O art. 2Âº, II da Lei 9.613/1998 estabelece a plena autonomia do processo e julgamento dos crimes de lavagem, ainda que praticados em outro paÃ­s, bastando a constataÃ§Ã£o de indÃ­cios suficientes da existÃªncia da infraÃ§Ã£o penal antecedente.'),

(8, 
'De acordo com o CÃ³digo de TrÃ¢nsito Brasileiro (Lei nÂº 9.503/1997), o crime de conduzir veÃ­culo automotor com capacidade psicomotora alterada em razÃ£o da influÃªncia de Ã¡lcool ou de outra substÃ¢ncia psicoativa (art. 306, CTB):',
'Ã‰ crime de dano concreto, exigindo colisÃ£o comprovada ou lesÃ£o a terceiros.',
'Ã‰ crime de perigo abstrato, configurando-se com a simples conduÃ§Ã£o do veÃ­culo naquelas condiÃ§Ãµes, dispensando a demonstraÃ§Ã£o de perigo concreto de dano a terceiros.',
'Exige obrigatoriamente a realizaÃ§Ã£o de teste de etilÃ´metro (bafÃ´metro), sendo nulo qualquer exame clÃ­nico ou prova testemunhal.',
'SÃ³ pode ser apurado se cometido em rodovias federais policiadas pela PRF.',
'Extingue a punibilidade se o motorista entregar a direÃ§Ã£o a passageiro habilitado.',
'B',
'O STJ fixou em sede de recurso repetitivo (Tema 430) e sÃºmula que o crime do art. 306 do CTB Ã© de perigo abstrato, dispensando a comprovaÃ§Ã£o de perigo real a terceiros, e os meios de prova admitem teste de etilÃ´metro, perÃ­cia, exame clÃ­nico ou testemunhas com vÃ­deos.'),

(8, 
'A infiltraÃ§Ã£o de agentes de polÃ­cia em tarefas de investigaÃ§Ã£o no Ã¢mbito da Lei nÂº 12.850/2013 (OrganizaÃ§Ãµes Criminosas):',
'Pode ser determinada informalmente e de ofÃ­cio pela prÃ³pria equipe tÃ¡tica da delegacia.',
'Depende de representaÃ§Ã£o do Delegado de PolÃ­cia ou requerimento do MinistÃ©rio PÃºblico, necessitando de prÃ©via e motivada autorizaÃ§Ã£o judicial, que estabelecerÃ¡ seus limites.',
'NÃ£o admite a infiltraÃ§Ã£o de policiais em ambiente virtual (redes sociais e internet).',
'Exime o agente infiltrado de responsabilidade penal por qualquer homicÃ­dio doloso praticado durante a operaÃ§Ã£o.',
'Pode perdurar por prazo indeterminado sem necessidade de relatÃ³rios periÃ³dicos.',
'B',
'Conforme os arts. 10 e seguintes da Lei 12.850/2013, a infiltraÃ§Ã£o de agentes (fÃ­sica ou virtual - art. 10-A) depende de representaÃ§Ã£o do delegado ou requerimento do MP e EXIGE autorizaÃ§Ã£o judicial motivada, sigilosa e com prazo de atÃ© 6 meses renovÃ¡veis.'),

(8, 
'No Estatuto da CrianÃ§a e do Adolescente (Lei nÂº 8.069/1990), o adolescente apreendido em flagrante de ato infracional anÃ¡logo a crime cometido com grave ameaÃ§a ou violÃªncia Ã  pessoa:',
'Pode ser internado provisoriamente por decisÃ£o fundamentada da autoridade judiciÃ¡ria competente pelo prazo mÃ¡ximo e improrrogÃ¡vel de 45 dias.',
'Deve ser imediatamente liberado sem qualquer intervenÃ§Ã£o do MinistÃ©rio PÃºblico.',
'Pode permanecer custodiado em cela comum junto com maiores de idade por atÃ© 30 dias.',
'Fica sujeito Ã  pena de reclusÃ£o de atÃ© 8 anos em estabelecimento prisional comum.',
'Ã‰ submetido compulsoriamente a trabalho forÃ§ado para ressarcimento da vÃ­tima.',
'A',
'O art. 108 do ECA estipula expressamente que a internaÃ§Ã£o provisÃ³ria de adolescente pode ser decretada pelo juiz pelo prazo mÃ¡ximo e improrrogÃ¡vel de 45 (quarenta e cinco) dias, devendo a decisÃ£o ser devidamente fundamentada e baseada em indÃ­cios suficientes de autoria e materialidade.');
-- ==============================================================================
-- QUESTOES EXTRAIDAS DAS APOSTILAS DA PC PR (BANCA FGV / CONCURSOS)
-- Total de questoes: 262
-- ==============================================================================
USE pcpr_simulados;

INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
IBFC – 2023
Observando os direitos fundamentais em perspectiva histórico-evolutiva e as denominadas dimensões ou gerações de direitos fundamentais, analise as afirmativas abaixo.
I. Os direitos fundamentais da terceira geração são também denominados direitos de fraternidade ou de solidariedade.
II. São exemplos de direitos de segunda geração o direito à paz e à autodeterminação dos povos.
III. Os direitos fundamentais de primeira geração são caracterizados como direitos de caráter negativo e exemplificados, entre outros, pelo direito à vida, à liberdade de expressão, à saúde e à educação.
IV. A posição doutrinária que busca utilizar o termo “dimensões”, em substituição ao termo “gerações”, visa, entre outros, afastar a falsa impressão de substituição de uma geração por outra.
Assinale a alternativa correta.', 'Apenas as afirmativas I e II estão corretas', 'Apenas as afirmativas I e IV estão corretas', 'Apenas as afirmativas II e IV estão corretas', 'Apenas as afirmativas II e III estão corretas', 'Nenhuma das anteriores (N.D.A.)', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 02. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2024
Quanto ao poder constituinte, aos direitos e deveres individuais e coletivos e aos direitos políticos, julgue o item a seguir.
A segunda geração (ou dimensão) dos direitos fundamentais compreende os direitos sociais, cujo desenvolvimento se deveu, entre outras causas, à pressão de movimentos sociais.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'VUNESPE – 2024', 'No que se refere aos direitos fundamentais, assinale a alternativa correta.', 'Compreendem os direitos fundamentais de primeira geração ou dimensão, os direitos civis e políticos, cujo titular é o indivíduo. Compreendem os direitos de segunda geração (ou dimensão) os direitos sociais, culturais e econômicos, bem como os direitos coletivos ou de coletividades.', 'Os direitos fundamentais de primeira geração ou dimensão são apenas o direito à vida e à liberdade. Os direitos de segunda geração ou dimensão são os destinados à coletividade e à fraternidade, albergando o princípio da solidariedade, como, por exemplo, o direito ao meio ambiente, à paz e ao progresso.', 'Os direitos fundamentais de primeira geração ou dimensão são apenas o direito à vida, à liberdade e ao voto. Os direitos de segunda geração ou dimensão são os direitos à moradia digna, ao transporte de qualidade e ao trabalho.', 'Os direitos fundamentais de primeira geração ou dimensão constituem apenas o direito à vida e à liberdade. Os direitos de segunda geração ou dimensão são os direitos relacionados ao bem-estar social.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FAURGS – 2022
Os direitos fundamentais, entre todas as suas classificações, têm aquela embasada nas diversas dimensões/gerações. Qual o direito descrito como sendo de primeira dimensão/geração?', 'Liberdade.', 'Igualdade material e formal.', 'Solidariedade.', 'Engenharia genética.', 'Paz mundial.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'VUNESP – 2022', 'A história dos direitos fundamentais pode ser dividida em gerações, também conhecidas como dimensões. Cada geração ou dimensão é produto de processos de lutas e reivindicações, que culminaram na incorporação, pelos textos constitucionais, de direitos invocados pela coletividade. A terceira geração ou dimensão tem início no período posterior ao pós-Segunda Guerra Mundial, ou seja, a partir da segunda metade do século XX. Assinale o direito fundamental que corresponde a esse período.', 'Democracia.', 'Liberdade.', 'Proteção jurídica do patrimônio genético.', 'Meio ambiente ecologicamente equilibrado.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 02. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
FGV– 2024
Sobre os direitos e garantias fundamentais no país, analise as afirmativas a seguir.
I. Uma das implicações do direito à vida é a proibição constitucional da pena de morte, a menos de guerra declarada pelo Presidente da República e autorizada pelo Congresso Nacional. II. O direito à propriedade privada também é um direito fundamental. Desse modo, não há possibilidade constitucional de desapropriação. III. O direito à liberdade se estende à liberdade de pensamento e de expressão artística, intelectual ou de comunicação.
Está correto o que se afirma em', 'I, apenas.', 'II, apenas.', 'I e II, apenas.', 'I e III, apenas.', 'I, II e III.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 04. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2024
Na Constituição Federal de 1988, a cidadania é tratada como um dos pilares do Estado Democrático de Direito, assegurando a todos os brasileiros o exercício pleno de seus direitos, ao mesmo tempo em que reforça a importância do engajamento cívico e do cumprimento das obrigações como parte integrante da convivência democrática.
Assinale a opção que apresenta um dever do cidadão.', 'Contribuir para a previdência social apenas de forma facultativa, sem obrigação legal.', 'Votar nas eleições municipais e estaduais, sendo este um dever facultativo para todos os cidadãos.', 'Participar obrigatoriamente de movimentos sociais e políticos de forma ativa.', 'Respeitar as leis somente quando elas se alinham aos interesses pessoais e ideológicos.', 'Cumprir com as obrigações militares, nos termos da lei, para os cidadãos do sexo masculino.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 04. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2024
Em relação às características e natureza dos direitos fundamentais, é correto afirmar que:', 'direitos fundamentais são instrumentos de natureza processual e assecuratória que visam a assegurar o respeito devido aos valores constitucionais;', 'direitos fundamentais são absolutos, visto que irrenunciáveis pelo titular;', 'direitos fundamentais incidem também na relação entre cidadãos e não apenas nas relações com o Estado;', 'a indivisibilidade dos direitos fundamentais significa que eles não podem ser objeto de operações de venda, troca, empréstimo ou doação;', 'os direitos fundamentais no Brasil são garantidos aos brasileiros e aos estrangeiros residentes no país, não se aplicando a estrangeiros não residentes.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 04. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2024
Em relação aos direitos e às garantias fundamentais na Constituição Federal de 1988, julgue o item que se segue.
O rol de direitos e garantias fundamentais constitucionais é exemplificativo.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2024
Pedro foi preso em flagrante, mas alegou que sua prisão foi ilegal porque não houve comunicação imediata da sua prisão à sua família e à autoridade judiciária competente.
Nessa situação hipotética, entre os direitos fundamentais, Pedro teve violado o direito', 'à segurança.', 'à propriedade.', 'à liberdade de expressão.', 'à intimidade.', 'ao devido processo legal.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 04. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2024
Se uma empresa decidir não contratar mulheres para determinadas funções sob a alegação, equivocada, de que tais funções são inadequadas para elas, tal fato caracterizará violação, pela empresa, do princípio constitucional da', 'legalidade.', 'igualdade.', 'dignidade da pessoa humana.', 'segurança jurídica.', 'eficiência.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 04. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
CESPE/ CEBRASPE– 2004
No que se refere a princípios, direitos e garantias fundamentais, julgue o item a seguir.
O direito de escusa de consciência está adstrito exclusivamente ao serviço militar quando se trata de crença religiosa, convicção filosófica ou religiosa.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 05. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2021
Clara, praticante de uma religião de matriz africana, um dia, ao chegar à escola pública em que estuda no Distrito Federal usando um colar de contas típico de sua prática religiosa, foi impedida, pela diretora, de entrar na instituição. A diretora alegou que, ali, não era permitido entrar usando aquele tipo de colar. Na ocasião, a diretora exigiu que a estudante retirasse o adereço para poder entrar no estabelecimento de ensino.
Considerando essa situação hipotética, julgue o item a seguir.
Embora o livre exercício de cultos religiosos seja assegurado pela Constituição da República Federativa do Brasil, como o Estado é laico, o ingresso de Clara com adereços religiosos em sua escola pode ser proibido.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 05. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'VUNESP – 2013
Sobre a liberdade religiosa, é correto afirmar:', 'a imunidade tributária em favor das entidades religiosas alcança os imóveis de sua propriedade isentando-as do IPTU, mas não as isentam desse tipo de tributo se o mesmo imóvel estiver alugado.', 'a liberdade de religião não inclui a liberdade de organização religiosa, estando o poder público autorizado a impor a igualdade de sexos em entidades que interna­ mente não a contemplem.', 'o STF já decidiu que a proteção constitucional das entidades religiosas se estende às seitas religiosas e também à maçonaria.', 'a exibição de crucifixo ou de imagens sagradas em lugares públicos é vedada pela Constituição, tendo em vista que os princípios que regem o Estado laico não admitem essa conduta', 'os cemitérios que consubstanciam extensões de entidades de cunho religioso estão abrangidos pela garantia constitucional da imunidade tributária.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 05. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2019
O Deputado Federal João apresentou projeto de lei dispondo sobre a prestação de assistência religiosa em prisões, a ser ofertada pelas confissões religiosas e sem custo para o Poder Público. Após o curso regular do processo legislativo, foi promulgada a Lei nº XX/2019.
À luz da sistemática estabelecida pela Constituição da República de 1988, a referida Lei é:', 'incompatível com a ordem constitucional, pois o caráter laico do Estado impede a assistência religiosa nas prisões;', 'compatível com a ordem constitucional, pois esse tipo de assistência religiosa, nos termos da lei, é um direito fundamental;', 'incompatível com a ordem constitucional, pois o projeto de lei somente poderia ter sido apresentado pelo Presidente da República;', 'compatível com a ordem constitucional, desde que a assistência religiosa seja simultaneamente oferecida, a cada preso, por todas as religiões existentes;', 'incompatível com a ordem constitucional, pois as pessoas privadas de liberdade em estabelecimentos de internação coletiva não têm direito a assistência religiosa.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 05. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2024
À luz da jurisprudência do Supremo Tribunal Federal, julgue o item a seguir, referente aos direitos individuais e coletivos previstos na Constituição Federal de 1988.
Violaria o direito à liberdade religiosa e o princípio da laicidade do Estado lei estadual que obrigasse à manutenção de exemplar de determinado livro de cunho religioso em unidades escolares e bibliotecas públicas estaduais.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 05. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
QUADRIX– 2017
A manifestação do pensamento, a criação, a expressão e a informação, sob qualquer forma, processo ou veículo, não sofrerão restrições segundo a CF. Considerando essa informação, julgue o item subsequente.
É permitida a censura de natureza política e ideológica, sendo vedada a censura de natureza artística.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 06. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'OBJETIVA – 2023
Em conformidade com a Constituição Federal, é vedada a:
I. Pena de morte.
II. Censura.
III. Criação de associações.
Está(ão) CORRETO(S):', 'Somente o item II.', 'Somente os itens I e II.', 'Somente os itens I e III.', 'Somente os itens II e III.', 'Todos os itens.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 06. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2014
Ao longo de sua história e de forma gradual, o Brasil construiu os mecanismos responsáveis pelas garantias fundamentais que hoje resguardam todos os cidadãos. Este processo evolutivo atingiu seu auge com a Carta Magna de 1988, que completou trinta anos em 5 de outubro de 2018.
No mundo, esses direitos e deveres ganharam destaque, pela primeira vez, com a Constituição dos Estados Unidos, de 1787, e com a promulgação, dois anos mais tarde, na França, da Declaração dos Direitos do Homem e do Cidadão. Com o tempo, eles foram adaptados às realidades das nações ao redor do globo.
A Constituição Cidadã apresenta uma série de regras voltadas aos direitos e deveres individuais e coletivos.  Reunidos no artigo 5.º, eles estão fundamentados pelo seguinte princípio: “Todos são iguais perante a lei, sem distinção de qualquer natureza, garantindo‐se aos brasileiros e aos estrangeiros residentes no País a inviolabilidade do direito à vida, à liberdade, à igualdade, à segurança e à propriedade”.
Internet: <www2.planalto.gov.br> (com adaptações).
Com relação aos direitos e às garantias fundamentais, julgue o item de acordo com o texto constitucional de 1988.
A expressão da atividade intelectual é livre, independentemente de censura ou licença.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 06. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'IGEDUC – 2024
Julgue o item subsequente.
De acordo com a Constituição de 1988, é assegurado a todos o direito à liberdade de expressão, sem censura, exceto em casos previstos em lei, como forma de proteger outros direitos igualmente importantes.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 06. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'IBADE – 2022
Analise as assertivas e responda.
I – Intelectual.
II – Artística.
III – Científica.
IV – de Comunicação.
À luz da Constituição Federal de 1988, é CORRETO afirmar que, das assertivas dispostas, são atividades que independem de censura ou licença:', 'I, II e III.', 'II, III e IV.', 'I, III e IV.', 'I, II e IV.', 'I, II, III e IV.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 06. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
A garantia constitucional da inviolabilidade domiciliar', 'abrange não só a residência dos indivíduos, mas também seu local de trabalho.', 'impede que se preste socorro no interior de residência, se houver discordância do morador à entrada de pessoas.', 'dirige-se apenas a autoridades e agentes públicos, não a pessoas privadas.', 'não se aplica, durante dia e noite, no caso de cumprimento de ordem judicial.', 'deve ser observada, mesmo quando houver concordância do morador ao ingresso em seu domicílio.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 07. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/ CEBRASPE– 2022
Assinale a opção que contempla o entendimento do STF e do STJ acerca da inviolabilidade de domicílio.', 'A mera intuição do agente policial acerca de ocorrência de tráfico de entorpecentes autoriza o ingresso na residência do suspeito, sem mandado judicial ou consentimento do morador.', 'A ausência de mandado judicial invalida busca e apreensão em apartamento desabitado.', 'Em caso de dúvida, incumbe ao suspeito a prova de ilegalidade do consentimento para ingresso policial na sua residência.', 'A entrada forçada em residência, quando não justificada, sujeita o agente policial à responsabilidade disciplinar, civil e penal.', 'É ilícita a entrada de policiais, sem autorização judicial e sem consentimento do hóspede, em quarto de hotel, ainda que presentes razões que evidenciem ocorrência de flagrante.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 07. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRAPE – 2009
A CF estabelece a garantia da inviolabilidade domiciliar, porém autoriza a violação do lar durante o período noturno', 'por meio de determinação judicial.', 'por meio de autorização ou determinação do MP.', 'para cumprimento de diligência policial.', 'em caso de desastre.', 'em caso de descumprimento de lei.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 07. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2017
A Constituição Federal de 1988 (CF) simboliza, sob o ponto de vista jurídico-político, a consumação do processo de reconstrução democrática do Brasil. Direitos humanos e direitos fundamentais nela foram inscritos com tal vigor que lhe renderam a denominação de Constituição Cidadã. É nessa perspectiva de fortalecimento do espírito de cidadania que se devem situar programas, instituições e organismos como o terceiro Programa Nacional de Direitos Humanos (PNDH–3), a PNPS, o SNPS, o Conselho Nacional de Política Criminal e Penitenciária e o Conselho Penitenciário.
De acordo com os dispositivos constitucionais que abordam os direitos humanos e os direitos fundamentais, e considerando os objetivos e as diretrizes dos programas e órgãos acima mencionados, julgue o item subsequente.
A inviolabilidade da correspondência e das comunicações, sejam elas telegráficas, de dados ou telefônicas, constitui direito individual fundamental, razão por que o texto constitucional veda o reconhecimento de exceções ao exercício desse direito.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 07. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2017', 'Embora a CF preveja a inviolabilidade das comunicações telefônicas, é admitida a interceptação das comunicações telefônicas, na forma da lei, para fins de investigação criminal ou', 'instrução processual penal, mediante autorização judicial, ou investigação de ato de improbidade administrativa, por determinação do Ministério Público.', 'instrução processual penal, mediante autorização judicial, por determinação de comissão parlamentar de inquérito regularmente instaurada, ou investigação de ato de improbidade administrativa, por determinação do Ministério Público.', 'instrução processual penal, mediante autorização judicial.', 'instrução processual penal, mediante autorização judicial, ou por determinação de comissão parlamentar de inquérito regularmente instaurada.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 07. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
Antony, estrangeiro não domiciliado no Brasil, encontrava-se de férias no país, hospedado em um hotel no Rio de Janeiro. Um agente de polícia que se encontrava no mesmo hotel desconfiou do comportamento de Antony, que andava sempre preocupado, olhando para os lados, então resolveu ingressar no quarto de hotel onde Antony estava hospedado.
A partir dessa situação hipotética, julgue o item seguinte de acordo com a jurisprudência do STF.
Para fins da inviolabilidade domiciliar, o quarto de hotel, desde que ocupado, é equiparado a domicílio, razão pela qual não é permitido o ingresso do agente sem a permissão de Antony, salvo em caso de flagrante delito ou desastre, ou para prestar socorro, ou, durante o dia, por determinação judicial.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 08. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2023
Considerando o princípio da dignidade da pessoa humana e o rol de direitos fundamentais estabelecido na CF, além da doutrina e da jurisprudência a respeito da matéria, julgue o item subsequente.
Não obstante a previsão constitucional de inviolabilidade da casa do indivíduo, é permitido nela adentrar, a qualquer hora do dia ou da noite, para o cumprimento de mandado judicial que tenha decretado prisão preventiva.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 08. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2014
Suponha que, em determinada operação policial, entenda ser necessária a entrada forçada em domicílio de determinada pessoa, com a realização de busca e apreensão, no período noturno, sem mandado judicial, por supostamente estar ocorrendo situação de flagrante delito. Nessa situação, as razões para a entrada domiciliar devem ser justificadas', 'a posteriori, e, se consideradas ilícitas, haverá responsabilidade disciplinar e penal da autoridade policial, embora os atos praticados sejam considerados válidos.', 'a posteriori, e, se consideradas ilícitas, haverá responsabilidade disciplinar, civil e penal da autoridade policial, e os atos praticados serão considerados nulos.', 'antes da entrada, e, se consideradas ilícitas, os atos praticados serão considerados nulos, e a autoridade policial deverá responder disciplinarmente, mas não na esfera civil ou penal.', 'antes da entrada, e, se consideradas ilícitas, a autoridade policial deverá responder civil e penalmente, ainda que os atos praticados sejam considerados válidos.', 'antes da entrada, e, se consideradas ilícitas, haverá responsabilidade disciplinar, civil e penal da autoridade policial, embora os atos praticados sejam considerados válidos.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 08. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
FGV– 2017
Sobre os direitos dos cidadãos, avalie as afirmativas a seguir.
I. É livre o exercício de qualquer trabalho, ofício ou profissão, atendidas as qualificações profissionais que a lei estabelecer.
II. É assegurado a todos o acesso à informação, resguardado o sigilo da fonte quando necessário ao exercício profissional.
III. É livre a locomoção no território nacional em tempo de paz, podendo qualquer pessoa, nos termos da lei, nele entrar, permanecer ou dele sair com seus bens.
Está correto o que se afirma em:', 'I, somente.', 'I e II, somente.', 'I e III, somente.', 'II e III, somente.', 'I, II e III.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 09. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'VUNESP – 2019
A Constituição Federal assegura que todos são iguais perante a lei, sem distinção de qualquer natureza, garantindo-se aos brasileiros e aos estrangeiros residentes no País a inviolabilidade do direito à vida, à liberdade, à igualdade, à segurança e à propriedade, e também é', 'assegurada, nos termos da lei, a prestação de assistência religiosa nas entidades civis e vedada nas entidades militares de internação coletiva.', 'livre a manifestação do pensamento, ainda que sob o anonimato.', 'assegurado o direito de resposta, proporcional ao agravo, prejudicada a indenização por dano material.', 'assegurado a todos o acesso à informação e resguardado o sigilo da fonte, quando necessário ao exercício profissional.', 'livre a expressão da atividade intelectual, artística, científica e de comunicação, condicionada a licença prévia.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 09. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2013
Em relação aos princípios fundamentais e aos direitos e garantias fundamentais estabelecidos na Constituição Federal de 1988 (CF), julgue os itens que se seguem.
O acesso à informação é um direito fundamental de todos, devendo os órgãos e entidades públicas disponibilizar informações de interesse coletivo ou de interesse particular do solicitante, ressalvadas as informações que sejam imprescindíveis à segurança da sociedade e do Estado ou as que violem o direito à privacidade.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 09. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2024
Todos são iguais perante a lei, sem distinção de qualquer natureza, garantindo-se aos brasileiros e aos estrangeiros residentes no País a inviolabilidade do direito à vida, à liberdade, à igualdade, à segurança e à propriedade.
Entre os direitos e deveres individuais e coletivos, constantes na Constituição da República Federativa do Brasil de 1988, encontra-se pertinente que', 'é livre a manifestação do pensamento, sendo consentido o anonimato.', 'ninguém é obrigado a fazer ou deixar de fazer alguma coisa senão em virtude de lei.', 'a casa é asilo inviolável do indivíduo, ninguém nela podendo penetrar em hipótese alguma.', 'é violável o sigilo da correspondência e das comunicações telegráficas, de dados e das comunicações telefônicas.', 'é assegurado a todos o acesso à informação e divulgação da fonte.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 09. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
João nasceu em Atenas, Grécia, e é fruto do relacionamento entre Maria (brasileira) e John (estadunidense) e, desde 2022, passou a residir no Brasil, após ter adquirido uma propriedade particular no estado do Rio de Janeiro. Em 2023, ao completar 21 anos de idade, João optou pela nacionalidade brasileira.
Considerando a situação hipotética apresentada, julgue o item a seguir.
É garantido a João o direito de propriedade, podendo tal propriedade ser utilizada pela autoridade competente na hipótese de iminente perigo público, assegurada indenização ulterior a João, se houver dano.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 10. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2024
O casal de lavradores, Maria e João, é proprietário de uma pequena propriedade rural. Apesar de não contar com empregados, a eficiência das técnicas utilizadas na propriedade não só permitia que suas necessidades de subsistência fossem atendidas como ainda possibilitava a comercialização do excedente. Em razão dos débitos decorrentes de sua atividade produtiva, o que ocorrera em razão de intempéries climáticas, tinha receio da possibilidade de sua propriedade ser penhorada.
À luz dessa narrativa, é correto afirmar que a penhora:', 'é possível, já que o débito decorreu da atividade produtiva;', 'é possível, considerando que a produção não é destinada apenas à subsistência;', 'não é possível, considerando a natureza e a dimensão da propriedade, bem como a mão de obra utilizada;', 'não é possível, o que decorre apenas da natureza da propriedade, independentemente da natureza do débito;', 'é possível, desde que a propriedade tenha dimensão superior à do módulo rural, devendo ser assegurada a purga da mora.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 10. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'FGV – 2014
Em relação à reforma agrária, ao meio ambiente e aos povos indígenas, julgue o item que se segue.
Descumprida a função social da propriedade, a invocação da garantia constitucional do direito de propriedade não é meio hábil a evitar desapropriação de imóvel rural para fins de reforma agrária.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 10. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2023
Considerando os direitos e as garantias fundamentais, julgue o item que se segue.
Na hipótese de governador de estado ter determinado o uso emergencial de propriedade particular por causa de iminente e grave perigo público, após a devolução da propriedade pelo ente público, o proprietário poderá pleitear indenização, desde que tenha havido dano à propriedade.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 10. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (5, 'CESPE/CEBRASPE – 2022
O direito de propriedade não se reveste de caráter absoluto, eis que, sobre ele, pesa grave hipoteca social, a significar que, descumprida a função social que lhe é inerente (CF, art. 5.º, XXIII), legitimar-se-á a intervenção estatal na esfera dominial privada, observados, contudo, para esse efeito, os limites, as formas e os procedimentos fixados na própria Constituição da República.
Brasil. Supremo Tribunal Federal. Ação direta de inconstitucionalidade n.º 2213-MC,  relator: min. Celso de Mello. Diário da Justiça da União, 23 abr. 2004.
Tendo como referência o fragmento de texto precedente, julgue os próximos itens, relativos à função social da propriedade.
I Poderá ser objeto de desapropriação por interesse social para fins de reforma agrária o imóvel rural que não esteja cumprindo sua função social.
II Não cumpre a função social o imóvel rural que não mantém níveis satisfatórios de produtividade.
III A propriedade rural cumpre sua função social se estiver em conformidade com o plano diretor do município em que estiver inserida.
Assinale a opção correta.', 'Apenas o item II está certo.', 'Apenas o item III está certo.', 'Apenas os itens I e II estão certos.', 'Apenas os itens I e III estão certos.', 'Todos os itens estão certos.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Constitucional - Aula 10. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
Acerca de coação e obediência hierárquica, assinale a opção correta.', 'A coação à prática de crime doloso, seja ela moral ou física, exclui a culpabilidade do agente, que não deve ser punido pelo crime.', 'Tanto o agente que pratica crime doloso em decorrência de coação quanto aquele que o pratica em obediência a ordem de superior hierárquico agem sob a proteção de uma excludente de culpabilidade, independentemente das circunstâncias dos crimes.', 'O agente que pratica crime doloso em cumprimento a uma ordem de seu superior hierárquico não poderá ser responsabilizado pela conduta criminosa.', 'A coação à prática de crime doloso pode tanto excluir a culpabilidade do agente quanto servir para agravar a pena do coator.', 'A coação à prática de crime doloso só é reconhecida como excludente de culpabilidade se a ameaça envolver violência física.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
Acerca da ilicitude e da culpabilidade no direito penal, julgue o item que se segue.
O excesso acidental ou fortuito é penalmente irrelevante, ao passo que o excesso inconsciente, também denominado exculpante, decorre de profunda alteração de ânimo do agente e exclui sua culpabilidade por inexigibilidade de conduta diversa.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
A respeito dos elementos do crime e seus aspectos fundamentais, julgue o item seguinte.
A culpabilidade é um juízo de reprovabilidade e refere-se à capacidade do agente, porquanto só pode ser culpado aquele que tiver a capacidade de entender a ilicitude do seu comportamento, ainda que seja incapaz de exercer controle sobre suas ações.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Considera-se causa excludente da culpabilidade', 'inexigibilidade de conduta diversa.', 'estado de necessidade.', 'consentimento do ofendido.', 'estrito cumprimento do dever legal.', 'exercício regular de direito.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Considerando aspectos diversos do direito penal, assinale a opção correta.', 'A inimputabilidade penal devidamente comprovada resultará em redução da pena, independentemente do crime praticado.', 'O coautor que quis participar de crime menos grave terá sua punição limitada às penas deste, independentemente da previsibilidade do resultado do delito que foi de fato praticado pelos demais autores.', 'Age em estado de necessidade quem repele injusta agressão, atual ou iminente, a direito seu ou de outrem, usando moderadamente dos meios necessários.', 'O agente que com suas ações praticar vários crimes da mesma espécie e que, pelas condições de tempo, lugar e modo de execução, forem havidos como continuação um do outro terá suas penas somadas.', 'A inexigibilidade de conduta diversa exclui a culpabilidade, pois haverá um fato típico e ilícito, mas que não merece ser punido, por não ser exigível do autor, naquelas circunstâncias, outro comportamento.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Foi atribuída a um cidadão a autoria de um homicídio, não se encontrando o agente acobertado por nenhuma justificativa.
Nessa situação hipotética, conforme a teoria da culpabilidade adotada pelo ordenamento jurídico penal brasileiro, o fato será', 'culpável se demonstrado o dolo ou a culpa do agente, principais elementos da culpabilidade.', 'considerado culpável se o agente, ao tempo do crime, tiver agido sob influência de violenta emoção provocada por ato injusto da vítima.', 'culpável se demonstrada a ilicitude da conduta do agente, elemento intrínseco da culpabilidade.', 'culpável se o agente, ao tempo do crime, fosse imputável, detivesse potencial consciência da ilicitude e não lhe fosse exigido outro comportamento.', 'considerado culpável se o agente tiver atuado sem a consciência da ilicitude do fato, sem que lhe fosse possível ter ou atingir esse conhecimento.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2021
Coação moral irresistível é causa de', 'exclusão de antijuricidade.', 'exclusão da punibilidade.', 'exclusão da culpabilidade.', 'diminuição da pena.', 'exclusão da tipicidade.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2021
Com relação a aspectos gerais do direito penal brasileiro, julgue o item a seguir.
A obediência hierárquica afasta a potencial consciência da ilicitude.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal  - Aula 11. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/ CEBRASPE– 2018
O princípio da legalidade compreende', 'a capacidade mental de entendimento do caráter ilícito do fato no momento da ação ou da omissão, bem como de ciência desse entendimento.', 'o juízo de censura que incide sobre a formação e a exteriorização da vontade do responsável por um fato típico e ilícito, com o propósito de aferir a necessidade de imposição de pena.', 'a oposição entre o ordenamento jurídico vigente e um fato típico praticado por alguém capaz de lesionar ou expor a perigo de lesão bens jurídicos penalmente protegidos.', 'a obediência às formas e aos procedimentos exigidos na criação da lei penal e, principalmente, na elaboração de seu conteúdo normativo.', 'a conformidade da conduta reprovável do agente ao modelo descrito na lei penal vigente no momento da ação ou da omissão.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito penal - Aula  01. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2021
Observando as afirmações sobre os princípios constitucionais penais, marque a alternativa INCORRETA:', 'O princípio da legalidade veda a existência de crime sem lei que o defina e impede a existência de pena sem cominação legal.', 'O princípio da anterioridade permite que o fato praticado anteriormente à vigência da lei penal que o define como crime seja punido.', 'O princípio da legalidade ou da reserva legal impede a criação de crimes e a cominação de penas por medidas provisórias.', 'O princípio da lesividade ou da exclusiva proteção de bens jurídicos impede que a lei consagre como crime fato que não acarrete lesão ou perigo de lesão a bem jurídico de terceiro.', 'Tipos penais que não definem com clareza o fato proibido, tornando-o evidente, violam o princípio da legalidade.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito penal - Aula  01. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2014
O Presidente da República, diante da nova onda de protestos, decide, por meio de medida provisória, criar um novo tipo penal para coibir os atos de vandalismo. A medida provisória foi convertida em lei, sem impugnações.
Com base nos dados fornecidos, assinale a opção correta.', 'Não há ofensa ao princípio da reserva legal na criação de tipos penais por meio de medida provisória, quando convertida em lei.', 'Não há ofensa ao princípio da reserva legal na criação de tipos penais por meio de medida provisória, pois houve avaliação prévia do Congresso Nacional.', 'Há ofensa ao princípio da reserva legal, pois não é possível a criação de tipos penais por meio de medida provisória.', 'Há ofensa ao princípio da reserva legal, pois não cabe ao Presidente da República a iniciativa de lei em matéria penal.', 'Nenhuma das anteriores (N.D.A.)', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito penal - Aula  01. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2021
Acerca dos princípios constitucionais penais, julgue o item subsequente.
Violam o princípio da taxatividade as chamadas normas penais em branco, independentemente de serem elas homólogas ou heterólogas.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito penal - Aula  01. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2018
Acerca dos princípios da legalidade e da anterioridade insculpidos no art. 1° do Código Penal e no art. 5° , XXXIX, da Constituição Federal, analise as alternativas a seguir e assinale a correta:', 'Uma das funções do princípio da legalidade é permitir a criação de crimes e penas pelos usos e costumes.', 'No Brasil, em um primeiro momento, a União Federal pode legislar sobre matéria penal. No entanto, de forma indireta e urgente, leis estaduais podem impor regras e sanções de natureza criminal.', 'A lei penal incriminadora somente pode ser aplicada a um fato concreto desde que tenha tido origem antes da prática da conduta. Em situações temporárias e excepcionais, no entanto, admite-se a mitigação do princípio da anterioridade.', 'Desdobramento do princípio da legalidade é o da taxatividade, que impede a edição de tipos penais genéricos e indeterminados.', 'O princípio da legalidade afasta a aplicação da interpretação extensiva, mas permite a aplicação da analogia de forma ampla e irrestrita.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito penal - Aula  01. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
Julgue o item seguinte, relativo à aplicação da lei penal brasileira, à classificação dos crimes, aos conceitos de tentativa e de concurso de pessoas e à prescrição no direito penal.
Caso um funcionário público a serviço do Brasil no exterior seja condenado no estrangeiro por crime contra a administração pública brasileira, ele não poderá ser punido pelo mesmo fato perante a justiça brasileira.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 03. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Segundo a vigente legislação, os crimes contra o patrimônio da União Federal ficam sujeitos à lei brasileira, ainda que cometidos no estrangeiro. Essa norma é fundamentada no:', 'Princípio da atividade.', 'Princípio de taxatividade.', 'Princípio da ultratividade.', 'Princípio da excepcionalidade.', 'Princípio da extraterritorialidade.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 03. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Bernardo, cidadão português, tripulante de um navio da marinha mercante brasileira, que partira de Santos e navega pelo Oceano Atlântico, em alto-mar, com destino ao porto de Roterdã, na Holanda, agride um outro tripulante, de nacionalidade peruana, desferindo-lhe socos, que os fere levemente.
Diante do caso narrado, assinale a alternativa correta.', 'não se aplica a Bernardo a legislação penal brasileira, pois o crime ocorreu no estrangeiro.', 'aplica-se a Bernardo a legislação penal brasileira, pois o local onde ocorreu o crime é considerado território nacional por extensão.', 'pode ser aplicada a Bernardo a legislação penal brasileira, pois, embora o crime tenha ocorrido no estrangeiro, trata-se de hipótese de extraterritorialidade condicionada da lei penal brasileira, à luz do princípio da defesa.', 'aplica-se a Bernardo a legislação penal brasileira, pois, embora o crime tenha ocorrido no estrangeiro, trata-se de hipótese de extraterritorialidade incondicionada da lei penal brasileira, à luz do princípio da representação.', 'pode ser aplicada a Bernardo a legislação penal brasileira, pois, embora o crime tenha ocorrido no estrangeiro, trata-se de hipótese de extraterritorialidade condicionada da lei penal brasileira, à luz do princípio da representação.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 03. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2023
Com relação à aplicação da lei penal no espaço, segundo o vigente Código Penal, assinale a afirmativa correta.', 'Somente as embarcações e aeronaves brasileiras de natureza pública são consideradas como extensão do território nacional para fins penais.', 'Aplica-se a lei penal brasileira aos fatos praticados em quaisquer embarcações brasileiras, ainda que estejam ancoradas em porto estrangeiro.', 'A lei brasileira nunca é aplicável aos crimes praticados a bordo de aeronaves ou embarcações estrangeiras.', 'Ainda que seja cometido no estrangeiro, o crime de genocídio fica sujeito à lei brasileira quando o agente for brasileiro ou domiciliado no Brasil.', 'Não é aplicável a lei brasileira aos crimes praticados a bordo de aeronaves privadas estrangeiras, ainda que estejam em pouso no território nacional.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 03. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2023
Ficam sujeitos à lei brasileira, embora cometidos no estrangeiro, ainda que o agente seja absolvido ou condenado no estrangeiro, sem a necessidade de concorrência de qualquer outra condição, os crimes', 'que, por tratado ou convenção, o Brasil se obrigou a reprimir.', 'praticados em embarcações brasileiras, mercantes ou de propriedade privada, quando em território estrangeiro.', 'praticados em aeronaves brasileiras, mercantes ou de propriedade privada, quando em território estrangeiro.', 'contra a administração pública, por quem está a seu serviço.', 'praticados por brasileiro.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 03. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV - 2023
São teorias adotadas no Código Penal em relação ao tempo e ao lugar do crime, respectivamente:', 'da atividade e da territorialidade;', 'da anterioridade e da territorialidade;', 'da atividade e da ubiquidade;', 'da temporariedade e da ubiquidade;', 'da alteridade e mista.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 03. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/ CEBRASPE– 2023
Considerando os modelos de conceituação de ação, assinale a opção correta.', 'De acordo com o modelo estratégico de ação, esta é um ato de fala, traduzido na forma de um discurso, com pretensão de validade.', 'De acordo com o modelo causal de ação, esta consiste no movimento corpóreo que produz modificação no mundo exterior, o que permite diferenciar crimes comissivos e omissivos, bem como crimes materiais, formais e de mera conduta.', 'De acordo com o modelo finalista de ação, esta consiste na conduta dirigida a um fim ou objetivo, o que permite segmentar a conduta em objetiva e subjetiva, contudo seu elemento essencial não é o objetivo do sujeito, mas a dirigibilidade dos meios causais usados a fim de atingir o objetivo.', 'De acordo com o modelo social de ação, cujo principal formulador é o alemão Günther Jakobs, a ação é uma conduta socialmente irrelevante, ou seja, incapaz de ser objeto de um juízo de valor ou intervir no círculo jurídico de outrem, o que permite excluir de seu conceito fatos ou fenômenos que independam da vontade do sujeito.', 'De acordo com o modelo funcional de ação, o elemento central da ação é a base material da conduta, o que permite a análise do crime como lesão a bem jurídico.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 04. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2022
Durante assalto a uma joalheria, dois homens armados obrigaram a gerente, mediante grave ameaça, a abrir o cofre e a acondicionar as joias que estavam guardadas ali em uma mochila, que eles levaram consigo na fuga.
Com base no caso descrito e no conceito tripartite de crime, assinale a afirmativa correta.', 'A cooperação da gerente com os roubadores é um fato penalmente atípico.', 'Em razão da ameaça, a gerente não agiu com dolo ao colaborar com os roubadores.', 'A gerente não agiu de forma culpável, apesar de haver cometido um injusto penal.', 'A gerente cometeu o crime de roubo em concurso de agentes, mas é favorecida por uma escusa absolutória.', 'A gerente agiu em legítima defesa, razão por que a sua colaboração com os roubadores é justificada.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 04. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2022
Segundo o conceito analítico de crime, o instituto é composto por três elementos, quais sejam, o fato típico, a ilicitude ou antijuridicidade e a culpabilidade. O fato típico, por sua vez, é composto por conduta, resultado, nexo de causalidade e tipicidade.
Analise as proposições a seguir e assinale aquela que contém somente causas de exclusão da tipicidade.', 'Coação moral irresistível, estados de inconsciência e obediência hierárquica.', 'Coação física irresistível, estados de inconsciência e atos reflexos.', 'Coação física irresistível, estrito cumprimento do dever legal e estados de inconsciência.', 'Coação moral irresistível, estados de inconsciência e exercício regular de direito.', 'Coação física irresistível, obediência hierárquica e atos reflexos.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 04. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2018
Mévio, superior hierárquico de Tício, Oficial de Justiça, solicitou que ele alterasse o teor de determinada certidão em mandado de busca e apreensão. Apesar de ter conhecimento de que a conduta não era correta, Tício atendeu a solicitação de Mévio, já que este era seu superior hierárquico e os dois eram também amigos de infância. Descobertos os fatos, foi instaurado procedimento investigatório, razão pela qual Tício procura seu advogado para esclarecimentos.
Considerando apenas as informações narradas, o advogado de Tício deverá esclarecer que sua conduta configura:', 'fato típico, ilícito e culpável;', 'fato típico, mas não ilícito, em razão do estrito cumprimento do dever legal;', 'fato típico, mas não ilícito, em razão da obediência hierárquica;', 'fato típico e ilícito, mas não culpável, em razão da obediência hierárquica;', 'fato típico e ilícito, mas não culpável, em razão da coação moral irresistível.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2017
Doutrinadores nacionais admitem que a reforma de 1984 da Parte Geral do Código Penal, especialmente no que concerne ao “conceito de crime”, aderiu ao “finalismo”. Quem é considerado o criador de tal sistema jurídico-penal?', 'Hans Welzel.', 'Claus Roxim.', 'Von Liszt.', 'Günther Jakobs.', 'Cesare Beccaria.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
FGV– 2024
Kátia, namorada de Lizandra, em um restaurante, inconformada com o anúncio desta de que deseja pôr fim ao relacionamento amoroso, desfere-lhe facadas, com o intuito de matá-la, deixando em seguida o local. Socorrida por terceiros, Lizandra é hospitalizada, vindo o enfermeiro Miguel, por descuido, a trocar a medicação prescrita à paciente, aplicando-lhe substância diversa, que lhe provoca a morte, por choque anafilático.
Diante do caso narrado, Kátia deverá responder por:', 'feminicídio e Miguel, por homicídio culposo;', 'tentativa de feminicídio e Miguel, por homicídio culposo;', 'tentativa de feminicídio e Miguel, por homicídio doloso;', 'lesão corporal qualificada e Miguel, por homicídio doloso;', 'lesão corporal qualificada e Miguel, por homicídio culposo.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 05. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2013
A respeito de tipicidade, ilicitude, imputabilidade e crimes previstos na Lei n.º 8.666/1993, julgue o item seguinte.
Um crime é enquadrado na modalidade de delito tentado quando, ultrapassada a fase de sua cogitação, inicia-se, de imediato, a fase dos respectivos atos preparatórios, tais como a aquisição de arma de fogo para a prática de planejado homicídio.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 05. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2020
Iter criminis corresponde ao percurso do crime, compreendido entre o momento da cogitação pelo agente até os efeitos após sua consumação. Há relevância no estudo do iter criminis porque, conforme o caso, podem incidir institutos como desistência voluntária, princípio da consunção e tentativa. Considera-se punível o crime tentado no caso de', 'o agente ser flagrado elaborando os planos para a prática do crime.', 'o agente ser flagrado realizando atos de preparação para o crime.', 'o crime, iniciada a execução, não se consumar por ineficácia absoluta do meio empregado para sua prática.', 'o agente, iniciada a execução, desistir de prosseguir com a ação, impedindo seu resultado.', 'o crime, iniciada a execução, não se consumar por circunstâncias alheias à vontade do agente.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 05. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2010
Acerca do iter criminis e do crime, julgue os itens seguintes.
Os atos de cogitação materialmente não concretizados são impuníveis em quaisquer hipóteses.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 05. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2019
A omissão é penalmente relevante quando o omitente devia e podia agir para evitar o resultado. A afirmação: “o dever de agir incumbe a quem, com seu comportamento anterior, criou o risco da ocorrência do resultado”', 'está expressamente prevista no CP.', 'é a expressão supralegal da teoria da “imputação objetiva”.', 'é a expressão supralegal da teoria da “cegueira deliberada”.', 'deriva de construção jurisprudencial consolidada em súmula de Tribunal Superior.', 'admite a aplicação da responsabilidade objetiva no Direito Penal.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 05. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
Cada uma das opções a seguir apresenta uma situação hipotética seguida de uma assertiva a ser julgada a respeito de crimes dolosos e culposos. Assinale a opção que apresenta a assertiva correta.', 'Márcia agiu com intenção de causar um resultado, o que não ocorreu por circunstâncias alheias à sua vontade. Nesse caso, a conduta de Márcia é considerada culposa.', 'João agiu assumindo o risco de produzir um resultado criminoso, o que não aconteceu por circunstâncias alheias à sua vontade. Nesse caso, ele cometeu crime culposo.', 'Antônio, não desejando a ocorrência de um resultado, causou-o por negligência. Nessa hipótese, está caracterizada a conduta culposa, que só será punida se houver previsão legal específica.', 'Carlos, com intenção de lesionar a integridade física de Marcos, desferiu contra ele uma série de socos na cabeça, o que gerou traumatismo craniano e, alguns dias depois, a morte da vítima. Nessa situação, ele só responderá pelo resultado que agrava a pena se o houver causado dolosamente.', 'Gabriela agiu prevendo um resultado e assumiu o risco de produzi-lo. Nesse caso, o dolo de Gabriela é classificado como direto, pois houve a previsão do resultado danoso.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 06. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Sobre o dolo e a culpa na teoria do crime, assinale a afirmativa correta.', 'O dolo direto de segundo grau abrange os efeitos colaterais decorrentes do meio eleito pelo agente para atingir o resultado criminoso.', 'Na hipótese de dolo eventual, o agente não representa o resultado típico como possível, mas se conforma com a ocorrência dele. Já na hipótese de culpa consciente, o agente representa o resultado típico como possível e não desconfia que o mesmo ocorrerá.', 'A punição a título de culpa depende da análise das circunstâncias do caso concreto, sendo prescindível a previsão expressa no tipo legal.', 'Por força da teoria da imputação objetiva, uma vez não observado o cuidado devido, o agente é punível por crime culposo caso se envolva em evento penalmente típico, que se verificaria ainda que a diligência devida tivesse sido adotada.', 'Nenhuma das anteriores (N.D.A.)', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 06. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Com relação ao crime doloso e ao crime culposo, avalie se as afirmativas a seguir são verdadeiras (V) ou falsas (F).
(   ) O agente que deu causa ao resultado por negligência, responderá por culpa, ainda que não haja previsão de crime culposo.
(   ) A lei brasileira considera crime doloso quando o agente quis o resultado ou assumiu o risco de produzi-lo.
(   ) A imprudência caracteriza o agir culposo, mas a imperícia implica o agir doloso.', 'F – V – F.', 'V – V – F.', 'F – V – V.', 'V – F – F.', 'F – F – F.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 06. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2023
Quando o agente assume o risco de produzir o resultado, é correto dizer que houve', 'imperícia.', 'negligência.', 'culpa consciente.', 'culpa inconsciente.', 'dolo.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 06. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Túlio, um conhecido chefe de organização criminosa, plantou uma bomba no automóvel que transportava o presidente da empresa Beta (alvo da ação delituosa) bem como um motorista e um segurança. Túlio detonou o artefato a distância, durante o deslocamento do veículo em via pública, o que resultou na morte de todos os seus ocupantes.
Nessa situação hipotética, em relação à morte do segurança, Túlio agiu com', 'preterdolo.', 'dolo direto de primeiro grau.', 'dolo direto de segundo grau.', 'culpa consciente.', 'dolo eventual.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 06. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
VUNESP– 2024
Determinado indivíduo foi condenado com trânsito em julgado por crime consumado sem violência e nem grave ameaça à pessoa. Na sentença o magistrado diminuiu-lhe a pena de 1/2, por considerar que o dano, por ato voluntário, tinha sido reparado antes do recebimento da denúncia. O instituto que possibilitou a diminuição de pena denomina-se:', 'erro sobre a ilicitude do fato.', 'arrependimento posterior.', 'arrependimento eficaz.', 'desistência voluntária.', 'tentativa inidônea.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 07 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Elmo adquire, com intenção comercial, 500 pinos de cocaína, que leva para um terreno baldio, onde os mantém em depósito, e passa a vendê-los, sem autorização e em desacordo com determinação legal ou regulamentar, conforme usuários de drogas o abordam e lhe fazem os pedidos. Por meio de um drone, a polícia monitora a ação criminosa de Elmo, decidindo um dos policiais se passar por usuário, a fim de prendê-lo em flagrante. Ato contínuo, o policial, disfarçado de usuário, procura Elmo e lhe solicita 20 pinos de cocaína, indo Elmo até o local onde mantém a droga e voltando com a quantidade demandada. O policial paga o preço e, quando Elmo começa a lhe entregar os pinos de cocaína, identifica-se e lhe dá voz de prisão em flagrante, impedindo-o de concluir a venda e apreendendo a droga, inclusive aquela que ainda restava no terreno baldio.
Diante do caso narrado, é correto afirmar que Elmo:', 'não cometeu crime, pois houve flagrante esperado;', 'não cometeu crime, pois houve flagrante preparado;', 'cometeu o crime de tráfico de drogas, que se consumou no momento em que ele vendeu, ao policial disfarçado, 20 pinos de cocaína;', 'cometeu o crime de tráfico de drogas, que se consumou no momento em que ele adquiriu 500 pinos de cocaína, com intenção comercial;', 'cometeu o crime de tráfico de drogas, na forma tentada, quando iniciou a venda de 20 pinos de cocaína ao policial que se passou por traficante, não consumando o delito por circunstância alheia à sua vontade.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 07 (Recuperação Automática). Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/ CEBRASPE – 2024
João, com a intenção de subtrair um veículo, rendeu o motorista com o emprego de arma de fogo. Antes mesmo de ingressar no interior do veículo, o agente criminoso foi surpreendido pela polícia e, na tentativa de fuga, invadiu casa alheia, vindo a agredir um dos moradores.
A partir da situação hipotética apresentada, julgue o item que se segue, com base no Código Penal.
João deverá responder por tentativa de roubo, uma vez que a subtração não ocorreu por razões alheias à sua vontade.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 07 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
Em uma investigação, a Polícia Federal descobriu a atuação coordenada de um grupo criminoso que realizava queimadas na Amazônia. Os articuladores principais eram quatro fazendeiros da região, que, depois de terem se aprimorado na prática do crime, passaram a contar com o apoio de um servidor público federal, o qual, além de ocupante de cargo técnico em um órgão de fiscalização ambiental federal, também ocupava cargo de professor em um instituto federal de ensino, devido à compatibilidade de horários. Na investigação policial, comprovou-se que o servidor era informado do dia exato em que seriam realizadas as queimadas e ficava encarregado de desviar a fiscalização; em contrapartida, ele recebia uma quantia em dinheiro. Em sua defesa, o servidor alegou que o fogo das queimadas realizadas era sempre controlado e destinado exclusivamente a manejo agrícola, o que afastaria o dolo do crime de incêndio florestal e, consequentemente, afastaria a imputação contra si do crime funcional. Por sua vez, a defesa dos fazendeiros alegou inexistir dolo na conduta praticada por eles, sob a justificativa de que o uso do fogo era controlado e a prática respeitava as normas relativas ao manejo sustentável, acrescentando, ainda, que haviam sido feitos pagamentos ao servidor porque este os chantageava, sob ameaça de aplicar-lhes multas e denunciá-los à Polícia Federal.
A partir da situação hipotética apresentada, julgue o item seguinte, à luz do entendimento do STJ e da legislação penal vigente.
Suponha que, em determinada ocasião, um dos fazendeiros do grupo mencionado, depois de ter ateado fogo em mata aberta na Amazônia para fins de provocar incêndio florestal, tenha, por livre e espontânea vontade, agido para obstar a propagação descontrolada do fogo, impedindo seu alastramento logo no início. Nessa situação, a ação do fazendeiro caracteriza desistência voluntária.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 07 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Caio, Tício e Mévio integram um grupo de extermínio e decidem matar três integrantes de uma organização criminosa rival, cabendo a cada um o assassinato de uma das vítimas.
Caio abordou sua vítima em emboscada. Todavia ao efetuar o disparo, verificou que a arma de fogo estava desmuniciada. Tício efetuou um disparo de arma de fogo no tórax da vítima que era seu alvo. Porém, ao ver o homem agonizando e chamando por seus filhos, Tício se compadeceu e o levou ao hospital. O esforço foi, contudo, em vão, tendo em vista que a vítima faleceu na mesa cirúrgica em decorrência de hemorragia. Por fim, Mévio rendeu sua vítima apontando a arma de fogo para a cabeça. Nesse ínterim, a vítima propôs a Mévio o pagamento de R$50.000,00 (cinquenta mil reais) para que ele não o matasse, pedido que foi aceito por Mévio. Ocorre que minutos depois uma viatura passava pelo local e prendeu Mévio em flagrante.
Diante do exposto, assinale a opção que indica a consequência jurídica que melhor se amolda às condutas de Caio, Tício e Mévio, respectivamente.', 'Tentativa de homicídio, homicídio doloso e arrependimento eficaz.', 'Crime impossível, homicídio doloso e desistência voluntária.', 'Tentativa de homicídio, arrependimento eficaz e desistência voluntária.', 'Crime impossível, arrependimento eficaz e desistência voluntária.', 'Crime impossível, homicídio doloso e tentativa de homicídio.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 07 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Marcela, empregada celetista de sociedade empresária terceirizada de determinado órgão público, subtraiu uma valiosa obra de arte pertencente à repartição pública, valendo-se do acesso facilitado pelo seu vínculo empregatício.
Entretanto, após a subtração da peça, que pretendia revender, percebeu que seria descoberta, pois havia câmeras de segurança que registraram toda a ação. Marcela soube que as autoridades competentes já haviam sido acionadas para que se iniciasse a persecução penal e, por isso, decidiu restituir a peça, o que foi feito antes mesmo do recebimento da denúncia.
Sobre os fatos, assinale a afirmativa correta.', 'Marcela pode ter a pena reduzida pelo arrependimento posterior, ante a integral restituição antes do recebimento da denúncia.', 'Ocorreu uma tentativa inidônea, pois as câmeras de vigilância tornariam impossível a consumação da subtração.', 'Marcela não é funcionária pública, devendo ser responsabilizada por furto qualificado pelo abuso de confiança.', 'Marcela pode ser beneficiada pela exclusão da tipicidade do arrependimento eficaz, afastando-se a sua responsabilidade penal pelo fato.', 'Há extinção da punibilidade do delito de peculato pela restituição integral da coisa antes da sentença.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 07 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
FGV – 2024
Caio, torcedor fanático da Seleção Brasileira de Futebol, recebeu uma ligação, afirmando que foi sorteado para acompanhar a final de um campeonato entre o Brasil e a Argentina. Para tanto, ele deveria comparecer à sede da empresa que realizou o sorteio para retirar o ingresso. Assim sendo, Caio, agente público, saiu às pressas da repartição onde trabalha, levando consigo o telefone celular do órgão público, acreditando ser o seu aparelho de telefonia móvel, posto que ambos são idênticos.
Considerando as disposições do Código Penal e os entendimentos doutrinário e jurisprudencial dominantes, é correto afirmar que Caio:', 'não responderá por qualquer crime, por força do erro de proibição indireto;', 'não responderá por qualquer crime, por força do erro de proibição direto;', 'não responderá por qualquer crime, por força do erro de tipo;', 'responderá pelo crime de concussão;', 'responderá pelo crime de peculato.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 08. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2023
João, gestor público, autoriza a colocação de títulos da dívida pública no mercado financeiro, sem que estes estivessem previamente registrados em sistema centralizado de liquidação e de custódia. Durante a investigação pré-processual comprova-se que João, atuando de forma culposa, acreditava que os títulos da dívida pública estavam registrados no sistema adequado.
Nesse cenário, é correto afirmar que restou caracterizado:', 'erro de tipo inescusável, excluindo o dolo. Como há a modalidade culposa do tipo penal, João responderá pelo crime culposo de colocação de títulos no mercado;', 'erro de tipo inescusável, excluindo o dolo. Como não há a modalidade culposa do tipo penal, João não responderá por qualquer crime;', 'erro de tipo permissivo, isentando-se João de pena;', 'erro de proibição direto, isentando-se João de pena;', 'erro de proibição indireto, isentando-se João de pena.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 08. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2022
Enfurecido com a infidelidade de Lia, sua noiva, Rui decide ir, à noite, ao apartamento dela para confrontá-la. Ao avistar, na rua, um carro quase idêntico ao de Lia, Rui toma uma pedra e inscreve insultos contra ela na lataria do veículo. Enquanto riscava a pintura, Rui constata que a placa do veículo não corresponde à do carro de Lia.
Com base nesse caso, assinale a afirmativa correta.', 'Rui cometeu um crime culposo, pois agiu em erro quanto ao objeto do delito de dano.', 'A pena de Rui deve ser diminuída em razão do erro na execução do crime.', 'O erro sobre a identidade do automóvel não torna o fato atípico por ausência de dolo.', 'Rui é inimputável, uma vez que cometeu o erro impelido por violenta emoção.', 'O desconhecimento da real identidade do bem danificado exclui a culpabilidade de Rui.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 08. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2021
Acerca da estrutura analítica do crime, julgue o item a seguir.
O erro de tipo tem como consequência jurídica a exclusão do dolo enquanto elemento subjetivo, sendo vedada, nesse caso, a responsabilização penal do agente por crime culposo.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 08. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2022
No tocante ao erro na teoria do crime, é correto afirmar que:', 'o erro quanto à pessoa contra a qual o crime é praticado não isenta de pena, considerando-se, neste caso, as condições ou qualidades da vítima;', 'o erro sobre a ilicitude do fato, se evitável, não isenta de pena, mas poderá diminuí-la de 1/3 a 2/3;', 'o erro sobre elemento constitutivo do tipo legal de crime exclui o dolo, mas permite a punição por crime culposo, se previsto em lei;', 'o erro determinado por terceiro, se evitável, implica isenção de pena para o terceiro que determinou o erro;', 'o erro de tipo implica exclusão da culpabilidade na hipótese de estrito cumprimento de dever legal.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 08. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/ CEBRASPE– 2024
João, com a intenção de subtrair um veículo, rendeu o motorista com o emprego de arma de fogo. Antes mesmo de ingressar no interior do veículo, o agente criminoso foi surpreendido pela polícia e, na tentativa de fuga, invadiu casa alheia, vindo a agredir um dos moradores. A partir da situação hipotética apresentada, julgue o item que se segue, com base no Código Penal.
João pode alegar estado de necessidade em relação à invasão de domicílio se comprovar que ingressou na residência para se proteger de uma agressão iminente.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2021
Pedro, policial militar, foi convocado para acompanhar uma manifestação ao redor de prédios públicos. Em dado momento, parte dos manifestantes começou a apedrejar tais edifícios públicos, tendo ocasionado a destruição de uma vidraça da fachada de um deles. Em meio aos ataques, acreditando, erroneamente, que um dos manifestantes portava uma arma de fogo e iria disparar tiros contra ele, Pedro rapidamente sacou sua arma de fogo e disparou antecipadamente um tiro de advertência no chão, para tentar dispersar o manifestante. No entanto, o tiro acabou atingindo a perna do manifestante, causando-lhe lesão corporal grave. Em referência à situação hipotética apresentada, julgue o item que se segue.
Pedro agiu em legítima defesa putativa, pois acreditou, erroneamente, que estivesse sendo atacado por um manifestante armado.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2023
Ação que contempla o uso moderado dos meios necessários para repelir injusta agressão iminente a direito de outrem:', 'excludente de imputabilidade.', 'excludente de culpabilidade.', 'exercício regular de direito.', 'excludente de ilicitude.', 'estado de necessidade de terceiro.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
João, valendo-se de uma faca do tipo peixeira, agrediu fisicamente Carlos, que reagiu imediatamente e acabou matando João. O Ministério Público ofereceu denúncia contra Carlos, pela prática do crime de homicídio.
Considerando a situação hipotética apresentada, assinale a opção correta.', 'Não está caracterizada a legítima defesa, pois a repulsa à agressão inicial causou resultado mais grave, o que a afasta a incidência da excludente de ilicitude.', 'Estará caracterizada a legítima defesa caso se comprove que Carlos repeliu a agressão inicial, ainda que justa, valendo-se dos meios necessários.', 'Não está caracterizada a legítima defesa, salvo se Carlos provar que João estava armado ou agira com intenção de matá-lo.', 'Estará caracterizada a legítima defesa ainda que a reação à agressão injusta seja postergada para momento posterior.', 'Estará caracterizada a legítima defesa caso Carlos demonstre que repeliu a agressão inicial, desde que injusta, valendo-se moderadamente dos meios necessários.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
O policial Ermano e sua filha de dois anos caminhavam em uma rua quando se depararam com um cão Rottweiler que era guiado por seu tutor, Ronaldo. O cão atacou Ermano e a filha, ainda que Ronaldo tentasse controlar o animal. Ermano, que portava uma arma de fogo, disparou-a para proteger a filha e, embora o alvo fosse o cão, o projétil ricocheteou e atingiu Ronaldo, que faleceu em decorrência do ferimento, tendo ficado constatado que Ermano não tinha outra alternativa para evitar o ataque do cão contra sua filha.
Nessa situação hipotética, Ermano agiu', 'em legítima defesa putativa, devendo responder, contudo, pela morte de Ronaldo.', 'em aberratio ictus, amparado por uma causa excludente de culpabilidade.', 'em estado de necessidade exculpante, devendo responder, contudo, pela morte de Ronaldo.', 'em estado de necessidade e não deve responder, na esfera penal, pela morte de Ronaldo.', 'em legítima defesa preordenada e não deve responder pela morte de Ronaldo.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Segundo o Código Penal, é excludente de ilicitude', 'erro de proibição', 'estado de necessidade', 'doença mental', 'embriaguez acidental', 'menoridade penal', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2023
À luz das disposições legais de direito penal e da jurisprudência correlata, julgue o próximo item.
Admite-se a excludente de antijuridicidade do estrito cumprimento de dever legal nos crimes culposos.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2023
Aquele que pratica o fato em exercício regular de direito não comete crime, pois, nos termos do artigo 23 do CP, está amparado por uma', 'causa supralegal de exclusão da culpabilidade.', 'causa legal de exclusão da culpabilidade.', 'causa excludente de imputabilidade.', 'causa excludente de ilicitude.', 'descriminante putativa.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Francisco estava em uma festa, e foi agredido injustamente por outro convidado, o qual praticava artes marciais. Imediatamente, a fim de repelir as agressões, Francisco arremessou uma cadeira na cabeça de seu agressor, que desmaiou.
Na situação hipotética apresentada, a conduta de Francisco', 'caracteriza estado de necessidade, causa excludente de culpabilidade.', 'é atípica.', 'configura legítima defesa, o que exclui a culpabilidade.', 'configura legítima defesa, causa excludente de ilicitude.', 'é exercício regular de direito, o que exclui a antijuridicidade.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'VUNESP – 2022
A respeito das hipóteses de exclusão de ilicitude, constantes do Código Penal, é correto dizer que', 'no estado de necessidade, ainda que seja razoável exigir o sacrifício do direito que se visou salvaguardar, o agente restará isento de pena.', 'a legítima defesa é justificável para repelir injusta agressão a direito próprio ou a direito alheio.', 'o estado de necessidade é justificável apenas para salvaguarda de direito próprio, não englobando direito alheio.', 'quando o agente age em estado de necessidade, legítima defesa ou em estrito cumprimento do dever legal, incorre em crime, mas restará isento de pena, desde que não caracterizado o excesso, doloso ou culposo.', 'a legítima defesa específica aos agentes de segurança pública, prevista no parágrafo único do art. 25, do Código Penal, aplica-se apenas quando em causa vítima de crime de extorsão mediante sequestro.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 10. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/CEBRASPE– 2025
Considerando a Parte Geral do Código Penal e a doutrina correlata, julgue os itens a seguir.
É isento de pena o agente que houver praticado conduta típica e ilícita, mas não culpável, sob coação, moral ou física, irresistível.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2025
Considerando a Parte Geral do Código Penal e a doutrina correlata, julgue os itens a seguir.
É isento de pena o agente que, por embriaguez proveniente de caso fortuito ou força maior, não possuía, ao tempo da ação ou da omissão, a plena capacidade de entender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2024
Alberto, com mais de dezoito anos de idade, praticou crime de lesão corporal de natureza grave contra Bruno, seu inimigo. Alberto foi processado criminalmente, tendo sido comprovado que, ao tempo da conduta criminosa, ele era pessoa com doença mental, inteiramente incapaz de entender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento, o que determinou a sua absolvição.
Considerando a situação hipotética apresentada, julgue os itens subsequentes.
Para a absolvição de Alberto bastaria a este ser, ao tempo do processo, inteiramente incapaz de compreender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
À luz das disposições legais de direito penal e da jurisprudência correlata, julgue o próximo item.
É isento de pena o agente que, por embriaguez completa culposa, era, ao tempo da ação, inteiramente incapaz de entender o caráter ilícito do fato.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Em relação a aspectos do direito penal, julgue o item que se segue.
No Código Penal, adota-se o critério biopsicológico no tocante aos menores de 18 anos de idade.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
João, com 20 anos de idade e imputável, ingeriu bebida alcoólica durante uma festa e, embora não tivesse a intenção de se embebedar ou de praticar crimes, ficou completamente embriagado e desferiu socos em um desafeto, causando-lhe lesões corporais gravíssimas.
Na situação hipotética apresentada, a embriaguez foi completa e', 'culposa, mas não exclui a imputabilidade penal.', 'fortuita, excluindo a imputabilidade penal.', 'culposa, excluindo a imputabilidade penal.', 'involuntária, excluindo a imputabilidade penal.', 'patológica, com a agravante da embriaguez preordenada.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
O conceito de imputabilidade abrange um conjunto de requisitos que conferem ao indivíduo a capacidade para que lhe possa ser atribuída responsabilidade por comportamento legalmente definido como infração penal.
Nos termos da legislação vigente, pode-se afirmar corretamente que não exclui a imputabilidade', 'o desenvolvimento mental incompleto ou retardado.', 'a embriaguez completa proveniente de caso fortuito.', 'a menoridade.', 'a emoção ou a paixão.', 'a doença mental.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
De acordo com o CP (Código Penal), a embriaguez completa e fortuita é', 'atenuante de pena.', 'causa de isenção de pena.', 'causa de diminuição de pena.', 'excludente da ilicitude.', 'indiferente na imputabilidade penal.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Sobre aspectos atinentes à disciplina penal da culpabilidade, é correto afirmar que:', 'a embriaguez preordenada constitui hipótese de circunstância atenuante;', 'a embriaguez involuntária isenta o réu de pena;', 'a coação moral resistível é prevista como circunstância agravante da pena;', 'são admitidas, no ordenamento jurídico brasileiro, situações supralegais de inexigibilidade de conduta diversa;', 'a emoção ou a paixão podem excluir a culpabilidade ou configurar situação de semi-imputabilidade do agente.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
Em matéria de culpabilidade, de acordo com o Código Penal, é correto afirmar que', 'é isento de pena o agente que, por doença mental ou desenvolvimento mental incompleto ou retardado, era, ao tempo da ação ou da omissão, parcial ou inteiramente incapaz de entender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento.', 'é isento de pena o agente que, por embriaguez completa e voluntária, era, ao tempo da ação ou da omissão, inteiramente incapaz de entender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento.', 'excluem a imputabilidade penal a emoção ou a paixão e a embriaguez, voluntária ou culposa, pelo álcool ou substância de efeitos análogos.', 'é isento de pena o agente que, por doença mental ou desenvolvimento mental incompleto ou retardado, era, ao tempo da ação ou da omissão, inteiramente incapaz de entender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento.', 'pode a pena ser reduzida até um terço, se o agente, em virtude de depressão, não era inteiramente capaz de entender o caráter ilícito do fato ou de determinar-se de acordo com esse entendimento.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 14. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/CEBRASPE– 2025
Acerca dos crimes previstos no Código Penal, julgue o próximo item.
Considere que um indivíduo, utilizando-se de arma de fogo de uso permitido, mate um desafeto dele. Nessas condições, o delito será tipificado como homicídio qualificado, com todos os seus consectários legais.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2024
Em relação aos crimes contra a pessoa, contra a administração pública e contra a fé pública, julgue o item subsequente, de acordo com o Código Penal.
Considere que um cirurgião, ao realizar procedimento médico em seu filho recém-nascido, tenha cometido um erro técnico que tenha resultado na morte da criança. Nessa hipótese, caso o cirurgião seja condenado por homicídio culposo, o juiz poderá deixar de aplicar-lhe a pena, se constatar que a sanção é desnecessária.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2023', 'O homicídio é considerado qualificado se for praticado', 'por motivo grave.', 'com emprego de arma de fogo.', 'para assegurar a execução, a ocultação, a impunidade ou vantagem de outro crime.', 'por domínio de violenta emoção, logo após injusta agressão da vítima.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Com referência aos crimes contra a vida, sabe-se que alguns são tipificações do descrito como homicídio, no artigo 121 do Código Penal, e que outros estão descritos em artigos próprios, também nesse ordenamento jurídico. Com base no conhecimento da legislação, julgue o item a seguir.
O crime de feminicídio corresponde ao homicídio de uma mulher em qualquer situação, entendimento tido desde a implantação da Lei do Feminicídio em 2015.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
B é um adolescente de 13 anos com sérios problemas de autoestima, o que o conduz a um estado de depressão. A, maior de idade, sabendo das condições de B e interessado na fortuna de que este é destinatário, instiga-o a se matar, convencendo-o de que o paraíso seria muito melhor para ele do que a situação atual. B, em razão disso, suicida-se.
Nessa situação hipotética, a conduta de A é considerada', 'homicídio simples.', 'induzimento ao suicídio na forma simples.', 'atípica, haja vista não ter praticado nenhum ato executório.', 'induzimento ao suicídio na forma qualificada.', 'homicídio qualificado.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2024
João permaneceu preso, em cumprimento de pena, durante três anos, em razão de captura flagrancial efetuada pelo policial Matheus. Após ser colocado em liberdade, João descobriu o endereço de Matheus e matou-o em razão das funções por ele exercidas na Polícia Militar. Durante as investigações, concluiu-se que houve, para o sucesso do crime, emprego de uma pistola calibre nove milímetros (arma de fogo de uso restrito) e de recurso que tornou impossível a defesa do ofendido.
Nesse cenário, considerando as disposições do Código Penal, é correto afirmar que João responderá pelo crime de homicídio', 'qualificado, em razão do recurso que dificultou a defesa do ofendido, com a incidência de duas causas de aumento de pena, por força do emprego de arma de fogo de uso restrito e por ter sido praticado contra policial militar, em decorrência das funções.', 'duplamente qualificado, em razão do recurso que dificultou a defesa do ofendido e do emprego de arma de fogo de uso restrito, e com a incidência de uma causa de aumento de pena, por ter sido praticado contra policial militar, em decorrência das funções.', 'simples, com a incidência de três causas de aumento de pena, em razão do recurso que dificultou a defesa do ofendido, do emprego de arma de fogo de uso restrito e por ter sido praticado contra policial militar, em decorrência das funções.', 'triplamente qualificado, em razão do recurso que dificultou a defesa do ofendido, do emprego de arma de fogo de uso restrito e por ter sido praticado contra policial militar, em decorrência das funções.', 'simples, com a incidência de duas causas de aumento de pena, em razão do recurso que dificultou a defesa do ofendido e por ter sido praticado contra policial militar, em decorrência das funções.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'FGV – 2023
Kátia, proprietária de uma casa de veraneio, é informada por uma vizinha de que populares estão invadindo seu quintal, para fazer uso da piscina, aproveitando-se de sua ausência. Para pôr fim ao abuso, Kátia instala um dispositivo que eletrifica a água da piscina, por ela acionado sempre que está ausente. O dispositivo em questão não é visível, tampouco existe no local qualquer aviso sobre o risco de se entrar na piscina. Alguns dias depois, um adolescente pula o muro do quintal da residência de Kátia, então ausente, e, ao mergulhar na piscina, recebe forte descarga elétrica, que o faz desfalecer, vindo ele a morrer afogado.
Diante do caso narrado, a correta adequação típica do fato é:', 'fato atípico;', 'homicídio;', 'fato típico, porém lícito, pois praticado em legítima defesa;', 'fato típico, porém lícito, pois praticado em estado de necessidade;', 'fato típico, porém lícito, pois praticado no exercício regular de direito.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/CEBRASPE– 2024
Em relação aos crimes contra a pessoa e o patrimônio, julgue o item subsecutivo.
Todo homicídio praticado por homem contra mulher caracteriza o crime de feminicídio.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2023
Com referência aos crimes contra a vida, sabe-se que alguns são tipificações do descrito como homicídio, no artigo 121 do Código Penal, e que outros estão descritos em artigos próprios, também nesse ordenamento jurídico.
O aborto sentimental pode ser realizado quando o concepto for fruto de estupro, desde que exista ocorrência policial e autorização judicial.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2023
Com referência aos crimes contra a vida, sabe-se que alguns são tipificações do descrito como homicídio, no artigo 121 do Código Penal, e que outros estão descritos em artigos próprios, também nesse ordenamento jurídico. Com base no conhecimento da legislação, julgue o item a seguir.
O crime de infanticídio se caracteriza pela conduta de a mãe, em estado puerperal, durante o parto ou logo após ele, matar o próprio filho.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Com referência aos crimes contra a vida, sabe-se que alguns são tipificações do descrito como homicídio, no artigo 121 do Código Penal, e que outros estão descritos em artigos próprios, também nesse ordenamento jurídico. Com base no conhecimento da legislação, julgue o item a seguir.
O crime de aborto qualificado prevê o aumento da pena em caso de lesão corporal grave ou morte da mãe em consequências de aborto.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Lisa está sendo investigada pelo crime de instigação à prática de automutilação por meio da Internet e, ao ser ouvida como indiciada, recusou-se a falar. Nessa situação hipotética,', 'o fato de Lisa ter ficado em silêncio durante a oitiva policial é fundamento para uma eventual condenação pelo juiz, posteriormente, na sentença.', 'a conduta de Lisa é atípica se dela não resultar lesão corporal de natureza grave ou gravíssima.', 'caso Lisa seja denunciada e condenada, a pena será aumentada até o dobro se for constatado que sua conduta foi transmitida pela Internet em tempo real.', 'o delegado pode arquivar o inquérito policial se não reunir indícios suficientes de autoria contra Lisa.', 'caso Lisa seja denunciada e condenada, a pena será aumentada em até um terço se ficar comprovada sua liderança em grupo virtual.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
À luz do Código Penal, assinale a opção correta acerca dos crimes contra a pessoa.', 'O agente que induzir ou instigar alguém a suicidar-se ou a praticar automutilação responderá por crime doloso contra a vida, punido com reclusão.', 'A mulher que, sob a influência do estado puerperal, matar o próprio filho durante o parto responderá por aborto provocado pela gestante.', 'A gravidade da lesão corporal será equivalente se ocorrer tanto a debilidade permanente quanto a perda ou a inutilização de membro, sentido ou função.', 'O aborto necessário — quando não há outro meio de salvar a gestante — e o aborto no caso de gravidez decorrente de estupro excluem a ilicitude por inexigibilidade de conduta diversa.', 'A circunstância de o crime de feminicídio ser praticado durante a gestação ou nos seis meses após o parto é qualificadora desse crime.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Antônio, visando matar Carlos, desferiu tiros na direção deste, o que lhe causou a morte. Todavia, alguns disparos, por clara culpa, atingiram Francisco, que não faleceu, mas perdeu o braço por amputação em decorrência dos ferimentos.
Nesse caso, Antônio deverá responder por', 'lesão corporal culposa em concurso material com homicídio doloso consumado.', 'homicídio doloso consumado na forma continuada.', 'tentativa de homicídio em concurso material com homicídio doloso consumado.', 'homicídio doloso consumado em concurso formal próprio com tentativa de homicídio.', 'homicídio doloso consumado em concurso formal com lesões corporais culposas.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2017
Pedro, José e Alfredo integram uma organização criminosa que opera com tráfico de drogas e comete vários crimes na periferia de uma grande cidade brasileira. José ocupa uma posição mais alta na organização, sendo responsável por punir quem não correspondesse às expectativas do grupo. Certo dia, tendo Alfredo falhado na cobrança de uma dívida do tráfico, José, com a ajuda de Pedro, deu-lhe uma surra. Com o objetivo de se vingar de ambos, Alfredo armou um plano para acabar com a vida de José e atribuir a responsabilidade a Pedro. Assim, durante um tiroteio entre integrantes da organização criminosa e policiais, Alfredo, apontando na direção de José, que estava atrás de um arbusto, orientou Pedro a atirar nele, sob a alegação de que se tratava de um policial. O tiro atingiu José e Alfredo fugiu. Tendo percebido o erro, Pedro levou José ao hospital, o que evitou sua morte.
Considerando que, conforme o Código Penal, o crime de homicídio consiste em matar alguém e o crime de lesão corporal em ofender a integridade corporal ou a saúde de outrem, assinale a opção correta a respeito da responsabilização de Alfredo e Pedro na situação hipotética apresentada.', 'Pedro não será responsabilizado pela prática de crime, em razão do erro sobre pessoa, e Alfredo responderá por tentativa de homicídio.', 'Alfredo será responsabilizado por tentativa de homicídio e Pedro por lesão corporal.', 'Nem Alfredo nem Pedro serão responsabilizados pela prática de crime, já que Pedro impediu a morte de José.', 'Tanto Pedro quanto Alfredo responderão por tentativa de homicídio.', 'Pedro não será responsabilizado pela prática de crime, por estar configurada discriminante putativa, e Alfredo responderá por lesão corporal.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2012
João, namorado de Ana, acha que ela um dia, no passado, o traiu com Pedro, seu vizinho, que é muito forte. Em uma ocasião, chegando à casa de Ana, encontrou Pedro no portão e imediatamente passou a agredi-lo verbalmente. Em seguida, atracaram-se e, na briga, João, que estava apanhando, usou uma navalha que carrega sempre consigo para furar Pedro na barriga. Pedro não morreu, mas ficou internado em hospital por dois meses. Com relação a essa situação hipotética, julgue o item que se segue.
A conduta de João configura tentativa de homicídio ou lesão corporal de natureza grave, a depender do elemento subjetivo de João, a ser revelado com base em elementos fáticos apurados na investigação e no processo.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2012
Em cada uma das opções abaixo, é apresentada uma situação hipotética acerca dos crimes em espécie seguida de uma assertiva a ser julgada. Com base nas disposições do Código Penal, assinale a opção cuja assertiva esteja correta.', 'Uma pessoa cometeu crime de lesão corporal seguida de morte logo após ter sido provocada injustamente pela vítima, estando, dessa forma, sob o domínio de violenta emoção. Nessa situação, o juiz poderá reduzir a pena.', 'João, sabendo ser mentira, acusou publicamente José de ter furtado o relógio de Juca. Nessa situação, João responderá pelo crime de difamação.', 'Um homem, após graves ameaças, subtraiu as joias de sua genitora. Nessa situação, em virtude de o homem ter cometido crime contra o patrimônio em desfavor de sua ascendente, ele será isento de pena.', 'Uma pessoa apropriou-se de coisa alheia que veio ao seu poder por erro ou força da natureza. Nessa situação, a pessoa não cometeu crime.', 'Uma gestante consentiu a outra pessoa que provocasse o aborto de seu feto. Nessa situação, a mulher que estava grávida responderá pelo crime de aborto com o consentimento da gestante e a outra pessoa será isenta de pena.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 18 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/CEBRASPE– 2025
Acerca dos crimes previstos no Código Penal, julgue o próximo item.
Suponha que Romualdo, réu primário, seja condenado pela prática de furto de pequeno valor mediante fraude, cometido por meio de dispositivo informático não conectado à Internet. Nessa situação, é cabível a substituição da pena de reclusão pela de detenção, em razão da primariedade do réu.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2024
Em relação aos crimes contra a pessoa e o patrimônio, julgue o item subsecutivo.
Considere que um cidadão penalmente imputável, ao longo de vários meses, tenha desviado energia elétrica de sua fonte natural, por meio de ligação clandestina, em prejuízo à concessionária pública. Nessa situação, o agente praticou o crime de furto simples, em razão da equiparação da energia elétrica a coisa alheia móvel.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2023
Com base nas disposições relativas aos crimes previstos no Código Penal e no entendimento jurisprudencial acerca da matéria, julgue o item subsecutivo.
Suponha-se que um indivíduo, fingindo trabalhar como manobrista para um salão de beleza famoso, receba o veículo de uma cliente a fim de estacioná-lo e, em seguida, saia com o carro para dar uma volta, restituindo-o, espontaneamente, horas depois, à sua proprietária, sem qualquer dano ou prejuízo. Nessa situação hipotética, o fato é atípico.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Antônio, Carlos e Pedro, previamente ajustados, subtraíram diversos bens pertencentes a um estabelecimento comercial. Após deixarem o local, foram encontrados pela polícia, ainda na posse dos bens.
A partir dessa situação hipotética, julgue o seguinte item.
Ainda que se trate de furto qualificado, se os bens subtraídos forem de pequeno valor e os agentes, primários, poderá o juiz substituir a pena de reclusão pela de detenção, diminuí-la ou aplicar somente a pena de multa.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
Acerca do furto, julgue o item a seguir.
Em caso de furto de objeto de pequeno valor, é facultada ao juiz a aplicação de somente pena de multa, desde que o réu seja primário, sendo esse requisito subjetivo aferido suficientemente pela simples folha de antecedentes criminais do réu.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
João, às 4 h da manhã, arrombou o cadeado da residência de Sebastião, adentrando o interior da casa da vítima. De forma sorrateira e sem fazer barulho, para evitar que acordasse a família da vítima, que lá dormia, João subtraiu uma televisão de 48 polegadas, levando-a consigo. Dez minutos após sair da casa de Sebastião, ao ser abordado por policiais militares, João acabou confessando a prática delituosa.
Na situação hipotética apresentada, segundo o entendimento jurisprudencial do STJ, João praticou', 'furto simples com a causa de aumento relativa ao repouso noturno.', 'furto qualificado.', 'furto qualificado com causa de aumento relativa ao repouso noturno.', 'tentativa de furto com causa de aumento de pena relativa ao repouso noturno.', 'tentativa de furto qualificado com causa de aumento de pena relativa ao repouso noturno.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
Durante a noite, uma pessoa adentrou clandestinamente em uma loja que comercializa aparelhos eletrônicos e subtraiu diversos celulares, mas foi detida em flagrante pela polícia.
A partir dessa situação hipotética, assinale a opção correta em relação à causa de aumento de pena no caso de furto noturno, à luz do entendimento consolidado pelo Superior Tribunal de Justiça (STJ).', 'O fato de a ação delitiva ter ocorrido em estabelecimento comercial enseja, por si só, o aumento da pena aplicável ao furto noturno.', 'A presença de outra pessoa dentro do estabelecimento comercial no momento da ação delituosa seria causa de aumento de pena relativa ao furto noturno.', 'Para a incidência de causa de aumento de pena relativa ao furto noturno, é imprescindível a comprovação de falta de iluminação adequada no local de ocorrência do delito.', 'Para a incidência de causa de aumento de pena relativa ao furto noturno, é preciso representação da vítima.', 'A ocorrência do furto à noite e em situação de repouso configura causa de aumento de pena relativa ao furto noturno, independentemente de o local estar ou não habitado.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Valendo-se da situação de calamidade pública decretada em razão da pandemia de covid-19, Eduardo, mediante o uso de uma chave falsa, subtraiu para si um veículo de propriedade de Mariana. Acionada, a polícia militar, após efetuar algumas rondas, prendeu em flagrante Eduardo na posse do veículo e da chave usada por ele para ligar o automóvel.
Nessa situação hipotética, houve o delito de', 'furto consumado, segundo a teoria da ablatio, devendo haver a incidência da agravante genérica relativa à ocasião de calamidade pública.', 'furto consumado, segundo a teoria da concretatio, devendo haver a incidência da agravante genérica relativa à ocasião de calamidade pública.', 'furto consumado, segundo a teoria da amotio ou apprehensio, devendo haver a incidência da agravante genérica relativa à ocasião de calamidade pública.', 'furto tentado, uma vez que não houve posse desvigiada do veículo.', 'furto tentado, uma vez que o veículo foi retomado em momento imediatamente posterior à sua subtração.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
João arrombou a loja onde trabalha, e que pertence à sua mãe de 60 anos de idade, levando mercadorias avaliadas em milhares de reais.
Na situação hipotética apresentada, pode-se afirmar que João', 'praticou furto com rompimento de obstáculo à subtração da coisa.', 'cometeu a infração penal de dano qualificado com prejuízo considerável para a vítima.', 'responderá por furto de coisa comum por sua condição de herdeiro necessário.', 'não responderá por crime contra o patrimônio, visto ser amparado por isenção de pena.', 'responderá pelo crime de apropriação indébita com aumento de pena em razão do emprego que exercia.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Visando furtar uma residência, um indivíduo pulou o muro que a circunda e a invadiu. Antes de levar consigo os bens que já tinha separado na residência, ele ouviu o barulho de pessoas na calçada, que estavam suspeitando da ocorrência de algo errado na residência, motivo pelo qual fugiu do local, para não ser capturado.
Nessa situação hipotética, a conduta do indivíduo', 'configura furto qualificado tentado.', 'não configura nenhum crime, em razão da desistência voluntária.', 'configura furto simples tentado.', 'configura violação de domicílio na forma consumada.', 'configura furto simples tentado em concurso com a violação de domicílio na forma consumada.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 19. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'Hora de Praticar
CESPE/CEBRASPE– 2024
João, com a intenção de subtrair um veículo, rendeu o motorista com o emprego de arma de fogo. Antes mesmo de ingressar no interior do veículo, o agente criminoso foi surpreendido pela polícia e, na tentativa de fuga, invadiu casa alheia, vindo a agredir um dos moradores.
A partir da situação hipotética apresentada, julgue o item que se segue, com base no Código Penal.
Se a arma empregada para a prática do delito for de uso restrito ou proibido, a pena do roubo será aplicada em dobro.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2025
Em relação à aplicação da lei penal, ao tempo e lugar do crime, aos crimes contra o patrimônio e aos crimes contra a administração pública, julgue o item seguinte.
Quem recebe para si, no exercício de atividade comercial ou industrial, coisa que deve saber ser produto de crime pratica o delito de receptação simples.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE– 2023
Texto
Em 8/11/2021, Almir, visando conseguir dinheiro para comprar carne e bebidas para a comemoração do seu aniversário de 18 anos, que aconteceria em 9/11/2021, utilizou uma arma de fogo para restringir a liberdade da empresária Emília, colocando-a em cativeiro. Em seguida, Almir entrou em contato com a família da vítima, exigindo o pagamento da quantia de R$ 10.000 para a sua liberação. Apesar das constantes ameaças, a família não pagou o resgate e avisou o ocorrido à polícia. Três dias seguintes à restrição da liberdade da vítima, em 11/11/2021, a polícia conseguiu localizar o cativeiro e libertar Emília.
A partir dessa situação hipotética e considerando o direito penal vigente, julgue o item a seguir.
Almir praticou o crime de roubo majorado pelo uso de arma de fogo e pela restrição da liberdade da vítima.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2022
Antônio, Carlos e Pedro, previamente ajustados, subtraíram diversos bens pertencentes a um estabelecimento comercial. Após deixarem o local, foram encontrados pela polícia, ainda na posse dos bens.
A partir dessa situação hipotética, julgue o seguinte item.
Ainda que o furto tenha ocorrido à noite, não incidirá, nesse caso, a causa de aumento (prática do crime de furto no período noturno) da pena prevista, segundo a jurisprudência do Superior Tribunal de Justiça.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023
Renato, munido de uma faca, deu voz de assalto a Carolina, que informou não ter nenhum bem de valor. Ele, como não acreditou em Carolina, exigiu que esta esvaziasse os bolsos, momento em que Renato percebeu que ela realmente só trazia consigo o documento de identificação, o que o levou a sair do local sem levar nada.
Nessa situação, a conduta de Renato, conforme o Superior Tribunal de Justiça (STJ), caracteriza-se como', 'roubo simples consumado.', 'atípica, já que houve crime impossível.', 'roubo simples tentado.', 'roubo tentado com causa de aumento de pena.', 'roubo com causa de aumento de pena consumado.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
De acordo com o entendimento jurisprudencial do STJ, o agente que, mediante violência ou grave ameaça pelo uso de arma fogo, subtrai coisa alheia móvel para usá-la, sem intenção de tê-la como própria, ou seja, sem o ânimo de apossamento definitivo, configura', 'conduta atípica.', 'tentativa de roubo.', 'constrangimento ilegal.', 'furto consumado.', 'roubo consumado.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
De acordo com o entendimento do STJ, ainda que o agente não seja reincidente em crime doloso e as circunstâncias judiciais lhes sejam favoráveis, é vedada a substituição da pena privativa de liberdade por outra pena restritiva de direitos na hipótese de condenação por', 'furto qualificado.', 'roubo tentado praticado com simulacro de arma de fogo.', 'homicídio culposo.', 'peculato doloso.', 'corrupção ativa.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2024
Durante uma reestruturação em determinada empresa, Diana, descontente com as atitudes de Bruno, seu colega de trabalho que exerce cargo de chefia, o chantageou para obter vantagens pessoais no trabalho. Diana, mediante grave ameaça, afirmou que divulgaria informações confidenciais sobre a vida pessoal de Bruno caso ele não lhe concedesse um cargo mais elevado na empresa.
Nessa situação hipotética, Diana praticou o crime de', 'extorsão qualificada pelo meio grave de ameaça.', 'extorsão privilegiada por motivo de vingança.', 'extorsão comum.', 'extorsão mediante sequestro.', 'extorsão tentada.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023', 'Constitui crime contra a pessoa', 'o latrocínio.', 'o estelionato.', 'o dano.', 'a calúnia.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (6, 'CESPE/CEBRASPE – 2023', 'Os crimes de roubo e furto são semelhantes quanto ao fato de', 'ambos caracterizarem a subtração de coisa alheia móvel.', 'ambos terem como objeto a coisa perdida ou abandonada.', 'o próprio dono da coisa poder ser sujeito ativo desses delitos.', 'ambos se consumarem sem violência à pessoa.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Penal - Aula 20. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'Hora de Praticar
FGV – 2024
A diretriz segundo a qual ninguém pode ser punido criminalmente antes do trânsito em julgado da decisão condenatória retrata', 'o princípio da ampla defesa.', 'o princípio do contraditório.', 'o princípio da presunção de inocência.', 'o princípio da paridade de armas.', 'o princípio da inafastabilidade.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 02. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE – 2024
No sistema misto, o processo se divide em', 'duas grandes fases: na fase de instrução preliminar, com elementos do sistema acusatório, predomina o procedimento público, escrito e sujeito ao contraditório, enquanto, na fase de julgamento, com a predominância do sistema inquisitivo, a oralidade, o sigilo e a intervenção de juízes togados conduzem a valoração das provas.', 'três fases distintas: na primeira, há predominância do viés inquisitorial, com formalismo excessivo e pouco espaço para a ampla defesa e o contraditório; na segunda fase, predomina a argumentação e o contraditório; na terceira fase, há a participação popular efetivada pela atuação dos tribunos e dos juízes leigos.', 'três fases distintas e interligadas: na primeira, há predominância do viés inquisitorial, com formalismo nas reduções a termo e pouco espaço para a ampla defesa e o contraditório; na segunda fase, predomina a consulta popular com a participação dos jurisconsultos que mediam os debates; na terceira, há o envio dos autos para o oficial da ouvidoria real para a chancela do soberano.', 'duas grandes fases: na fase de instrução preliminar, com os elementos do sistema inquisitivo, predomina a procedimento secreto, escrito e sem contraditório; enquanto, na fase de julgamento, com a predominância do sistema acusatório, presentes se fazem a oralidade, a publicidade, o contraditório, a concentração dos atos processuais, a intervenção de juízes populares e a livre apreciação das provas.', 'duas fases: na primeira fase há predominância da oralidade, o libelo acusatório é lido e a pronúncia é formalizada; e, na segunda fase, ocorre o debate entre defesa e acusação.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 02. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE – 2024
O princípio do devido processo legal', 'tem suas raízes no princípio da legalidade e garante que o indivíduo somente seja processado e punido se houver lei penal anterior definindo determinada conduta como crime, cominando-lhe pena.', 'tem sua fundamentação na teoria da imputação objetiva e expressa uma concepção puramente legalista, excludente e supremacista do processo penal.', 'tem origem no sistema inquisitorial misto das tribos germânicas e serviu de base para a teoria do direito penal do inimigo de Gunther Jakobs.', 'se baseia na tradição romana do fas e no uso do fascio como instrumento de dominação usado pelos patres familiae.', 'se baseia no eficientismo penal e no movimento da Lei e da Ordem (Law and Order) de Dahrendorf.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE – 2024
Assinale a opção correta em relação às normas gerais do processo penal.', 'Os crimes militares são apurados segundo as regras do Código de Processo Penal (CPP), sendo o Código de Processo Penal Militar aplicado de forma subsidiária.', 'A superveniência de nova lei processual invalida os atos processuais praticados na vigência da lei anterior, salvo se houver ratificação.', 'Em regra, a nova lei processual só alcança as ações penais referentes a crimes praticados após a sua vigência, sob pena de violação ao princípio da irretroatividade.', 'É vedada a interpretação extensiva das normas processuais penais, uma vez que vigora o princípio da estrita legalidade.', 'Admite-se a aplicação analógica de leis processuais penais, bem como a suplementação pelos princípios gerais do direito.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 02. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'FGV – 2023
João foi processado criminalmente pela suposta prática do crime de roubo. Ao fim do processo, após a apresentação de alegações finais pelo Ministério Público e pela defesa técnica, o juiz chega à conclusão de que não há prova suficiente para condenação, motivo pelo qual absolve o acusado.
Nesse cenário, o juiz decidiu ancorado no princípio da:', 'presunção de não culpabilidade;', 'não autoincriminação;', 'busca da verdade;', 'ampla defesa;', 'verdade real.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE
Em relação ao sistema processual penal brasileiro, julgue o item subsecutivo.
A Constituição Federal de 1988 adota, em regra, o modelo acusatório, caracterizado pela separação das funções de acusação, defesa e julgamento.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'Hora de Praticar
VUNESP – 2024
Tratando-se de inquérito policial, inquérito policial militar e demais procedimentos extrajudiciais instaurado para investigar servidores das instituições responsáveis pela segurança pública enumeradas no art. 144, da CF, para apurar fatos relacionados ao uso da força letal praticados no exercício profissional, nos termos das disposições do Código de Processo Penal, é correto afirmar que', 'o investigado deverá ser citado da instauração do inquérito, no prazo de até 48 horas, podendo constituir defensor, no mesmo prazo.', 'citado da instauração do inquérito e não constituído defensor pelo investigado, no prazo de 48 horas, será intimada a instituição a que vinculado o investigado à época da ocorrência, para indicar defensor para a representação do investigado.', 'a defesa do investigado, em não sendo constituído defensor particular, competirá exclusivamente à Defensoria Pública. Nos locais em que não estiver presente, será indicado profissional da instituição a que vinculado o investigado, à época dos fatos.', 'os custos do profissional indicado para a defesa do investigado, no caso da não atuação da Defensoria Pública, serão suportados pela Unidade Federativa correspondente à respectiva competência territorial do inquérito instaurado.', 'os custos do profissional indicado para a defesa do investigado, no caso da não atuação da Defensoria Pública, serão por ele suportados.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'FGV – 2024
João Paulo, advogado, caluniou seu desafeto, Rubens, empresário de renome na comarca, imputando-lhe falsamente fato definido como crime.
Relativamente à investigação do crime de calúnia, com vistas a se determinar a sua existência e autoria, é correto afirmar que o inquérito policial poderá ser iniciado:', 'mediante requisição do juiz, caso não o faça o Ministério Público;', 'por requisição do Ministério Público, caso não o faça o ofendido;', 'por requisição do Ministro da Justiça, caso não o faça o juiz;', 'pela autoridade policial, mediante requerimento do ofendido;', 'de ofício pela autoridade policial.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'FGV – 2024
Acerca do inquérito policial, assinale a afirmativa correta.', 'O inquérito policial não pode ser encerrado antes de esgotado o prazo legal de sua duração, salvo por solicitação de arquivamento pelo Ministério Público.', 'Nos crimes de ação penal privada, o inquérito policial pode ser instaurado mediante requisição da vítima, do Poder Judiciário e do Ministério Público.', 'O requerimento de instauração do inquérito policial deve obrigatoriamente conter a individualização do indiciado e as razões de convicção sobre a autoria delitiva.', 'Qualquer pessoa pode comunicar a ocorrência de infração penal à autoridade policial, que deverá obrigatoriamente instaurar inquérito policial.', 'Nos crimes em que a ação penal depender de representação, o inquérito policial não poderá ser iniciado sem essa providência.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE – 2024
A respeito de denúncia, dos efeitos da incompetência na ação penal bem como da atuação do Ministério Público no processo penal, julgue o item a seguir.
Um dos efeitos inerentes ao recebimento da denúncia pelo Ministério Público é a invalidade do indiciamento policial que seja instaurado posteriormente a ele.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'FGV – 2024
Em inquérito policial instaurado para apurar crime de furto, a autoridade policial concluiu pela existência de elementos mínimos sobre a autoria e a materialidade do delito e remeteu os autos ao Ministério Público. O promotor de justiça, discordando do relatório, promoveu o arquivamento fundamentadamente e comunicou à vítima, ao investigado, ao juiz e ao delegado de polícia.
Diante desse cenário, é correto afirmar que:', 'no caso de discordância do arquivamento, o delegado de polícia poderá remeter os autos ao procurador-geral de justiça para revisão;', 'no caso de discordância do arquivamento, o juiz poderá mandar desarquivar os autos do inquérito policial para a retomada das investigações;', 'no caso de discordância, o delegado de polícia poderá proceder ao desarquivamento do inquérito policial e continuar as investigações;', 'no caso de discordância do arquivamento levado a efeito pelo órgão ministerial, a vítima poderá ajuizar ação privada subsidiária da pública;', 'no caso de discordância, a vítima poderá, no prazo de 30 dias do recebimento da comunicação, submeter a matéria à revisão da instância competente do órgão ministerial.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'FGV - 2024
João, delegado de polícia, foi cientificado sobre a ocorrência, na circunscrição da sua unidade policial, de um crime de latrocínio tentado, persequível mediante ação penal pública incondicionada. Dessa forma, a autoridade policial, independentemente de qualquer provocação por parte da vítima, deflagrou um inquérito policial visando à apuração dos fatos.
Nesse cenário, considerando as disposições do Código de Processo Penal e o entendimento doutrinário dominante, é correto afirmar que a atuação de João, ao deflagrar a investigação, é uma manifestação da:', 'discricionariedade do inquérito policial;', 'confidencialidade do inquérito policial;', 'indisponibilidade do inquérito policial;', 'dispensabilidade do inquérito policial;', 'oficiosidade do inquérito policial.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE - 2024
Estando o indiciado solto, o inquérito policial', 'deve ser concluído no prazo de 30 dias, podendo esse prazo, quando o fato for de difícil elucidação, ser prorrogado, desde que para a realização de diligências necessárias.', 'possui prazo próprio, devendo ser concluído impreterivelmente em 30 dias.', 'não pode ser concluído enquanto não for emitido o respectivo relatório pela autoridade policial, o que impossibilita o oferecimento da denúncia.', 'possui prazo impróprio e não há qualquer limitação temporal à sua conclusão, não se podendo falar em constrangimento ilegal em virtude de demora excessiva em sua tramitação.', 'deve ser concluído no prazo de 10 dias, sendo possível a sua prorrogação, mediante autorização judicial.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE - 2024
A respeito do inquérito policial, julgue o item seguinte.
O princípio da ampla defesa e do contraditório é amplamente aplicável ao inquérito policial, uma vez que este é procedimento meramente administrativo.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE - 2024
A respeito do inquérito policial, julgue o item seguinte.
Uma das principais características do inquérito policial é a sua indisponibilidade, não podendo a autoridade policial proceder ao seu arquivamento, ainda que o fato apurado não configure crime.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (7, 'CESPE/CEBRASPE - 2024
Delegacia de polícia do município X recebeu denúncia anônima de possível desvio de verbas públicas por servidores públicos municipais que estariam envolvidos em esquema de corrupção para desviar, para benefício pessoal, fundos destinados a projetos de infraestrutura.
A partir dessa situação hipotética, julgue o item que se segue.
No curso do inquérito policial, os indiciados poderão requerer qualquer diligência, que será realizada, ou não, a juízo da autoridade.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Direito Processual Penal - Aula 04. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
CESPE/ CEBRASPE– 2025
Texto
No Brasil, pode dizer-se que só excepcionalmente tivemos um sistema administrativo e um corpo de funcionários puramente dedicados a interesses objetivos e fundados nesses interesses. Ao contrário, é possível acompanhar, ao longo de nossa história, o predomínio constante das vontades particulares que encontram seu ambiente próprio em círculos fechados e pouco acessíveis a uma ordenação impessoal. Dentre esses círculos, foi sem dúvida o da família aquele que se exprimiu com mais força e desenvoltura em nossa sociedade. E um dos efeitos decisivos da supremacia incontestável, absorvente, do núcleo familiar — a esfera, por excelência, dos chamados “contatos primários”, dos laços de sangue e de coração — está em que as relações que se criam na vida doméstica sempre forneceram o modelo obrigatório de qualquer composição social entre nós. Isso ocorre mesmo onde as instituições democráticas, fundadas em princípios neutros e abstratos, pretendem assentar a sociedade em normas antiparticularistas.
Sérgio Buarque de Holanda. Raízes do Brasil. São Paulo: Companhia das Letras, 1995, p. 146.
Em relação às propriedades linguísticas e semânticas do texto precedente, julgue o item seguinte.
No quarto período, o segmento “o modelo obrigatório de qualquer composição social entre nós” exerce a função de complemento da forma verbal “forneceram”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE– 2025
Texto
Com o próximo casamento e partida para a Europa de minha filha Susana, andei arquitetando um meio de extorquir-lhe o meu retrato, feito por Candinho Portinari em 1938, que ora lhe pertence, de que muito gosto e que deve ter, aliás, na obra do pintor, certa importância, pois foi o primeiro, ao que eu saiba, realizado com inteira liberdade, depois da grande série de “retratos sociais” (chamemo-los assim, sem qualquer desdouro, nem para o artista, nem para os retratados) que ele andou pintando de alguns membros ilustres de nossa sociedade e de nossa inteligência. Lembra-me mesmo que, ao me propor fazê-lo, sabendo que eu estava de partida para a Inglaterra, Candinho sugeriu-me, com aquela eterna rabugice sua, que eu o deixasse pintar livremente, pois estava um pouco cansado do gênero de retratos que fazia e que tanto afagavam a vaidade da maioria dos retratados. Sei que em duas poses, em sua antiga casa das Laranjeiras, o retrato estava pronto e era como se se respirasse um novo ar dentro dele. Dias depois, estando eu no cais para embarcar em minha primeira grande viagem, chega ele sobraçando o retrato, que vinha oferecer-me. Mas a primogênita foi inflexível, no egoísmo do seu amor filial.
Vinicius de Moraes. Para viver um grande amor. 2008, p. 34 (com adaptações).
Em relação aos sentidos e a aspectos linguísticos do texto apresentado, julgue o item que se segue.
O trecho “Lembra-me mesmo que” (segundo período), em que o verbo lembrar é empregado de modo formal, pode ser reescrito, sem prejuízo de significação e mantendo-se o registro de formalidade, por Eu me lembro que.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE– 2024
Texto CB1A1
Um projeto de lei que determina critérios mínimos de qualidade para escolas públicas de educação básica foi aprovado na Comissão de Constituição e Justiça (CCJ) do Senado Federal, em abril deste ano. Conforme estabelece o projeto de lei, o poder público deverá equipar todas as unidades do ensino básico com bibliotecas, laboratórios de ciências e informática, acesso à Internet, quadras poliesportivas cobertas, instalações com condições adequadas de acessibilidade, energia elétrica, abastecimento de água potável, esgoto sanitário e manejo de resíduos sólidos.
“As condições listadas não constituem luxo ou privilégio, mas requisitos necessários ao estabelecimento de um padrão mínimo de qualidade nas escolas brasileiras e garantia do exercício digno do direito público subjetivo à educação básica”, justifica o autor da proposta.
“O que há no projeto é o mínimo para que uma escola funcione, atendendo os estudantes e os profissionais da educação com dignidade. A ausência de laboratórios, de Internet, de bibliotecas e de uma estrutura física adequada é algo que impacta diretamente na qualidade da educação oferecida aos estudantes, uma vez que a educação não é uma transmissão de conhecimento, mas sim a construção deste”, considera a secretária de assuntos educacionais da Confederação Nacional dos Trabalhadores em Educação (CNTE), Guelda Andrade.
“Um ar-condicionado, por exemplo, em algumas regiões do país, não é questão de luxo. É uma condição que faz parte dessa estrutura mínima e digna para que a educação aconteça... A falta disso traz prejuízos drásticos tanto no aprendizado dos estudantes quanto no cotidiano dos profissionais da educação”, reforça Guelda Andrade.
Internet: <https://cnte.org.br> (com adaptações).
Julgue o próximo item, a respeito dos sentidos e aspectos linguísticos do texto CB1A1.
A correção gramatical e os sentidos do texto seriam mantidos se ambas as ocorrências do vocábulo ‘os’ em ‘os estudantes e os profissionais’ (primeiro período do terceiro parágrafo) fossem substituídas por aos.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CG1A1
A defesa das florestas deveria ser objeto de um tratado internacional que reunisse o maior número de Estados, para que elas se tornassem intocáveis. Repito: a sobrevivência da nossa espécie depende da funcionalidade desses ecossistemas. Sem florestas suficientes, não existe chance real de podermos reverter a tendência de crescimento do CO2. O desmatamento deveria ser tratado como um crime contra a humanidade e punido como tal. Porque é disso que se trata. A proteção das florestas e sua manutenção, bem como a obrigação de manter intactos o solo, o ar e a água, deveriam fazer parte das constituições de todos os Estados, não apenas desta nossa Constituição da Nação das Plantas. Deveriam ser ensinadas nas escolas para crianças e adultos, em todos os lugares. Diretores de cinema deveriam fazer filmes, escritores deveriam escrever livros. Todos estão convocados a se mobilizar, e se vocês acham que é exagero e não veem motivo real para se levantar do sofá e defender o meio ambiente e as florestas, saibam que essa é a única emergência global real. A maioria dos problemas que afligem a humanidade hoje, mesmo que aparentemente distantes, está relacionada ao risco ambiental e consiste apenas na ponta de um iceberg, se não tratarmos o tema com a devida firmeza e eficiência.
Stefano Mancuso. A nação das plantas.
São Paulo: Ubu Editora, 2024, p. 78 (com adaptações).
Com relação a propriedades morfossintáticas do texto CG1A1, julgue o item que se segue.
Em “na ponta” (último período), a substituição de “na” por da prejudicaria a correção gramatical do texto.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CG3A1
Além de ser fonte de prazer, a ficção permite ao leitor aprender com a experiência ficcional. A simulação é usada, por exemplo, para se aprender a pilotar um avião, pois é útil passar um tempo em um simulador de voo. Apesar de ser essencial a prática em um avião real, na maior parte do tempo, não acontece muita coisa no ar. Já no ambiente seguro de um simulador, é possível enfrentar as mais diversas experiências e ensaiar como responder a situações críticas — e as habilidades aprendidas são transferidas ao pilotar um avião. Da mesma forma, quando nos envolvemos nas tramas da ficção, o que aprendemos é transferido para nossas interações cotidianas.
Ao compartilhar indiretamente os acontecimentos da história e fazer inferências sobre o desenvolvimento da trama, o leitor expande sua empatia. Ou seja, alinha seus pensamentos e suas emoções com os das personagens. Imagens de ressonância magnética mostraram que, quando as pessoas leem a descrição de ações, como “subindo as escadas”, a leitura leva à simulação do conteúdo motor e emocional no cérebro, acompanhada por mudanças nas regiões cerebrais que provocam as ações, como se o leitor as estivesse realizando.
Internet:<brasil.elpais.com> (com adaptações)
No que se refere à regência verbal, seriam preservados a correção gramatical e os sentidos do texto CG3A1 caso fosse substituída a forma verbal', '“permite” (primeiro período do primeiro parágrafo) por deixa.', '“leva” (último período do último parágrafo) por ocasiona.', '“responder” (penúltimo período do primeiro parágrafo) por confrontar.', '“expande” (primeiro período do último parágrafo) por amplia.', '“alinha” (segundo período do último parágrafo) por equivale.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB1A1-II
Segundo dados da Pesquisa Nacional por Amostra de Domicílios Contínua (PNAD Contínua, 2022), 18,3% dos jovens de 14 a 29 anos não concluíram alguma das etapas da educação básica seja por abandono, seja por nunca terem frequentado a escola. Sabe-se que a evasão é multifatorial, uma vez que são várias as razões que conduzem ao abandono escolar. A necessidade de trabalhar e o desinteresse pelo estudo foram os principais motivos apontados na pesquisa.
O público da educação de jovens e adultos (EJA) é caracterizado pela diversidade: diversidade de experiências escolares e de vivências no mundo do trabalho, diversidade geracional, além daquelas presentes em todas as salas de aula, como a diversidade étnico-racial e de gênero. Defendemos a inserção do termo “idosos”, porque reconhece e enfatiza a necessidade de oferecer oportunidades educacionais a todas as faixas etárias que não tiveram acesso à educação formal ou que desejam retomar seus estudos. Utilizar a expressão completa — educação de jovens, adultos e idosos (EJAI) — busca promover a igualdade de oportunidades, o que pode ajudar a combater e evitar preconceitos e estereótipos.
Paula Cobucci; Weruska Machado.
Educação linguística para jovens e adultos.
São Paulo: Editora Contexto, p. 7-8 (com adaptações).
Julgue o item que se segue, em relação a estruturas linguísticas do texto CB1A1-II.
O emprego da preposição “a” em “a todas as faixas etárias” (segundo período do segundo parágrafo) justifica-se pela regência do substantivo “oportunidades”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Assinale a frase em que a preposição DE é uma exigência da regência de um termo anterior.', 'O sorriso da filha adoça a fúria DE um pai.', 'DE todos os animais, os meninos são os mais difíceis de domar.', 'Espera DE teu filho oque fizeste com teu pai.', 'Ter crianças é como ter um jogo DE boliche instalado no seu cérebro.', 'Nunca se ouviu dizer que filho valente tivesse nascido DE pai temeroso.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 14. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
CESPE/CEBRASPE– 2025
Texto
De acordo com o Plano das Nações Unidas sobre Discursos de Ódio, a prática do discurso de ódio se caracteriza como um tipo de comunicação falada, escrita ou comportamental que ataca ou utiliza linguagem pejorativa ou discriminatória em referência a uma pessoa ou grupo, com base em fatores de identidade, como religião, etnia, gênero, entre outros. Diferentemente da desinformação (prática não intencional de compartilhamento de informações imprecisas), ou da distribuição intencional de informações falsas com o intuito de provocar dano, o discurso de ódio se expressa de forma violenta contra grupos delimitados.
O discurso de ódio online pode ser reproduzido em diferentes formatos, mas geralmente contém características típicas do meio digital, como o anonimato do(a) autor(a), o alcance expandido do ataque, a instantaneidade da mensagem e a formação de comunidades em torno do discurso.
Eduardo Georjão Fernandes e Valentina Fonseca da Luz.
O papel das políticas públicas no combate ao discurso de ódio na Internet.
Internet:<agenciagov.ebc.com.br> (com adaptações).
Considerando aspectos linguísticos do texto precedente e as ideias nele veiculadas, julgue o item que se segue.
No trecho “em referência a” (primeiro período do texto), a inserção do sinal indicativo de crase no vocábulo “a” seria gramaticalmente incorreta.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE– 2025
Texto CB1A1
Embora as instituições nacionais ligadas à soberania venham atuando nas últimas décadas em suporte às políticas ambientais brasileiras, a relação entre as duas esferas nem sempre se deu em bases cooperativas. Partindo-se de uma compreensão estreita da segurança, a preservação do meio ambiente foi vista, durante certo tempo, não como uma precondição para se garantir a segurança nacional e humana, mas como uma ameaça à integridade territorial e aos interesses nacionais brasileiros. Temia-se, nesse sentido, que as inestimáveis riquezas naturais do Brasil despertassem a cobiça internacional, de forma a representar riscos às fronteiras nacionais e ao direito soberano do país de gerenciar seus recursos naturais de maneira autônoma, em busca do desenvolvimento.
Vigorava, portanto, a compreensão de que assumir compromissos de cooperação na arena ambiental implicaria o decréscimo da soberania nacional. O posicionamento defendido pela delegação brasileira durante a Conferência das Nações Unidas sobre Meio Ambiente Humano (CNUMAH), realizada em Estocolmo em 1972, seria sintomático desse entendimento: “Na área do aproveitamento de recursos naturais, os interesses nacionais, em termos econômicos e de segurança, são de tal monta, que qualquer fórmula que, sob o pretexto ecológico, impusesse uma sistemática de consulta para projetos de desenvolvimento seria simplesmente inaceitável para o Brasil.”
Nas décadas posteriores, as interpretações relativas às preocupações ambientais foram gradualmente transformadas, tanto no âmbito da sociedade quanto em meio às instituições de defesa. O processo de redemocratização, o fortalecimento de organizações da sociedade civil, o avanço dos estudos científicos e a consolidação de uma estrutura federal de governança ambiental favoreceram essas novas percepções e, sobretudo, a aproximação desses dois setores.
Internet:<soberaniaeclima.org.br>  (com adaptações).
Julgue o item seguinte, relativo a aspectos linguísticos do texto CB1A1.
É facultativo o emprego do sinal indicativo de crase no vocábulo “às” em “às fronteiras” (terceiro período do primeiro parágrafo).', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE– 2024
Texto CB1A1-I
O aforismo “o cliente sempre tem razão” é bastante conhecido e muito citado como argumento econômico. Justifica-se para manter a fidelidade dos consumidores a marcas e a lojas a fim de evitar que a insatisfação individual se torne uma indesejada propaganda negativa.
Será que, sob a ótica jurídica, a afirmativa corresponde à realidade? Não! O cliente (consumidor) só tem razão quando o direito, a lei, lhe dá amparo.
Invariavelmente, baseando-se em critério pessoal do que seria justo como solução para problema de consumo, o consumidor realmente acredita que possui o direito que alega e, dentro da sua lógica, passa a exigir determinado comportamento do fornecedor.
A expressão direito do consumidor tem sentido de conjunto de normas que regulam as relações entre consumidores e fornecedores; não significa necessariamente que o consumidor tem sempre direito de exigir a satisfação dos seus interesses.
Para ilustrar, cite-se o exemplo, recorrente, de uma pessoa que acredita poder, em qualquer circunstância, trocar um produto que acabou de adquirir simplesmente porque, chegando em casa, percebeu que não era exatamente aquilo que queria, preferia de outra cor ou até haver gastado o dinheiro com algo mais interessante. Para a lei, a troca ou devolução do dinheiro pago só é possível em situações bem concretas: promessa do vendedor de trocar ou devolver o dinheiro (art. 30 do Código de Defesa do Consumidor); vício do produto (art. 18); compra fora do estabelecimento físico (art. 49).
Daí a importância de que toda pessoa tenha uma noção básica de quais são os seus direitos e de como exigir a sua observância. Como é possível exigir respeito a sua condição de consumidor se não houver uma consciência mínima dos direitos?
Leonardo Bessa. O cliente – nem sempre – tem razão! In: Metrópoles. 20/06/2024. Internet: (com adaptações).
Considerando os aspectos linguísticos do texto CB1A1-I, julgue o item a seguir.
Prejudicaria a correção gramatical do texto a substituição do trecho “a marcas e a lojas” (segundo período do primeiro parágrafo) por à marcas e à lojas.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB1A1
O racismo estrutural é uma realidade cotidiana no Brasil, e as denúncias de atitudes racistas estão se tornando mais visíveis. Porém, o racismo institucional, que acontece dentro de organizações públicas e privadas em diversos setores, ainda é um conceito pouco familiar para muitas pessoas. Mesmo afetando diretamente milhões de brasileiros, esse tipo de racismo é menos conhecido.
O racismo institucional vai além das atitudes individuais e ações isoladas. Ele está enraizado nas políticas, nos procedimentos e nas práticas das organizações. Isso significa que não se trata apenas de como as pessoas se comportam, mas também de como as estruturas e normas podem favorecer ou prejudicar grupos raciais específicos.
Essas manifestações de racismo dentro das instituições podem ser observadas em várias áreas, desde a maneira como o pessoal é selecionado e promovido até a distribuição de recursos. Isso pode resultar em desigualdades sistêmicas que afetam grupos pertencentes a minorias raciais, limitando suas oportunidades e o reconhecimento de suas contribuições.
Essa dimensão do racismo é frequentemente menos reconhecida do que as formas mais óbvias de preconceito racial, mas seu impacto é duradouro e pode contribuir significativamente para a manutenção de desigualdades com base na raça. O racismo institucional é um conceito-chave para compreender como as estruturas e práticas das organizações podem perpetuar a discriminação racial, mesmo que não haja intenções individuais de discriminar. É um problema complexo que requer atenção, portanto, reconhecer e abordar as maneiras como se manifesta o racismo institucional é fundamental para promover a igualdade racial nos espaços de trabalho.
Internet: <www.gov.br> (com adaptações).
Com relação a aspectos linguísticos do texto CB1A1, julgue o item seguinte.
Em “a minorias raciais” (segundo período do terceiro parágrafo), é facultativo o emprego do sinal indicativo de crase no vocábulo “a”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto associado
O setor público enfrenta o desafio particular de oferecer serviços públicos cada vez melhores a uma população gradualmente mais bem informada, mais consciente de seus direitos e com expectativas crescentes quanto ao papel do Estado. Devido aos recursos limitados, desenvolver serviços públicos inovadores tem sido visto crescentemente como fator fundamental para sustentar um alto nível de serviços para cidadãos e negócios, bem como para enfrentar desafios sociais e aprimorar o bem-estar social da população.
Diante desse cenário, o discurso científico sobre inovação em compras públicas ganhou maior atenção nas últimas décadas. A União Europeia reconheceu as compras públicas como instrumento de inovação e de provimento de mercados pioneiros para novos produtos, definindo-as como compras de bens e serviços que ainda não existem, que precisam ser aperfeiçoados ou que requerem pesquisa e inovação para atender às necessidades especificadas pelos usuários.
As compras públicas representam grande parte da execução da despesa pública. Entre países da Organização para a Cooperação e Desenvolvimento Econômico (OCDE), a média de gastos públicos representa 12% do GDP (equivalente ao PIB) por ano. No Brasil, anualmente o governo federal gasta, em média, 5% do PIB em compras apenas de bens e serviços. Quando se incluem nos cálculos as despesas efetuadas por estados, municípios e estatais, o percentual chega próximo a 15% do PIB, ou R$ 900 bilhões.
Internet: <www.realp.unb.br> (com adaptações).
Considerando as ideias e os aspectos linguísticos do texto apresentado, julgue o item que se segue.
O emprego do sinal indicativo de crase no vocábulo “a” presente no primeiro período do texto prejudicaria a sua correção gramatical.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto 1A9
Em uma sociedade em que a imagem pública e a privada constituem fatores preponderantes de prestígio, credibilidade e liderança, esses elementos estão, cada vez mais, permeando nossas vidas, nossas formas de agir e de decidir, que estão sob a vigilância de olhares sociais atentos e fiscalizadores. Os ritos e as cerimônias são elementos estratégicos a serviço da construção e da consolidação das imagens das organizações, que se apoiam na credibilidade e na aceitação social das ações e realizações desenvolvidas.
O rito consiste em um conjunto de atos formalizados, expressivos e portadores de uma dimensão simbólica. É caracterizado por uma configuração espaço-temporal específica, por sistemas de linguagem e comportamentos específicos e por signos emblemáticos cujo sentido codificado constitui um dos bens comuns do grupo. O uso do rito é paralelo ao aparecimento da humanidade.
Em todas as sociedades, os grupos sociais participam de acontecimentos ou eventos especiais e únicos. Porém, para cada um desses grupos, os eventos têm um significado diferente. No Brasil, por exemplo, a Copa do Mundo e uma formatura são eventos com rituais reconhecidos por diferentes classes sociais e culturais. Um rito bem executado é mais que uma mera apresentação teatral. Usa elementos e símbolos e evoca a cultura e as crenças dos povos envolvidos.
Os ritos podem ser vistos como algo que não se resume a repetições das coisas reais e concretas do mundo rotineiro. Como coisa real e concreta, consistem no que pode ser materializado e simbolizado. Exemplo disso é a troca de presentes entre personalidades de diferentes culturas ou o aperto de mão entre duas pessoas que se saúdam. Este protocolo é uma forma de comunicação na qual os participantes do processo denotam uma mensagem diplomática. Remete, ainda, ao protocolo elementar significativo de boas relações entre povos, governos ou grupos.
Internet: <uel.br>(com adaptações).', 'No que se refere ao emprego do sinal indicativo de crase, a correção gramatical e a coerência do texto 1A9 seriam mantidas caso se substituísse', '“a repetições” (primeiro período do último parágrafo) por à repetições.', '“ao aparecimento” (último período do segundo parágrafo) por à aparição.', '“sob a vigilância” (primeiro período do primeiro parágrafo) por ante à vigília.', '“a serviço” (segundo período do primeiro parágrafo) por à serviço.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto associado
Preconceito e discriminação são termos próximos. Por vezes, juridicamente, parecem até a mesma coisa, como se depreende do texto da Lei n.º 7.716, de 5 de janeiro de 1989, complementada pela Lei n.º 9.459, de 15 de maio de 1997: “Serão punidos, na forma desta lei, os crimes resultantes de discriminação ou preconceito de raça, cor, etnia, religião ou procedência nacional”. Mesmo assim, o preconceito pode ser definido como uma ideia de distinção, exclusão ou preferência baseada em raça, sexo, religião, origem social ou geográfica etc.; já a discriminação diz respeito à ação decorrente do preconceito. O preconceito é uma opinião; a discriminação, um comportamento real e efetivo.
Sendo um pensamento, o preconceito, a rigor, não é crime. Quando se torna uma ação concreta ou uma afirmação pública, passa a ser discriminação e, a partir daí, é alvo da lei. O preconceito é considerado por nós a matriz que origina o ato discriminatório. Sem preconceito, não existiria discriminação. Ausente de sua expressão concreta discriminatória, o preconceito seria apenas uma fantasmagoria psíquica.
Leandro Karnal e Luiz Estevam. Preconceito: uma história. São Paulo: Companhia das Letras, 2023 (com adaptações).
Em referência às ideias veiculadas no texto apresentado e a seus aspectos linguísticos, julgue o item seguinte.
Sem prejuízo da correção gramatical e dos sentidos do texto, poderia ser incluída a palavra qualquer imediatamente antes de “ação” (terceiro período do primeiro parágrafo).', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Assinale a opção que apresenta a frase em que o acento grave indicativo da crase está mal-empregado.', 'A mulher chega à maturidade quando seus sapatos começam a incomodá-la mais do que os homens.', 'Nunca se deixe fascinar pelo extraordinário à ponto de esquecer o corriqueiro.', 'Olhe à frente, para que a vista preceda os passos.', 'Para levar uma alma à ação é preciso balançar o seu equilíbrio.', 'Não há como conviver com as restrições impostas às mulheres.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
As frases abaixo foram retiradas do romance Iracema, de José de Alencar.
Assinale a única em que o uso do acento grave é facultativo.', 'Caubi saiu para ir à sua cabana, que ainda não tinha visto depois da volta. Iracema foi preparar o moquém da viagem.', 'Se ela não morresse, o jacarandá não teria sol para crescer àquela altura.', 'Ei-lo que volta à terra natal, abraça sua velha mãe, revê mais lindo e terno o anjo puro dos amores infantis.', 'Poti despediu-se triste daqueles lugares, e tornou com seus companheiros à borda do mar.', 'De repente, entre os ramos das árvores, seus olhos viram, sentada à porta da cabana, Iracema com o filho no regaço e o cão a brincar.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Considere o trecho reescrito:
(...) um dia correu até minha mãe e pediu ____ ela que lhe fizesse o favor de ver se lhe salvava o marido que queria dar fim ____ própria vida. (...) Pádua obedeceu; confessou que acharia forças para submeter-se ____ vontade de minha mãe.
A alternativa que completa as lacunas, respectivamente, em conformidade com a norma-padrão de emprego do acento indicativo de crase é:', 'à – à – à.', 'à – a – a.', 'a – a – a.', 'a – à – à.', 'a – à – a.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 16. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
CESPE/CEBRASPE– 2024
Texto CG1A1-I
Investir em educação na primeira infância representa, além de vantagens para o desenvolvimento individual, retorno social e econômico. O economista norte-americano James Heckman, um dos ganhadores do prêmio Nobel na área econômica no ano 2000, conduziu pesquisa que acompanhou, ao longo do tempo, várias crianças com e sem acesso a ensino de qualidade. O objetivo era conferir os impactos da educação no curto, no médio e no longo prazo.
“Os resultados desse trabalho mostram que cada dólar investido traz um retorno social de sete dólares”, aponta Karina Fasson, da Fundação Maria Cecilia Souto Vidigal, organização da sociedade civil que trabalha pela causa da primeira infância. Ela afirma que “as ações educativas voltadas para o começo da vida têm o poder de minimizar a carga que as demais políticas públicas carregam”. Isso quer dizer que investir em educação na primeira infância é uma estratégia eficaz para reduzir os custos sociais no futuro.
Segundo Fasson, quando se pensa em políticas públicas, o retorno é mais significativo na fase pré-escolar que em qualquer outra etapa da vida. “No longo prazo, quem é mais estimulado tem maior aprendizado e maior progressão escolar, e isso tem reflexos na inserção no mercado de trabalho e nos salários, além de favorecer menor envolvimento em situações de vulnerabilidade, como a criminalidade e o uso de drogas, e tem consequências também na saúde das pessoas”, ressalta. Tudo isso, a especialista afirma, não só tem efeito na trajetória educacional, mas também repercute ao longo da vida do indivíduo e impacta a sociedade como um todo.
Internet: <novaescola.org.br> (com adaptações).
A respeito do vocabulário e da estrutura linguística do texto CG1A1-I, julgue o item que se segue.
A supressão da vírgula empregada após “públicas” (primeiro período do terceiro parágrafo) prejudicaria a correção gramatical do texto.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE– 2024
Texto CB1A2-II
O sofista e o ignorante ocupam mais o pensamento de Platão que o mentiroso, e quando ele distingue entre o erro e a mentira — quer dizer, entre “involuntário e voluntário” — é, de modo significativo, mais duro em relação àqueles que “chafurdam na ignorância de porcos” que em relação aos mentirosos. Terá isso acontecido porque era ainda desconhecida a mentira organizada, que domina a coisa pública, à diferença do mentiroso privado que tenta a sua sorte por sua própria conta?
A mentira tradicional implicava apenas particulares e nunca visava enganar literalmente toda a gente; dirigia-se ao inimigo e só a ele queria enganar. Como os fatos se produzem sempre num contexto, uma mentira particular — quer dizer, uma falsificação que não se esforça por alterar todo o contexto — faz, por assim dizer, um buraco no tecido dos fatos. Como todo o historiador sabe, pode-se detectar uma mentira observando-se incongruências, buracos, ou junturas dos espaços consertados. Enquanto a textura no seu todo for conservada intacta, a mentira mostrar-se-á imediatamente de modo espontâneo.
Se as mentiras políticas modernas são tão grandes que requerem um completo rearranjo de toda a textura factual — o fabrico de uma outra realidade, por assim dizer, na qual se encaixam sem costuras, fendas nem fissuras, exatamente como os fatos encaixavam no seu contexto original —, o que é que impede estas histórias, imagens e não fatos novos de se tornarem um substituto adequado da realidade e da factualidade?
Hannah Arendt. Verdade e política. Internet: (com adaptações).
No que concerne aos aspectos linguísticos do texto CB1A2-II, julgue o item subsequente.
Seriam mantidos os sentidos originais do texto e sua correção gramatical caso o trecho “e não fatos novos” (terceiro parágrafo) fosse isolado por vírgulas.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE– 2024
Texto CB1A1-III
Aprendemos desde cedo que a linguagem verbal serve para comunicar e frequentemente dizemos que o importante é a comunicação. Quando se fala em comunicação, muitas vezes, pensamos que se está falando na transmissão de informações. Comunicar não se limita, entretanto, a transmitir informações. Realmente, há momentos em que desejamos apenas fornecer uma informação, mas, muito frequentemente, temos outros objetivos, como: dar uma ordem, expressar um sentimento, fazer um pedido, exercer algum tipo de influência, fazer o outro mudar de opinião...
O ser humano vive em sociedade, isto é, fazemos parte de grupos sociais e agimos em conjunto com nossos semelhantes; interagimos. Na verdade, é para interagir que nos comunicamos, falamos e escrevemos. Por isso, não podemos nos esquecer de que a comunicação, ou a interação, envolve mais do que simplesmente informação; envolve, sobretudo, alguma forma de ação sobre o outro.
Ana Lúcia Tinoco Cabral. A força das palavras.
São Paulo: Editora Contexto, 2010, p. 10-11 (com adaptações).
Considerando os aspectos textuais e linguísticos do texto CB1A1-III, bem como as ideias nele veiculadas, julgue o item seguinte.
No trecho “dar uma ordem, expressar um sentimento, fazer um pedido, exercer algum tipo de influência, fazer o outro mudar de opinião...” (quarto período do primeiro parágrafo), as vírgulas foram empregadas para separar expressões de caráter explicativo.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB1A1
O racismo estrutural é uma realidade cotidiana no Brasil, e as denúncias de atitudes racistas estão se tornando mais visíveis. Porém, o racismo institucional, que acontece dentro de organizações públicas e privadas em diversos setores, ainda é um conceito pouco familiar para muitas pessoas. Mesmo afetando diretamente milhões de brasileiros, esse tipo de racismo é menos conhecido.
O racismo institucional vai além das atitudes individuais e ações isoladas. Ele está enraizado nas políticas, nos procedimentos e nas práticas das organizações. Isso significa que não se trata apenas de como as pessoas se comportam, mas também de como as estruturas e normas podem favorecer ou prejudicar grupos raciais específicos.
Essas manifestações de racismo dentro das instituições podem ser observadas em várias áreas, desde a maneira como o pessoal é selecionado e promovido até a distribuição de recursos. Isso pode resultar em desigualdades sistêmicas que afetam grupos pertencentes a minorias raciais, limitando suas oportunidades e o reconhecimento de suas contribuições.
Essa dimensão do racismo é frequentemente menos reconhecida do que as formas mais óbvias de preconceito racial, mas seu impacto é duradouro e pode contribuir significativamente para a manutenção de desigualdades com base na raça. O racismo institucional é um conceito-chave para compreender como as estruturas e práticas das organizações podem perpetuar a discriminação racial, mesmo que não haja intenções individuais de discriminar. É um problema complexo que requer atenção, portanto, reconhecer e abordar as maneiras como se manifesta o racismo institucional é fundamental para promover a igualdade racial nos espaços de trabalho.
Internet: <www.gov.br> (com adaptações).
Com relação a aspectos linguísticos do texto CB1A1, julgue o item seguinte.
Estariam mantidas a correção gramatical e a coerência das ideias do texto caso os dois primeiros períodos do segundo parágrafo fossem unidos por meio da substituição do ponto empregado após “isoladas” pelo sinal de dois-pontos, feitos os devidos ajustes de letra inicial maiúscula e minúscula no período.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2025
Texto associado
Um cientista empenhado em pesquisa — no campo da física, por exemplo — pode atacar diretamente o problema que enfrenta. Pode penetrar, de imediato, no cerne da questão, isto é, no cerne de uma estrutura organizada. Com efeito, conta sempre com a existência de uma estrutura de doutrinas científicas já existentes e com uma situação-problema que é reconhecida como problema nessa estrutura. Essa é a razão por que pode entregar a outros a tarefa de adequar ao quadro geral do conhecimento científico a sua contribuição.
O filósofo vê-se em posição diversa. Ele não se coloca diante de uma estrutura organizada, mas, antes, em face de algo que semelha um amontoado de ruínas (embora, talvez, haja tesouros ocultos). Não lhe é dado apoiar-se no fato de existir uma situação-problema, geralmente reconhecida como tal, pois não existir algo semelhante é possivelmente o fato geralmente reconhecido. Com efeito, tornou-se agora questão frequente, nos círculos filosóficos, saber se a filosofia chegará a colocar um problema genuíno.
Apesar de tudo, há quem acredite que a filosofia possa colocar problemas genuínos acerca das coisas e quem, portanto, ainda tenha a esperança de ver esses problemas discutidos, e afastados aqueles monólogos desalentadores que hoje passam por discussão filosófica. Se, por acaso, se julgam incapazes de aceitar qualquer das orientações existentes, tudo o que lhes resta fazer é começar de novo, desde o princípio.
Karl Popper. A lógica da pesquisa científica.
Tradução: Leonidas Hegenberg e Octanny Silveira da Mota.
São Paulo: Editora Cultrix, 2008, p. 23 (com adaptações).
Em relação aos sentidos e aspectos linguísticos do texto apresentado, julgue o item subsequente.
No segundo período do segundo parágrafo, a eliminação das vírgulas que isolam o vocábulo “talvez” não prejudicaria a correção gramatical do texto.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB1A1
As plataformas de conectividade são o principal responsável da digitalização da economia, por realizarem a migração dos processos físicos para o mundo digital. Seu avanço tem sido muito expressivo, com uma ampla penetração (93% das pessoas usam aplicativos de mensagens instantâneas) e um aumento significativo do poder concentrado em algumas grandes plataformas, características de um mercado em franca expansão que têm motivado discussões no âmbito regulatório ao redor do mundo. Ainda não há um consenso global em relação à regulação de plataformas de conectividade, estando sua discussão presente em diferentes países.
A União Europeia se mostra como o ente mais avançado nessa discussão, tendo apresentado duas importantes leis, a Digital Services Act (DSA) e a Digital 156 Markets Act (DMA), que poderão servir como benchmark para outros países, sob o ponto de vista regulatório, de experiências praticadas, além de explicitar os seus potenciais impactos no mercado e como ele se adaptará.
No Brasil, não há leis nem regulações que atuem especificamente sobre as plataformas de conectividade. O Marco Civil da Internet e a Lei Geral de Proteção de Dados Pessoais, no entanto, abordam temas transversais do ecossistema digital que são relevantes no contexto de plataformas de conectividade. Alguns projetos de lei, como o PL das Fake News e o PL n.º 2.768/2022, endereçam parte das questões relacionadas a esse nicho de mercado atualmente e devem concentrar as principais discussões.
ANATEL. Relatório II: Avaliação de cenários futuros da economia digital induzidos pelo desenvolvimento de plataformas de conectividade no Brasil, falhas de mercado e lacunas regulatórias. 2023, p. 156-157. Internet:<www.gov.br>  (com adaptações).
Com relação aos sentidos e a aspectos linguísticos do texto CB1A1, julgue o item que se segue.
No segundo período do primeiro parágrafo, seria correto inserir uma vírgula imediatamente depois do trecho entre parênteses — (... instantâneas), e.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV - 2025
Assinale a frase abaixo que está corretamente pontuada.', 'A Internet é uma solução, à procura de um problema.', 'Vencer é 90% suor e 40%, técnica.', 'Os tempos futuros trarão, muitíssimos, outros inventos.', 'Cheguei atrasado e ela, adiantada.', 'Os erros, mais curtos, são os melhores.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Texto associado
Sempre dá para separar um dinheirinho para o futuro. Em sete passos fáceis, veja como:
1. Ande com um caderninho na bolsa e anote tudo o que gasta para saber para onde está indo seu dinheiro.
2. Se você não tem certeza de que conseguirá conter seus impulsos, deixe em casa cartões de crédito e cheques. Estabeleça um limite em dinheiro para carregar na carteira.
3. Planeje suas compras, todas elas, e pague apenas à vista.
4. Sempre pesquise preços e pechinche.
5. Só compre pela internet ou por telefone se for algo necessário, oferecido a um preço ótimo (a internet é um prato cheio para compradores compulsivos). 6. Passe longe das liquidações.
7. Pesquise pacotes econômicos para celular, telefone fixo, internet e TV a cabo.
Elaine Toledo, Cláudia, SP, fev. 2009, p. 83.
Quanto ao critério gramatical, assinale a frase abaixo que se mostra integralmente correta.', 'Quanto menos inteligente um homem é, menos misteriosa a existência lhe parece.', 'Recompense a injúria com justiça, e a gentileza alheia com a tua gentileza.', 'Sabedoria escondida e tesouro invisíveis, para que servem ambos?', 'Um mal começo leva a um mal final.', 'O espírito se dirige onde quer.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Texto associado
Atenção! Leia a crônica para responder à próxima questão.
Outra coisa que não parece ser entendida pelos outros é quando me chamam de intelectual e eu digo que não sou. De novo, não se trata de modéstia e sim de uma realidade que nem de longe me fere. Ser intelectual é usar sobretudo a inteligência, o que eu não faço: uso é a intuição, o instinto. Ser intelectual é também ter cultura, e eu sou tão má leitora que, agora já sem pudor, digo que não tenho mesmo cultura. Nem sequer li as obras importantes da humanidade. Além do que leio pouco: só li muito, e li avidamente o que me caísse nas mãos, entre os treze e os quinze anos de idade. Depois passei a ler esporadicamente, sem ter a orientação de ninguém. Isto sem confessar que – dessa vez digo-o com alguma vergonha – durante anos eu só lia romance policial. Hoje em dia, apesar de ter muitas vezes preguiça de escrever, chego de vez em quando a ter mais preguiça de ler do que de escrever.
Literata também não sou porque não tornei o fato de escrever livros “uma profissão”, nem uma “carreira”. Escrevi-os só quando espontaneamente me vieram, e só quando eu realmente quis.
O que sou então? Sou uma pessoa que tem um coração que por vezes percebe, sou uma pessoa que pretendeu pôr em palavras um mundo ininteligível e um mundo impalpável. Sobretudo uma pessoa cujo coração bate de alegria levíssima quando consegue em uma frase dizer alguma coisa sobre a vida humana ou animal.
LISPECTOR, Clarice. A descoberta do mundo. Rio de Janeiro: Rocco, 1999. Adaptado.
A respeito do emprego dos sinais de pontuação no trecho, é correto afirmar que, em', '“Ser intelectual é usar sobretudo a inteligência, o que eu não faço: uso é a intuição, o instinto”, o sinal de dois-pontos introduz uma citação.', '“Isto sem confessar que – dessa vez digo-o com alguma vergonha – durante anos eu só lia romance policial”, os travessões servem para indicar a mudança de interlocutor.', '“... só li muito, e li avidamente o que me caísse nas mãos...”, a vírgula serve para separar os termos de uma enumeração.', '“Hoje em dia, apesar de ter muitas vezes preguiça de escrever...”, a vírgula isola um adjunto adverbial deslocado de sua posição habitual na frase.', '“... não tornei o fato de escrever livros “uma profissão”, nem...”, as aspas em “uma profissão” indicam o emprego de um termo em contexto diferente do habitual.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Leia o texto a seguir, do qual foram excluídos alguns sinais de pontuação:
Ao longo das últimas décadas___ vários estudos apontam uma relação entre o uso de mídias digitais na infância e um menor desenvolvimento cognitivo, mas só agora a ciência descobriu como isso acontece___ Pesquisadores da Universidade de Hong Kong, em um estudo com mais de 30 mil crianças___ constataram que o uso crônico de telas na infância prejudica a neuroplasticidade___ a formação e a reorganização de redes neurais dentro do cérebro conforme vamos crescendo e aprendendo.
GARATONI, Bruno. Uso de telas afeta o cérebro das crianças. Superinteressante, n. 458, edição dez. 2023, p. 15 Adaptado.
Em sequência, os sinais de pontuação que devem ser usados nas lacunas são:', 'vírgula, ponto final, vírgula, interrogação.', 'interrogação, ponto final, vírgula, ponto final.', 'ponto final, vírgula, dois pontos, vírgula.', 'vírgula, ponto final, interrogação, ponto final.', 'vírgula, ponto final, vírgula, dois pontos.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Português - Aula 18. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
FCC – 2024
Direito natural e direito dos homens
O direito natural é aquele que a natureza mesma determina a todos os homens. Educastes vossos filhos, ele vos deve respeito como seu paí, reconhecimento como seu benfeitor. Tendes direito sobre a terra que cultivastes com vossas próprias mãos.
O direito humano só pode ser fundado no direito da natureza, e o grande princípio, o princípio universal de um e outro, é em toda terra: “Não faças o que não gostarias que te fizessem”.
Contentam-se alguns, noutras terras, em afirmar: “Crê em mim, ou eu te odiarei; crê, ou te farei todo o mal que eu puder. Monstro, não tens a minha religião, então não tens religião nenhuma.”
O direito da intolerância é, então, absurdo e bárbaro: é o direito dos tigres, sendo no entanto bem pior, pois os tigres só se dilaceram por comida, e nós nos exterminamos por parágrafos.
(Adaptado de: VOLTAIRE. Tratado sobre a tolerância. Trad. Ana Luiza Reis Bedê. São Paula: Martim Cererê, 2017. p. 36)
De acordo com Voltaire, o direito natural e o direito dos homens', 'caracterizam-se pelo afastamento que mantêm de valores morais ou de mérito.', 'mantêm entre eles um grau de tolerância reciproca altamente inspiradora.', 'complementam-se, acima de qualquer pressuposto de hierarquização ou precedência.', 'inspiram-se reciprocamente ao longo da história, numa permanente relação dialética.', 'ligam-se pela absorção dos fundamentos da natureza pelos do direito humano.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 01 - Compreensão e Interpretação de textos. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FCC – 2024
Tira férias
A noção de férias está ligada a figuras de viagem, esporte, aplicações intensivas do corpo, quase nada a descanso. As pessoas executam durante esse intervalo aquilo que não puderam fazer ao longo do ano; fazem “mais” alguma coisa, de sorte que não há férias, no sentido religioso e romano de suspensão de atividades.
Matutando nisso, resolvi tirar férias e gozá-las como devem ser gozadas, sem esforço para torná-las amenas. A ideia de viagem foi expulsa do programa: é das iniciativas mais comprometedoras e tresloucadas que poderia tomar o trabalhador vacante. As viagens ou não existem, como é próprio da era do jato, em que somos transportados em velocidade superior à do nosso poder de percepção e de ruminação de impressões, ou existem demais como burocracia de passaporte, filas, falta de vaga em hotel, atrasos, moeda aviltada, alfândega, pneu estourado no ermo, que mais?
Tudo aboli e fiz a experiência das férias propriamente ditas. Se me pedirem para contar o que fiz afinal nestas férias, direi legalmente: ignoro. Aos convites disse não, alegando estar em férias, alegação tão forte como a de estar ocupadíssimo. Durante esse período, o pensamento errou entre mil paragens, não se deteve em nenhuma; cada dia amadureceu e caiu como um fruto. Nada aconteceu? O não acontecimento é a essência das férias. E agora, é trabalhar duro onze meses para merecer as inofensivas e deliciosas férias do não.
(ANDRADE, Carlos Drummond. Cadeira de balanço. 22a. ed. Rio de Janeiro: Record, 2009, p. 69-71)
O autor do texto, diante da perspectiva de tirar férias,', 'afirma que elas não o seduzem como a dura atividade há muito já imposta aos romanos.', 'define-se como um amador a quem falta toda a experiência dos turistas mais convictos.', 'reluta em aceitar gozá-las no sentido convencional, mas acaba por fruir uma boa viagem.', 'mostra-se desconfiado diante das ofertas de viagem que lhe parecem tão sedutoras.', 'declara sua impossibilidade de extrair algum prazer do esforço que elas lhe demandam.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 01 - Compreensão e Interpretação de textos. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Texto CB1A1 – PARA AS QUESTÕES 3 Á 5
O racismo estrutural é uma realidade cotidiana no Brasil, e as denúncias de atitudes racistas estão se tornando mais visíveis. Porém, o racismo institucional, que acontece dentro de organizações públicas e privadas em diversos setores, ainda é um conceito pouco familiar para muitas pessoas. Mesmo afetando diretamente milhões de brasileiros, esse tipo de racismo é menos conhecido.
O racismo institucional vai além das atitudes individuais e ações isoladas. Ele está enraizado nas políticas, nos procedimentos e nas práticas das organizações. Isso significa que não se trata apenas de como as pessoas se comportam, mas também de como as estruturas e normas podem favorecer ou prejudicar grupos raciais específicos.
Essas manifestações de racismo dentro das instituições podem ser observadas em várias áreas, desde a maneira como o pessoal é selecionado e promovido até a distribuição de recursos. Isso pode resultar em desigualdades sistêmicas que afetam grupos pertencentes a minorias raciais, limitando suas oportunidades e o reconhecimento de suas contribuições.
Essa dimensão do racismo é frequentemente menos reconhecida do que as formas mais óbvias de preconceito racial, mas seu impacto é duradouro e pode contribuir significativamente para a manutenção de desigualdades com base na raça. O racismo institucional é um conceito-chave para compreender como as estruturas e práticas das organizações podem perpetuar a discriminação racial, mesmo que não haja intenções individuais de discriminar. É um problema complexo que requer atenção, portanto, reconhecer e abordar as maneiras como se manifesta o racismo institucional é fundamental para promover a igualdade racial nos espaços de trabalho.
Internet: <www.gov.br> (com adaptações).
CESPE/CEBRASPE – 2024
Com relação a aspectos linguísticos do texto CB1A1, julgue o item seguinte.
Mantendo-se as ideias e a correção gramatical do texto, o terceiro período do segundo parágrafo poderia ser reescrito da seguinte forma: Isso significa que o racismo institucional não se trata apenas de como as pessoas se comportam, mas, também, de como as estruturas e as normas podem proteger ou prejudicar grupos raciais específicos.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 01 - Compreensão e Interpretação de textos. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Julgue o item que se segue, relativo às ideias veiculadas no texto CB1A1.
Conclui-se do texto que o conhecimento sobre o racismo institucional é relevante para a promoção da igualdade racial no ambiente laboral.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 01 - Compreensão e Interpretação de textos. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE – 2024
Julgue o item que se segue, relativo às ideias veiculadas no texto CB1A1.
O texto trata o racismo institucional como um tipo de cultura existente dentro de instituições públicas e privadas.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 01 - Compreensão e Interpretação de textos. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
FGV – 2024
Assinale a frase abaixo que não exemplifica um texto injuntivo.', 'Quando ouvir falar bem de um amigo, conte isso a ele.', 'Nunca ajude uma criança a fazer a sua tarefa enquanto ela sentir que pode ser bem-sucedida sozinha.', 'Se não puder abraçar as crianças, guarde-as em seu coração.', 'Faço plástica só no corpo. Meu rosto já é lindo por natureza.', 'Trate seus amigos como você faz com seus quadros: coloque-os em um lugar mais iluminado.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 02 - Tipologia Textual. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Todos os fragmentos textuais a seguir são do tipo narrativo; o fragmento que mostra uma sucessão de acontecimentos e não de ações, é:', 'O porteiro meteu a chave na fechadura e abriu a porta do apartamento.', 'A chuva caiu durante a noite e inundou várias ruas.', 'O assaltante viu a chegada da polícia e abandonou o local.', 'Escrevi uma longa carta para ela e a depositei no correio.', 'Os portugueses chegaram ao Brasil em 1500 e criaram uma colônia.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 02 - Tipologia Textual. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB4A1-I
Existem desde previsões de que a inteligência artificial (IA) substituirá os seres humanos e eliminará uma lista de profissões até alegações de que ela contribuirá para “o uso humano dos seres humanos” (parafraseando-se o subtítulo do livro de 1954 do matemático considerado fundador da cibernética, Norbert Wiener), liberando-os para usarem melhor o tempo enquanto assume as tarefas repetitivas.
Um grupo de pesquisadores de diversos países produziu a publicação Inteligência Liberada — um argumento para a IA na educação, para demonstrar os benefícios da IA para a educação.
É importante, nesse ponto, definir o que é a IA aplicada na educação — algo que vem sendo estudado no meio acadêmico há mais de três décadas. Para os autores da publicação mencionada, IA corresponde a “sistemas de computador que foram projetados para interagir com o mundo por meio de capacidades (por exemplo, percepção visual e reconhecimento de fala) e comportamentos inteligentes (por exemplo, avaliar as informações disponíveis e, em seguida, tomar a ação mais sensata para atingir um objetivo declarado) que seriam considerados essencialmente humanos”.
Um dos objetivos do uso da IA na educação é abrir a chamada “caixa-preta do aprendizado”, ou, em outras palavras, contribuir para uma compreensão mais profunda e detalhada de como o aprendizado realmente acontece (por exemplo, como é influenciado pelo contexto socioeconômico e físico dos alunos ou por tecnologia).
Nesse contexto, a IA na educação oferece a possibilidade de uma aprendizagem mais personalizada, flexível, inclusiva e envolvente. Além disso, as ferramentas fornecem informações não apenas sobre o que está sendo aprendido, mas também como está sendo aprendido e como os alunos estão se sentindo. Ainda, a IA pode ajudar os professores a criar ambientes de aprendizagem colaborativa e a atender as necessidades de seus alunos por meio de técnicas de mineração de dados educacionais para “rastrear” o comportamento dos alunos.
Internet:<observatoriodeeducacao.institutounibanco.org.br>  (com adaptações).
A respeito do texto CB4A1-I e das ideias nele veiculadas, julgue o item que se segue.
O texto é, essencialmente, informativo.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 02 - Tipologia Textual. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
A ideia de que a mente pertence a um domínio separado, distinto do corpo, foi teorizada bem cedo, em grandes textos como o Fédon, de Platão (IV a.C.) e a Suma teológica, de Tomás de Aquino (1265-1274), um texto fundador da concepção cristã da alma. Mas foi o filósofo francês René Descartes (1596-1650) quem estabeleceu aquilo que é hoje conhecido como dualismo: a tese de que a mente dotada de consciência é feita de uma substância imaterial que não está sujeita às leis da física.
Ridicularizar Descartes tornou-se moda em neurociência. Depois da publicação, em 1994, de O erro de Descartes, o best-seller de Antonio Damasio, muitos manuais contemporâneos que tratam de consciência passaram a criticar Descartes, alegando que ele teria atrasado a pesquisa em neurociência. A verdade, porém, é que Descartes foi um cientista pioneiro, fundamentalmente um reducionista, cuja análise mecânica da mente humana, muito à frente de seu tempo, foi o primeiro exercício de biologia sintética e de modelagem teórica. O dualismo de Descartes não foi um capricho de momento — fundamentava-se em um argumento lógico que afirmava a impossibilidade, para qualquer máquina, de imitar a liberdade da mente consciente.
Stanislas Dehaene. É assim que pensamos: como o cérebro trabalha para tomarmos consciência do mundo. Trad.: Rodolfo Ilari. São Paulo: Editora Contexto, 2024, p. 12 (com adaptações).
Em relação às ideias e estruturas linguísticas do texto apresentado, julgue o item que se segue.
O último período do texto é construído com base na tipologia argumentativa.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 02 - Tipologia Textual. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CG3A1
— Afinador de piano, em excursão, vinte e cinco mil-réis.
— Quanto?
— Vinte e cinco mil.
— É exagero. Às vezes o afinador não ganha isso durante a viagem. O Juca Silveira me contou. A principal fonte de renda dele é a criação de perus. E já paga imposto de indústria e profissão…
— Bem, se nós formos indagar dos contribuintes quanto é que eles querem pagar, a tesouraria fica sem recursos para comprar um maço de velas quando faltar luz. Seria preferível que eles mesmos fizessem o lançamento.
A Câmara Municipal discutia o orçamento para 1920, e os dois vereadores ponderavam ponto por ponto cada título da receita. O município é pobre, arrecada setenta e dois contos por ano. Houve praga na lavoura; deu peste no gado; o empréstimo para instalação de luz elétrica vence juros penosos. Para atender ao serviço de estradas, à instrução, às eleições, ao funcionalismo, a tanto compromisso, torna-se imperioso lançar novos impostos, criar taxas inéditas, como essa de afinador. Mas piano — quantos pianos terá o município? Quinze, no máximo; dos quais apenas uns cinco nos distritos: a taxa talvez não produza cinquenta mil-réis. Uma ninharia, meu caro!
No calor da sala, os vereadores tentam reerguer as finanças públicas. Salão muito quente, com efeito. Dá para a frente da praça, que recolhe o sol da tarde, ao passo que a outra sala, olhando para a montanha e o vale profundo, recebe uma doce brisa, em que narinas mais apuradas distinguem o perfume de árvores distantes, e os caçadores chegam a identificar um cheiro de anta. No inverno, sim, a sala das sessões recomenda-se pelo aconchego — mas o orçamento é feito naquela época do ano em que as cigarras estouram, e secam os córregos.
— Barbeiro com uma só cadeira, vinte mil-réis na cidade; em outros lugares, dezoito mil. Cada mão de engenho de mineração, quando fabricada no país...
Carlos Drummond de Andrade. Câmara e cadeia. In: Contos de aprendiz.
Companhia das Letras (com adaptações).
Quanto ao tipo textual, o texto CG3A1 classifica-se como', 'argumentativo.', 'injuntivo.', 'narrativo.', 'descritivo.', 'dissertativo.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 02 - Tipologia Textual. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
FGV – 2024
Assinale a opção que mostra uma acentuação gráfica incorreta.', 'água, paciência.', 'caráter, mártir.', 'bênção, órgão.', 'inteligênte, possível.', 'lâmpada, próprio.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Em alguns vocábulos, o acento tônico pode ter valor distintivo, ou seja, mostra duas palavras diferentes.
Assinale a opção em que isso não ocorre.', 'périto e perito.', 'dúvida e duvida.', 'história e historia.', 'crédito e credito.', 'público e publico.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto associado
Um balanço feito pelo Instituto Sou da Paz e pelo INSPER mostrou que, em 2021, o Distrito Federal registrou a menor taxa de homicídios dos últimos 45 anos, mesmo com o aumento da população. Em Alagoas, os indicadores do mesmo crime caíram 14,8%. De acordo com o Segundo Balanço das Políticas de Gestão para Resultados na Segurança Pública, em São Paulo reduziu-se em 49% o roubo de veículos entre 2014 e 2021.
O documento evidencia iniciativas estaduais que representam boas práticas na área de segurança pública. Segundo a diretora executiva do Instituto Sou da Paz, a pesquisa encontrou 11 estados com programas de gestão de resultado. O destaque é o Espírito Santo, que tem uma ação mais longeva e consegue manter um programa central que envolve as polícias com resultados importantes na redução dos homicídios. “São programas que, embora não sejam uma panaceia, conseguem contribuir muito para a integração das polícias, dão uma ferramenta para o secretário de segurança coordenar, dão uma visão de longo prazo para a segurança pública nos estados, o que não é algo trivial”, disse a diretora.
“O estabelecimento de diretrizes baseadas em evidências é essencial para a promoção de melhorias na segurança pública dos estados brasileiros”, afirmou um professor do Centro de Gestão e Políticas Públicas do INSPER. Ele acrescentou que o balanço apresentado pelo instituto e pelo Sou da Paz buscou analisar o que funciona para a área, quais estados alcançaram sucesso nos últimos anos e como os gestores podem orientar propostas para conseguir os melhores resultados possíveis.”
Internet: <https://agenciabrasil.ebc.com.br> (com adaptações).
Em relação às ideias e a aspectos linguísticos do texto apresentado, julgue o item a seguir.
Os vocábulos “homicídios” e “caíram” são acentuados graficamente de acordo com a mesma regra de acentuação gráfica.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB2A1
A força das renováveis
Um dos maiores parques eólicos da América do Sul começou a operar em junho de 2021 em pleno sertão piauiense. Situado 500 quilômetros (km) ao sul da capital Teresina, o complexo Lagoa dos Ventos é formado por 230 aerogeradores, responsáveis por converter a força dos ventos em eletricidade, instalados no alto de torres de 118 m de altura. O empreendimento, fruto de um investimento de R$ 3 bilhões de uma empresa italiana, vai gerar 3,3 terawatts-hora (TWh) de energia por ano, volume suficiente para abastecer 1,6 milhão de residências. A energia limpa e renovável gerada no local evitará a emissão de mais de 1,9 milhão de toneladas de dióxido de carbono (CO2) na atmosfera, quando comparado a uma usina termelétrica, segundo a companhia. Uma expansão em curso, ainda sem data para entrar em operação, elevará a atual capacidade de geração para 5 TWh por ano.
Ao ser inaugurado, o complexo eólico piauiense somou-se a outras 750 centrais similares em operação no país, 90% delas localizadas na região Nordeste. De acordo com a Associação Brasileira de Energia Eólica (AbEEólica), essa infraestrutura, composta por 8,8 mil geradores, produziu no ano passado energia para atender a demanda de 28,8 milhões de moradias, o equivalente a 86,4 milhões de pessoas. Desde 2019, a fonte eólica é a segunda da matriz elétrica nacional e a que mais tem se expandido. Com 20 gigawatts (GW) de potência instalada operacional, é superada pela energia hidráulica, com cerca de 103 GW.
O Brasil foi o terceiro país que mais instalou energia eólica no mundo no ano passado, segundo a presidente-executiva da AbEEólica. Em 2020, foram inaugurados 66 novos parques e em 2021, até novembro, outros 54 entraram em operação. “Fomos responsáveis por 43% da nova capacidade instalada adicionada à matriz brasileira e já somos o sétimo país no ranking mundial de geração eólica.” O potencial de geração no país é estimado em cerca de 500 GW, quantidade suficiente para atender o triplo da demanda atual de energia dos brasileiros. O número é três vezes superior ao do atual parque nacional de energia elétrica, incluindo todas as fontes disponíveis (hidrelétrica, solar, biomassa, gás natural, óleo diesel, carvão mineral e nuclear).
Embora seja uma energia limpa e renovável, a eólica causa impactos ambientais e sociais: altera a paisagem onde é instalada, as turbinas geram ruído, provocando desconforto nas comunidades vizinhas, e suas pás colocam em risco pássaros e morcegos que vivem no local. Os desafios tecnológicos a serem enfrentados dizem respeito à intermitência da geração e à dificuldade de estocar a energia gerada nos parques.
Yuri Vasconcelos. Revista Pesquisa FAPESP. Edição 310, dez./2021.
Internet: <revistapesquisa.fapesp.br> (com adaptações).
Empregado no texto CB2A1, o vocábulo “eólica” acentua-se devido à mesma regra de acentuação que determina o emprego do acento na palavra', 'renovável.', 'elevará.', 'pássaros.', 'carvão.', 'ruído.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Em cada opção abaixo há duas palavras, propositalmente sem os acentos gráficos.
Assinale a opção em que os dois vocábulos mostram acentuação tônica diferente.', 'interim / prototipo.', 'orgão / ponei.', 'decano / orfão.', 'rubrica / extase.', 'onibus / alibi.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto CB2A1
As discussões sobre o uso da tecnologia na educação já acontecem há alguns anos e foram potencializadas após a pandemia de covid-19 e, mais recentemente, pelo Relatório de Monitoramento Global da Educação publicado pela UNESCO em 2023.
A infoexclusão é um ponto de atenção no relatório. Embora o Brasil tenha iniciativas de distribuição de equipamentos de informática nas escolas, quem está conectado à Internet não necessariamente está digitalmente incluído. Além da democratização do acesso e disponibilização de infraestrutura, é necessário o multiletramento.
Nesse contexto, a visão dicotômica dos smartphones como heróis ou vilões deve ser discutida. O relatório da UNESCO revela que um em cada quatro países já proibiu ou restringiu o uso de smartphones nas salas de aulas, alegando dispersão e prejuízos para a aprendizagem. Além disso, preocupam questões éticas, como gravação de aulas ou uso de imagens sem autorização, falta de controle ao que os alunos possam acessar, cyberbullying, exposição a conteúdos inapropriados, acesso a fake news, entre outras.
No entanto, simplesmente proibir o uso de smartphones nas escolas segue na contramão do que vislumbramos para a formação dos estudantes nos dias atuais. Eles precisam aprender a evitar o uso nocivo da tecnologia, desenvolvendo noções básicas em favor do seu uso acadêmico e cidadão.
Enfrentamos na contemporaneidade inúmeros desafios no que se refere à tecnologia aplicada à educação. Entretanto, vislumbramos, a partir do uso ético e criativo da tecnologia educacional, uma potência que não pode ser desconsiderada.
Érica Ramos Rocha Silva. Possibilidades da tecnologia na educação. Internet:
www.correio24horas.com.b>  (com adaptações).
Assinale a opção em que as palavras apresentas são acentuadas graficamente porque são paroxítonas em que a vogal i ou u tônica forma hiato com a vogal da sílaba anterior.', '“incluído” e “inúmeros”', '“países” e “prejuízos”', '“heróis” e “países”', '“prejuízos” e “heróis”', '“inúmeros” e “conteúdos”', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
Entre as palavras abaixo, assinale aquela que tem acentuação errada.', 'Café.', 'Cipó.', 'Cajú.', 'Pará.', 'Açaí.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV – 2024
A opção em que as duas palavras nela apresentadas recebem acento gráfico corretamente, é:', 'dócil / maquinária;', 'autóctone / rúbrica;', 'hífen / táctil;', 'barbária / têxtil;', 'éter / cíclope.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE – 2024
A sofisticação das línguas indígenas
Você provavelmente já encontrou pelas redes sociais o famigerado #sqn, aquele jeito telegráfico de dizer que tal coisa é muito legal, “só que não”. Agora, imagine uma língua totalmente diferente do português que deu um jeito de incorporar um conceito parecido na própria estrutura das palavras, criando o que os linguistas apelidaram de “sufixo frustrativo” — um #sqn que faz parte da própria história do idioma.
É exatamente assim que funciona no kotiria, um idioma da família linguística tukano que é falado por indígenas do Alto Rio Negro, na fronteira do Brasil com a Colômbia. Para exprimir a função “frustrativa”, o kotiria usa um sufixo com a forma -ma. Você quer dizer que foi até um lugar sem conseguir o que queria indo até lá? Basta pegar o verbo “ir”, que é wa’a em kotiria, e acrescentar o sufixo: wa’ama, “ir em vão”. Dá para encontrar detalhes surpreendentes como esse em todas as mais de 150 línguas indígenas ainda faladas no território brasileiro. Elas são apenas a ponta do iceberg do que um dia existiu por aqui.
Calcula-se que pelo menos 80% dos idiomas que eram falados no Brasil desapareceram de 1.500 para cá. Mesmo assim, o país continua abrigando uma das maiores diversidades linguísticas do planeta. A propósito, esqueça aquele negócio de “tupi-guarani”, expressão que é meio como dizer “português-espanhol”. O tupi é uma língua; o guarani é outra — e, aliás, existem diversas formas de guarani, nem sempre inteligíveis entre si.
O único emprego correto do substantivo composto “tupi-guarani” é o que serve para designar uma subfamília linguística com esse nome, a qual engloba dezenas de idiomas. Entre seus membros ainda usados no cotidiano estão o nheengatu, os vários “guaranis”, o tapirapé e o guajá. Uma subfamília, como você pode imaginar, faz parte de uma família linguística mais ampla — nesse caso, a família tupi propriamente dita.
Existem pelo menos outras três grandes famílias linguísticas no país, diversas outras famílias de porte mais modesto e, de quebra, várias línguas consideradas isoladas. É mais ou menos o mesmo caso do basco, falado na Espanha e na França — com a diferença de que o basco é um dos únicos casos desse tipo no território europeu.
Essa comparação ajuda a entender o tamanho da riqueza linguística brasileira. Com raríssimas exceções (fora o basco, temos também o finlandês e o húngaro, por exemplo), todos os falares ainda utilizados hoje na Europa fazem parte de uma única família linguística, a do indo-europeu. Pode não parecer à primeira vista, mas é praticamente certo que o alemão, o russo, o grego, o português e o lituano descendem de um único idioma pré-histórico, que hoje chamamos de protoindo-europeu.
Reinaldo José Lopes. Internet. <super.abril.com.br.> (com adaptações).
São acentuadas devido à mesma regra ortográfica as palavras', 'bebês e cães.', 'também e direções.', 'identificável e telegráfico.', 'propósito e inteligíveis.', 'linguística e indígena.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'VUNESP – 2023
Assinale a alternativa cujo enunciado está redigido de acordo com a norma-padrão de ortografia e acentuação.', 'Muitos consideram um previlégio chegar à maturidade podendo exercer plenamente as atividades e vencer os desafios que vem ao seu encontro.', 'A beneficência é uma das formas de prover o bem-estar comum, propiciando ao indivíduo as muitas recompensas que dela advêm.', 'Para todos que se vêem às voltas com a maturidade, é imprecindível a assunção das responsabilidades a ela inerentes.', 'É certa a existência de deveres pré-existentes à condição de adulto; e não faz sentido os indivíduos se degladiarem, querendo fugir deles.', 'Antes de reinvindicar o direito ao lazer, é necessário empenhar-se na consecução de objetivos que convem não negligenciar.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 04 - Acentuação Acentuação Gráfica - Regras Especiais. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
CESPE/ CEBRASPE – 2024
Texto CB1A2-II
O poder manifesta-se em relações de uso do território, materializado ou virtualizado pelas formas de atuação dos atores sociais locais. Sendo assim, poder é uma relação estabelecida entre interesses divergentes com fins específicos de utilização do território. Os conflitos gerados pelo uso do território também são formas de poder, embora muitas vezes o poder esteja em risco. O poder é a objetivação política do território utilizado para se atingir determinado objetivo, e um de seus recursos é o convencimento do outro.
Quais são os atores sociais que mais partilham o poder e que interesses estão em jogo? Em que esfera social ou política o poder se torna mais ativo? Estamos numa diferenciação entre o poder formal, institucional, e o poder informal advindo dos movimentos sociais. O formal seria aquele da instituição política, vinculada à ideia da esfera municipal, estadual e federal; e o poder informal é o da sociedade civil organizada, incorporado no papel dos movimentos sociais diversos e de seus representantes junto às três esferas que mencionamos.
Não estamos querendo dizer que entre essas escalas não acontecem associações; o que queremos, para fim de análise, é diferenciar seu campo de negociação. Sabemos que, entre essas escalas, ocorrem interferências, seja no poder formal, seja no poder informal, e que, entre esses poderes, há uma dialética na definição das formas de desenvolvimento e de uso no território.
João Márcio Palheta da Silva. Poder, governo e território na sociedade contemporânea. Internet: (com adaptações).
Julgue o item que se segue, relativos a aspectos linguísticos do texto CB1A2-II e às ideias nele apresentadas.  No primeiro período do segundo parágrafo, o termo “que” exerce a mesma função sintática em suas duas ocorrências.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 09 - Sintaxe -Termos Acessórios. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE – 2024
Texto CB1A1-I
A forma peculiar como se processou a independência da América portuguesa teve consequências fundamentais no seu subsequente desenvolvimento. Tendo-se transferido o governo português para o Brasil sob a proteção inglesa e tendo-se operado a independência da colônia sem descontinuidade na chefia do governo, os privilégios econômicos de que se beneficiava a Inglaterra em Portugal passaram automaticamente para o Brasil independente. Com efeito, se bem haja conseguido separar-se de Portugal em 1822, o Brasil necessitou de vários decênios mais para eliminar a tutela que, graças a sólidos acordos internacionais, mantinha sobre ele a Inglaterra. Esses acordos foram firmados em momentos difíceis e constituíam, na tradição das relações luso-inglesas, pagamentos em privilégios econômicos de importantes favores políticos. Os acordos de 1810 foram firmados contra a garantia da Inglaterra de que nenhum governo imposto por Napoleão em Portugal seria reconhecido. Por eles se transferiam para o Brasil todos os privilégios de que gozavam os ingleses em Portugal — inclusive os de extraterritorialidade — e se lhes reconhecia demais uma tarifa preferencial. Tudo indica que, negociando esses acordos, o governo português tinha estritamente em vista a continuidade da casa reinante em Portugal, enquanto os ingleses se preocupavam em firmar-se definitivamente na colônia, cujas perspectivas comerciais eram bem mais promissoras que as de Portugal.
Celso Furtado. Formação econômica do Brasil. São Paulo: Cia das Letras, 2007, p. 69 (com adaptações).
Acerca de aspectos linguísticos do texto CB1A1-I, julgue o seguinte item.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 09 - Sintaxe -Termos Acessórios. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE – 2024
Texto CG3A1
— Afinador de piano, em excursão, vinte e cinco mil-réis.
— Quanto?
— Vinte e cinco mil.
— É exagero. Às vezes o afinador não ganha isso durante a viagem. O Juca Silveira me contou. A principal fonte de renda dele é a criação de perus. E já paga imposto de indústria e profissão...
— Bem, se nós formos indagar dos contribuintes quanto é que eles querem pagar, a tesouraria fica sem recursos para comprar um maço de velas quando faltar luz. Seria preferível que eles mesmos fizessem o lançamento.
A Câmara Municipal discutia o orçamento para 1920, e os dois vereadores ponderavam ponto por ponto cada título da receita. O município é pobre, arrecada setenta e dois contos por ano. Houve praga na lavoura; deu peste no gado; o empréstimo para instalação de luz elétrica vence juros penosos. Para atender ao serviço de estradas, à instrução, às eleições, ao funcionalismo, a tanto compromisso, torna-se imperioso lançar novos impostos, criar taxas inéditas, como essa de afinador. Mas piano — quantos pianos terá o município? Quinze, no máximo; dos quais apenas uns cinco nos distritos: a taxa talvez não produza cinquenta mil-réis. Uma ninharia, meu caro!
No calor da sala, os vereadores tentam reerguer as finanças públicas. Salão muito quente, com efeito. Dá para a frente da praça, que recolhe o sol da tarde, ao passo que a outra sala, olhando para a montanha e o vale profundo, recebe uma doce brisa, em que narinas mais apuradas distinguem o perfume de árvores distantes, e os caçadores chegam a identificar um cheiro de anta. No inverno, sim, a sala das sessões recomenda-se pelo aconchego — mas o orçamento é feito naquela época do ano em que as cigarras estouram, e secam os córregos.
— Barbeiro com uma só cadeira, vinte mil-réis na cidade; em outros lugares, dezoito mil. Cada mão de engenho de mineração, quando fabricada no país...
Carlos Drummond de Andrade. Câmara e cadeia. In: Contos de aprendiz.
Companhia das Letras (com adaptações).
No que se refere aos aspectos linguísticos do texto CG3A1, julgue os itens a seguir.
I Na oração “e secam os córregos”, no final do sétimo parágrafo do texto, o termo “os córregos” complementa a forma verbal “secam”.II O emprego do travessão no texto, em todas as suas ocorrências, justifica-se com base na mesma regra de pontuação.III O sentido e a correção gramatical do texto seriam mantidos caso a locução verbal “formos indagar”, no quinto parágrafo, fosse substituída por indagarmos.
Assinale a opção correta.', 'Apenas o item I está certo.', 'Apenas o item III está certo.', 'Apenas os itens I e II estão certos.', 'Apenas os itens II e III estão certos.', 'Todos os itens estão certos.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 09 - Sintaxe -Termos Acessórios. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE – 2024
Há quem diga que um dia os robôs irão dominar o mundo, já outros duvidam completamente dessa afirmação. Se isso vai ou não acontecer, não se sabe, mas o debate surgiu com força em 2023 — em boa medida, impulsionado por uma plataforma de inteligência artificial, o ChatGPT (chat generative pre-trained transformer).
No final de 2022, o ChatGPT foi disponibilizado ao público e logo se popularizou. Na prática, ele responde a perguntas em poucos segundos. Mas essa não é bem a novidade — haja vista a Siri, da Apple, e a Alexa, da Amazon. O que chama a atenção no ChatGPT é a capacidade de responder a questões mais complexas e específicas em linguagem mais fluida, como em uma conversa.
A tecnologia logo chamou a atenção dos profissionais de ensino, que começaram a se questionar sobre o impacto da ferramenta nas salas de aula e sobre o seu potencial para ajudar alunos e professores, caso seja integrada à prática pedagógica.
Internet: <https://novaescola.org.br/> (com adaptações).
Julgue o item a seguir, relativos a aspectos linguísticos do texto precedente.
O segundo e o terceiro períodos do segundo parágrafo exemplificam, respectivamente, um período simples e um período composto.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 09 - Sintaxe -Termos Acessórios. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE – 2024
Desse antigo verão que me alterou a vida restam ligeiros traços apenas. (...)
Sem dúvida as árvores se despojaram e enegreceram, o açude estancou, as porteiras dos currais se abriram, inúteis. É sempre assim. Contudo, ignoro se as plantas murchas e negras foram vistas nessa época ou em secas posteriores, e guardo na memória um açude cheio, coberto de aves brancas e de flores. (...)
O meu verão é incompleto. O que me deixou foi a lembrança de importantes modificações nas pessoas. De ordinário pachorrentas, azucrinaram-se como tanajuras, zonzas. Findaram as longas conversas no alpendre, as visitas, os risos sonoros, os negócios lentos; surgiram rostos sombrios e rumores abafados. Enorme calor, nuvens de poeira. E no calor e na poeira, homens indo e vindo sem descanso, molhados de suor, aboiando monotonamente. (...)
Um dia faltou água em casa. Tive sede e recomendaram-me paciência. A carga de ancoretas chegaria logo. Tardou, a fonte era distante — e fiquei horas numa agonia, rondando o pote, com brasas na língua. (...) Chorei, embalei-me nas consolações, e os minutos foram pingando vagarosos. A boca enxuta, os beiços gretados, os olhos turvos, queimaduras interiores (...) E em redor os objetos se deformavam, trêmulos. Veio a imobilidade, veio o esquecimento. Não sei quanto durou o suplício. (...)
Espanto, e enorme, senti ao enxergar meu pai abatido na sala, o gesto lento. Habituara-me a vê-lo grave, silencioso, acumulando energia para gritos medonhos. Os gritos vulgares perdiam-se; os dele ocasionavam movimentos singulares: as pessoas atingidas baixavam a cabeça, humildes, ou corriam a executar ordens. Eu era ainda muito novo para compreender que a fazenda lhe pertencia. Notava diferenças entre os indivíduos que se sentavam nas redes e os que se acocoravam no alpendre. O gibão de meu pai tinha diversos enfeites; no de Amaro havia numerosos buracos e remendos. As nossas roupas grosseiras pareciam-me luxuosas comparadas à chita de sinhá Leopoldina, à camisa de José Baía, sura, de algodão cru. (...) Meu pai era terrivelmente poderoso, e essencialmente poderoso. Não me ocorria que o poder estivesse fora dele, de repente, o abandonasse, deixando-o fraco e normal, um gibão roto sobre a camisa curta.
Graciliano Ramos. Infância. Rio de Janeiro/São Paulo: Record, 2022, p. 29-33 (com adaptações).
Em relação a aspectos linguísticos do trecho “Espanto, e enorme, senti ao enxergar meu pai abatido na sala, o gesto lento. Habituara-me a vê-lo grave, silencioso, acumulando energia para gritos medonhos”, do último parágrafo do texto 2A1-II, julgue os itens a seguir.I O adjetivo “enorme” qualifica o termo “Espanto”.II Os termos “grave” e “silencioso” funcionam como predicativos que se referem ao pai do narrador.III O tempo em que está flexionada a forma verbal “Habituara” projeta essa ação para o futuro.', 'Apenas o item II está certo.', 'Apenas o item III está certo.', 'Apenas os itens I e II estão certos.', 'Apenas os itens I e III estão certos.', 'Todos os itens estão certos.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 09 - Sintaxe -Termos Acessórios. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'Hora de Praticar
CESPE/ CEBRASPE– 2025
Texto:
Analisando-se a literatura produzida sobre justiça restaurativa desde o final da década de 70 do século passado, verifica-se que há diferentes abordagens, produzidas por estudiosos dos mais diversos campos do conhecimento (filosofia, psicologia social, antropologia, ciências jurídicas, pedagogia, assistência social, entre outros), incluídos acadêmicos, facilitadores de justiça restaurativa, servidores públicos e entusiastas da justiça restaurativa que buscam disseminar e fortalecer a sua implementação em nível institucional.
Dada essa pluralidade de abordagens, surgiram diversas definições de justiça restaurativa na literatura ao longo das últimas décadas, razão pela qual alguns autores atuais apontam que o conceito de justiça restaurativa ainda estaria “em aberto”. Contudo, parece haver na literatura certo consenso de que tal pluralidade seria algo positivo, por possibilitar a adaptação do conceito a diferentes contextos culturais. Alguns autores também sugerem que a justiça restaurativa seria um conceito “guarda-chuva”, ou seja, um conceito que abarca uma vasta gama de formulações, desde que sejam conservados os elementos essenciais da justiça restaurativa.
Fernanda Carvalho Dias de Oliveira Silva. A experiência e o saber da experiência da justiça restaurativa no Brasil: práticas, discursos e desafios. São Paulo: Blucher, 2021, p. 37-38 (com adaptações).
A respeito das ideias e de aspectos discursivos e linguísticos do texto precedente, julgue o item subsecutivo.
A substituição da forma verbal “há” (primeiro parágrafo) por “existe” preservaria a correção gramatical e os sentidos do texto.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/ CEBRASPE– 2025
Texto:
Um cientista empenhado em pesquisa — no campo da física, por exemplo — pode atacar diretamente o problema que enfrenta. Pode penetrar, de imediato, no cerne da questão, isto é, no cerne de uma estrutura organizada. Com efeito, conta sempre com a existência de uma estrutura de doutrinas científicas já existentes e com uma situação-problema que é reconhecida como problema nessa estrutura. Essa é a razão por que pode entregar a outros a tarefa de adequar ao quadro geral do conhecimento científico a sua contribuição.
O filósofo vê-se em posição diversa. Ele não se coloca diante de uma estrutura organizada, mas, antes, em face de algo que semelha um amontoado de ruínas (embora, talvez, haja tesouros ocultos). Não lhe é dado apoiar-se no fato de existir uma situação-problema, geralmente reconhecida como tal, pois não existir algo semelhante é possivelmente o fato geralmente reconhecido. Com efeito, tornou-se agora questão frequente, nos círculos filosóficos, saber se a filosofia chegará a colocar um problema genuíno.
Apesar de tudo, há quem acredite que a filosofia possa colocar problemas genuínos acerca das coisas e quem, portanto, ainda tenha a esperança de ver esses problemas discutidos, e afastados aqueles monólogos desalentadores que hoje passam por discussão filosófica. Se, por acaso, se julgam incapazes de aceitar qualquer das orientações existentes, tudo o que lhes resta fazer é começar de novo, desde o princípio.
Karl Popper. A lógica da pesquisa científica.
Tradução: Leonidas Hegenberg e Octanny Silveira da Mota.
São Paulo: Editora Cultrix, 2008, p. 23 (com adaptações).
Em relação aos sentidos e aspectos linguísticos do texto apresentado, julgue o item subsequente.
No primeiro período do terceiro parágrafo, a palavra “afastados” está flexionada no masculino e no plural porque concorda com o termo “problemas”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto:
Preconceito e discriminação são termos próximos. Por vezes, juridicamente, parecem até a mesma coisa, como se depreende do texto da Lei n.º 7.716, de 5 de janeiro de 1989, complementada pela Lei n.º 9.459, de 15 de maio de 1997: “Serão punidos, na forma desta lei, os crimes resultantes de discriminação ou preconceito de raça, cor, etnia, religião ou procedência nacional”. Mesmo assim, o preconceito pode ser definido como uma ideia de distinção, exclusão ou preferência baseada em raça, sexo, religião, origem social ou geográfica etc.; já a discriminação diz respeito à ação decorrente do preconceito. O preconceito é uma opinião; a discriminação, um comportamento real e efetivo.
Sendo um pensamento, o preconceito, a rigor, não é crime. Quando se torna uma ação concreta ou uma afirmação pública, passa a ser discriminação e, a partir daí, é alvo da lei. O preconceito é considerado por nós a matriz que origina o ato discriminatório. Sem preconceito, não existiria discriminação. Ausente de sua expressão concreta discriminatória, o preconceito seria apenas uma fantasmagoria psíquica.
Leandro Karnal e Luiz Estevam. Preconceito: uma história. São Paulo: Companhia das Letras, 2023 (com adaptações).
Em referência às ideias veiculadas no texto apresentado e a seus aspectos linguísticos, julgue o item seguinte.
Caso o vocábulo “complementada” (segundo período do primeiro parágrafo) fosse flexionado no masculino — complementado —, a correção gramatical do texto seria mantida, apesar de alteradas as relações de concordância no período em questão.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto:
A forma peculiar como se processou a independência da América portuguesa teve consequências fundamentais no seu subsequente desenvolvimento. Tendo-se transferido o governo português para o Brasil sob a proteção inglesa e tendo-se operado a independência da colônia sem descontinuidade na chefia do governo, os privilégios econômicos de que se beneficiava a Inglaterra em Portugal passaram automaticamente para o Brasil independente. Com efeito, se bem haja conseguido separar-se de Portugal em 1822, o Brasil necessitou de vários decênios mais para eliminar a tutela que, graças a sólidos acordos internacionais, mantinha sobre ele a Inglaterra. Esses acordos foram firmados em momentos difíceis e constituíam, na tradição das relações luso-inglesas, pagamentos em privilégios econômicos de importantes favores políticos. Os acordos de 1810 foram firmados contra a garantia da Inglaterra de que nenhum governo imposto por Napoleão em Portugal seria reconhecido. Por eles se transferiam para o Brasil todos os privilégios de que gozavam os ingleses em Portugal — inclusive os de extraterritorialidade — e se lhes reconhecia demais uma tarifa preferencial. Tudo indica que, negociando esses acordos, o governo português tinha estritamente em vista a continuidade da casa reinante em Portugal, enquanto os ingleses se preocupavam em firmar-se definitivamente na colônia, cujas perspectivas comerciais eram bem mais promissoras que as de Portugal.
Celso Furtado. Formação econômica do Brasil. São Paulo: Cia das Letras, 2007, p. 69 (com adaptações).
Acerca de aspectos linguísticos do texto CB1A1-I, julgue o seguinte item.
No penúltimo período, a forma verbal “gozavam” está empregada na terceira pessoa do plural porque concorda com o termo “privilégios”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto:
Com o avanço das novas tecnologias da informação e comunicação, observa-se na atualidade um processo de migração dos ambientes reais e analógicos para os virtuais e digitais. Inúmeros são os benefícios do oferecimento de produtos e da prestação de serviços no ambiente digital. No entanto, a exposição em rede costuma atrair riscos que, embora invisíveis, apresentam um potencial destrutivo alto: os ciberataques e o seu impacto para as organizações, as empresas e as pessoas envolvidas.
Os ataques cibernéticos podem ter como alvos pessoas, organizações políticas e sociais, empresas públicas e privadas, postos fiscais, tribunais, bases militares, autarquias e ministérios do Estado, variando conforme a motivação que os ensejou: interrupção de sistemas e serviços essenciais, resgate de valores em troca de arquivos criptografados, extração de dados, repercussão política ou até mesmo a lesão física de pessoas.
Gabriel Cemin Petry; Haide Maria Hupffer. O princípio da segurança na era dos ciberataques: uma análise a partir do escopo protetivo da LGPD. In: Revista CNJ, v. 7, n.º 1, jan.-jun./2023, p. 85-86 (com adaptações).
Com referência às ideias e às estruturas linguísticas do texto apresentado, julgue o item seguinte.
No segundo período do primeiro parágrafo, a flexão dos termos “são” e “benefícios” no plural deve-se à concordância que estabelecem com “Inúmeros”, que funciona como sujeito da oração.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Texto:
O desenvolvimento da educação sanitária, a partir dos Estados Unidos da América, esteve associado à saúde pública, tendo sido instrumento das ações de prevenção das doenças, e caracterizou-se pela transmissão de conhecimento. No entanto, mesmo que realizada de forma massiva, como no caso das campanhas sanitárias no Brasil, a perspectiva não contemplava a dimensão histórico-social do processo saúde-doença.
Com o movimento pela reforma sanitária no Brasil, as críticas mais contundentes relacionavam-se ao fato de que o social não era considerado na prática da saúde pública, senão em perspectiva restrita, de modo que a educação passou a ser uma atividade paralela, cuja finalidade seria a de auxiliar a efetivação dos objetivos eminentemente técnicos dos programas de saúde pública.
Entretanto, em uma perspectiva crítica, a educação parte da análise das realidades sociais, buscando revelar as suas características e as relações que as condicionam e as determinam. Essa perspectiva pode ater-se à explicação das finalidades reprodutivistas dos processos educativos ou trabalhar no âmbito de suas contradições, buscando transformar essas finalidades, estabelecendo como meta a construção de sujeitos e de projetos societários transformadores.
Da mesma forma, no campo da saúde, a compreensão do processo saúde-doença como expressão das condições objetivas de vida, isto é, como resultante das condições de habitação, alimentação, educação, renda, meio ambiente, trabalho, transporte, emprego, lazer, liberdade, acesso e posse da terra e acesso a serviços de saúde, descortina a saúde e a doença como produções sociais, passíveis de ação e transformação, e aponta também para um plano coletivo, e não somente individual, de intervenção.
Essa maneira de conceber a saúde tem sido caracterizada como um conceito ampliado, pois não reduz a saúde à ausência de doença, promovendo a ideia de que uma situação de vida saudável não se resolve somente com a garantia do acesso aos serviços de saúde, mas depende, sobretudo, da garantia de condições de vida dignas que, em conjunto, podem proporcionar a situação de saúde. Nesse sentido, são indissociáveis o conceito de saúde e a noção de direito social.
Márcia V. Morosini, Angélica F. Fonseca e Isabel B. Pereira. Educação em saúde. In: Dicionário da Educação Profissional em Saúde. Internet: <www.sites.epsjv.fiocruz.br> (com adaptações).
Julgue o item a seguir, relativo à estruturação linguística do texto CG2A1.
No último período do texto, o emprego do termo plural “indissociáveis” justifica-se por sua concordância com os dois núcleos do sujeito da oração, a saber, “conceito” e “noção”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'FGV– 2025
Entre as frases abaixo, há uma em que foi mal-feita a concordância do termo sublinhado; assinale essa frase.', 'Os homens têm intenção de prestar favores até que consigam o poder.', 'Não merecem o doce quem não experimentaram o amargo.', 'Quando não sopra mesmo nenhum vento, até o cata-vento da torre da igreja tem caráter.', 'Aqueles que desejam menos coisas estão mais perto dos deuses.', 'Às vezes eu tento ser modesto, mas aí começam a me faltar argumentos.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Leia a nota da OAB a seguir.
A prática reiterada e impune de atos de corrupção leva as pessoas a pensar que a improbidade e a falta de ética são naturais e a improbidade é uma regra para os grandes delinquentes.
Sobre a estruturação desse pequeno texto, assinale a afirmativa correta:', 'O adjetivo “grandes” mostra valor de importância social dos delinquentes.', 'Os adjetivos “reiterada” e “impune” são redundantes, bastando tão somente o emprego de um deles.', 'O texto mostra um erro de construção na forma verbal “pensar”, que deveria ser substituída por “pensarem”.', 'A repetição da palavra “improbidade” poderia ser evitada, trocando-se a segunda ocorrência pelo demonstrativo “esta”.', 'O verbo “pensar” só tem por complemento a primeira oração que o segue: “que a improbidade e a falta de ética são naturais', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Assinale a opção correta em relação à concordância nominal.', 'A candidata parece meia confusa.', 'É proibido a entrada de visitantes nessa área.', 'A diretora achou um e outro funcionário cumpridor.', 'A entrada para o teatro, atualmente, está muito caro.', 'As certidões estão anexas ao processo.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (1, 'CESPE/CEBRASPE – 2024
Assinale a alternativa em que a concordância está adequada à norma padrão da língua portuguesa.', 'O envio de comida e de roupa os salvarão.', 'Observou-se um pequeno desvio de rota, embora não se previsse os erros.', 'Estava incluso no valor todos os impostos exigidos por lei.', 'A reflexão feita por intelectuais brasileiros e estrangeiros sobre os avanços científicos podem conduzir a certos erros.', 'Couberam ao diretor as análises feitas pelo funcionário da contabilidade.', 'E', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): Aula 12 (Recuperação Automática). Gabarito Oficial: Alternativa E.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Interpretação Correta das Regiões
Para resolver problemas com conjuntos, é essencial entender o que cada área do diagrama de Venn representa. Cada região no diagrama indica uma combinação específica de elementos pertencentes a um ou mais conjuntos. Por exemplo, se estamos lidando com dois conjuntos que representam "mulheres" e "pessoas de óculos", a interseção entre "mulheres" e "pessoas de óculos" (A ⋂ B) irá representar as mulheres de óculos.
A= mulheres
B = pessoas de óculos
O símbolo ⋂ representa a interseção de dois ou mais conjuntos.
Exemplo:
A = {1,2,3,4}
B = {3,4,5,6}
A interseção A⋂B será {3,4}, pois esses são os elementos que aparecem em ambos os conjuntos A e B.
Assim, A ⋂ B é o conjunto de todos os elementos que estão tanto em A quanto em B.
Exemplo Prático
Analisando uma Questão
Em uma entrevista de mercado foram entrevistadas várias pessoas acerca de suas preferências em relação a três produtos A, B e C. Os resultados da pesquisa indicaram que:
210 compram A
210 compram B
250 compram C
60 compram A e B
70 compram A e C
50 compram B e C
20 compram os três produtos
100 pessoas não compram nenhum dos três.
Quantas pessoas foram entrevistadas?
670
970
870
610
510
Resolução
Identifique a intersecção geral: Inicie com os elementos na intersecção de todos os conjuntos.
- 20 compram os três produtos
Preencha interseções parciais: Subtraia os elementos já contados para encontrar as interseções que envolvem apenas dois conjuntos.
- 50 compram B e C: 50-20 = 30
- 70 compram A e C: 70-20 = 50
- 60 compram A e B: 60-20 = 40
Complete as áreas restantes: Calcule as áreas exclusivas de cada conjunto, evitando duplicidade de contagem.
250 compram C: 250 -50 -20 -30 = 150', '210 compram B: 210 -40 -20 -30 = 120', '210 compram A: 210 -50 -20 -40 = 100', '100 pessoas não compram nenhum dos três.', 'Com esse diagrama conseguimos resolver a questão:', '40+20+50=110 +100= 210 +120= 330 +30= 360+ 150= 510 +100= 610', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): AULA 20 RLM. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
CESPE / CEBRASPE – 2024
Érica: “Vocês estão felizes ou tristes?”
Jorge: “Eu sou feliz, mas estou triste.”
Luana: “Eu estou alegre, mas sou infeliz.”
Carla: “Que triste, Luana!”
Considerando os aspectos da lógica sentencial presentes no diálogo anterior e, ainda, que “estar triste” e “ser infeliz” sejam negações de “estar alegre” e “ser feliz”, respectivamente, julgue o próximo item.
A frase dita por Carla é uma proposição simples.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 01. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE / CEBRASPE – 2022
Uma frase afirmativa que possa ser classificada em verdadeira ou falsa é uma proposição. Para formular composições de proposições simples, a lógica matemática faz uso de alguns conectivos padronizados: a conjunção (e, indicada por ˄); a disjunção (ou, indicada por ˅); a condicional (se… então, indicada por →); e a bicondicional (se, e somente se, indicada por ↔). Também tem-se a negação, indicada por ¬, que age sobre uma proposição sozinha, negando seu sentido. Algumas sentenças, denominadas sentenças abertas, não são consideradas proposições porque seu valor-verdade depende de uma ou mais variáveis; elas podem ser transformadas em proposições pelo uso de um quantificador universal (para qualquer x) ou de um quantificador existencial (existe x).
Considerando essas informações, e que ℤ representa o conjunto dos números inteiros, julgue o item seguinte.
A seguinte afirmação é uma proposição: A quantidade de formigas no planeta Terra é maior que a quantidade de grãos de areia.
(   ) Certo
(   ) Errado
CESPE / CEBRASPE – 2024
Julgue o item a seguir, relativo à lógica proposicional.
A sentença “A pergunta ‘Qual é a real influência do mercado financeiro na composição do orçamento estadual?’ necessita ser respondida pelos secretários da fazenda dos estados brasileiros.” é uma proposição lógica.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 01. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'QUADRIX – 2023
Com relação a equações e inequações e estruturas lógicas, julgue o item. “Pelé é o maior jogador de futebol de todos os tempos!” é uma proposição.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 01. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE / CEBRASPE – 2022
Acerca de lógica matemática, julgue o item a seguir.
A frase “Saia daqui!” é uma proposição simples.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 01. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CONSULPAM – 2022
Considere as seguintes sentenças:
I. Ela foi a melhor aluna da turma em 2022.
II. Mario foi o diretor do Colégio Liceu em 2020.
III. 𝑥+𝑦 é um número par.
2', 'É verdade que:', 'Todas as sentenças são abertas.', 'Apenas a sentença III é aberta.', 'Apenas as sentenças I e III são abertas.', 'Apenas a sentença I é aberta.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 01. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
IGEDUC – 2024
O texto seguinte servirá de base para responder à questão.
Considere as seguintes proposições:
P: "Todos os seres humanos são mortais."
Q: "A água ferve a 100°C ao nível do mar."
R: "O céu é verde."
S: "2 + 2 = 5."
“R v S” é verdadeira porque a disjunção só é verdadeira se as duas proposições forem falsas.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 02. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'IGEDUC – 2024
O texto seguinte servirá de base para responder à questão.
Considere as seguintes proposições:
P: "Todos os seres humanos são mortais."
Q: "A água ferve a 100°C ao nível do mar."
R: "O céu é verde." S: "2 + 2 = 5."
A conjunção P^Q é verdadeira e forma a proposição: "Todos os seres humanos são mortais e a água ferve a 100°C ao nível do mar.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'INSTITUTO ACCES – 2024
Considere as seguintes proposições:
• p: vou ao parque.
• q: irei me divertir.
No que ser refere à tabela verdade e sabendo que a proposição composta p → q é falsa, é correto afirmar que
(A) a proposição q é necessariamente falsa.
(B) a proposição p e a proposição q são ambas falsas.
(C) a proposição q e a proposição p são ambas verdadeiras.
(D) a proposição q tem o mesmo valor da proposição p.
FGV – 2024
A proposição lógica “se q ou t, então p e r e s” tem valor lógico verdadeiro.
Dado que o valor lógico de s é falso, conclui-se corretamente que', 'p tem valor lógico falso e r tem valor lógico verdadeiro.', 'p tem valor lógico verdadeiro e r tem valor lógico falso.', 'q tem valor lógico falso e t tem valor lógico falso.', 'q tem valor lógico falso e t tem valor lógico verdadeiro.', 'q tem valor lógico verdadeiro e t tem valor lógico falso.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 02. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'IBADE – 2024
Dadas as proposições a seguir, escolha a alternativa que representa corretamente uma proposição composta com estrutura lógica condicional.
P: Todos os alunos estudaram para o teste.
Q: A nota de todos os alunos foi satisfatória.', 'Todos os alunos estudaram para o teste e a nota de todos os alunos foi satisfatória.', 'Se todos os alunos estudaram para o teste, então a nota de todos os alunos foi satisfatória.', 'A nota de todos os alunos foi satisfatória se, e somente se, todos os alunos estudaram para o teste.', 'Todos os alunos estudaram para o teste ou a nota de todos os alunos foi satisfatória.', 'A nota de todos os alunos foi satisfatória, mesmo que nem todos tenham estudado para o teste.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 02. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
CESPE / CEBRASPE – 2024
Ao comentar em uma rede social a respeito de informações veiculadas por um jornalista, certo internauta escreveu: “Ou o jornalista é muito mal informado ou age de má-fé. Em minha opinião, as duas coisas.”
Com base no texto precedente e nos aspectos de lógica sentencial, julgue o item seguinte.
A tabela-verdade associada à proposição “Ou o jornalista é muito mal informado ou age de má-fé” possui 4 linhas.
(   ) Certo
(   ) Errado
CESPE / CEBRASPE – 2022
Julgue o item seguinte, considerando a proposição P: “Como nossas reservas de matéria prima se esgotaram e não encontramos um novo nicho de mercado, entramos em falência”.
O número de linhas da tabela-verdade associada à proposição P é inferior a dez.
(   ) Certo
(   ) Errado
CESPE / CEBRASPE – 2020
Considerando a proposição P: “Se o servidor gosta do que faz, então o cidadão-cliente fica satisfeito”, julgue o item a seguir.
P é uma proposição composta formada por duas proposições simples, de modo que sua tabela-verdade possui 2 linhas.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 03. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
CESPE / CEBRASPE – 2024
Érica: “Vocês estão felizes ou tristes?”
Jorge: “Eu sou feliz, mas estou triste.”
Luana: “Eu estou alegre, mas sou infeliz.”
Carla: “Que triste, Luana!”
Considerando os aspectos da lógica sentencial presentes no diálogo anterior e, ainda, que “estar triste” e “ser infeliz” sejam negações de “estar alegre” e “ser feliz”, respectivamente, julgue o próximo item.
A frase dita por Jorge é uma proposição composta por conjunção.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 06. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE / CEBRASPE – 2024
Érica: “Vocês estão felizes ou tristes?”
Jorge: “Eu sou feliz, mas estou triste.”
Luana: “Eu estou alegre, mas sou infeliz.”
Carla: “Que triste, Luana!”
Considerando os aspectos da lógica sentencial presentes no diálogo anterior e, ainda, que “estar triste” e “ser infeliz” sejam negações de “estar alegre” e “ser feliz”, respectivamente, julgue o próximo item.
A frase dita por Érica é uma proposição composta por disjunção', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 06. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE / CEBRASPE – 2024
CB1A3
“O chefe não me falou sobre isso, mas, se eu for convidado, aceitarei a tarefa.”
Supondo verdadeira a proposição CB1A3-I, assinale a opção que apresenta uma proposição também verdadeira.', 'O chefe não me falou sobre isso.', 'Não aceitarei a tarefa.', 'O chefe me falou sobre isso.', 'Serei convidado.', 'Aceitarei a tarefa.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 06. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE / CEBRASPE – 2023
“P: Se me dá trabalho excessivo ou suja o meu carro, não levo as mudas das plantas.”
Considerando a proposição P precedente, julgue o item a seguir.
Se a veracidade da proposição P for admitida e se também for verdade que “levo as mudas das plantas”, então é falsa apenas uma entre as proposições “me dá trabalho excessivo” e “suja o meu carro”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 06. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'DPE – 2023
Sabe-se que a sentença:
“Se a camisa é preta e a calça é branca, então o cinto é marrom ou o sapato é marrom” é FALSA.
É correto afirmar que:', 'Se o cinto é marrom, então o sapato é marrom;', 'Se o sapato não é marrom, então a camisa não é preta;', 'Se a calça é branca, então o sapato é marrom;', 'Se a camisa é preta, então a calça não é branca;', 'Se a camisa é preta, então o cinto é marrom', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 06. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Instituto AOCP- 2024
Por trás de uma extensa quantidade de linhas de programação de certo equipamento, há um comando que, traduzido para a língua portuguesa, poderia ser lido como “Se o usuário apertar o botão verde, imprima”.
Naturalmente, considerando esse único comando, pode-se dizer, logicamente, que tal sentença só é falsa no caso em que:
(A) o usuário não aperta o botão verde e o equipamento não imprime.
(B) o usuário não aperta o botão verde e o equipamento imprime.
(C) o usuário aperta o botão verde e o equipamento imprime.
(D) o usuário aperta o botão verde e o equipamento não imprime.
(E) o usuário aperta um botão vermelho e o equipamento imprime.
IBFC- 2024
Apresenta-se a seguinte Tabela-Verdade:
Assinale a alternativa que apresenta a sequência correta de cima para baixo dos valores da coluna P → Q nesta Tabela-Verdade.', 'F-F-V-V', 'V-V-F-F', 'F-V-F-V', 'V-F-F-F', 'V-F-V-V', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 06. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Aula 08
00RACIOCÍNIO LÓGICO MATEMÁTICO
Aula 08
IMPORTANTE! PIRATARIA É CRIME!
Antes de você iniciar seus estudos, vamos tratar de um assunto um pouco chato, porém necessário. Sempre é bom relembrar que pirataria é crime, podendo chegar a 4 (quatro) anos de prisão, além de multa (artigo 184 do Código Penal). Ademais, a distribuição não autorizada também infringe a lei de Direitos Autorais (Lei nº 9.610, de 19 de fevereiro de 1998). Sendo assim, pedimos encarecidamente a sua compreensão para não compartilhar nosso material por nenhum meio (grupos de WhatsApp ou Telegram, sites, Instagram, etc.)
Pedimos também que, caso você veja nosso material circulando de maneira ilegal, nos avise, para que possamos tomar as medidas necessárias.
O compartilhamento do material importará no bloqueio imediato do aluno à plataforma. Obrigado pela compreensão.
Copyright      2024 – Todos os direitos reservados
Estruturas Lógicas
Analisando Estruturas Lógicas
Identificação de Proposições
Uma das primeiras etapas ao trabalhar com uma questão de estrutura lógica é identificar e separar as proposições envolvidas. A separação dessas proposições é essencial para uma análise clara e organizada da lógica por trás do enunciado.
Análise do Enunciado
Em muitos casos, deve-se partir do pressuposto de que as proposições apresentadas são verdadeiras, a menos que o enunciado indique o contrário. Isso ajuda a criar uma base sólida para analisar o que cada proposição implica em termos de verdade ou falsidade e como essas implicações se relacionam umas com as outras.
Estratégia de Resolutividade
Para resolver questões de lógica de forma eficaz, é útil seguir um método:
Separação das proposições: Identifique cada proposição e coloque-as em uma estrutura organizada. Isso facilita a visualização das relações entre as proposições.
Pressuposto de veracidade: Considere cada proposição como verdadeira conforme indicado no enunciado. Isso permitirá aplicar a lógica sobre uma base consistente.
Definição do ponto de partida: Procure uma proposição inicial que seja simples e diretamente verificável. Esse ponto de partida orientará a análise lógica dos demais elementos do problema.
Análise das implicações lógicas: Examine como a veracidade de uma proposição impacta as demais. Muitas vezes, uma proposição conduz a outra e, assim, conseguimos determinar o valor lógico de cada uma de forma sequencial.
Aplicando a Análise a um Exemplo Prático
Retomado os pontos principais, vamos dar continuidade a análise do exemplo prático iniciado anteriormente.
Considere o seguinte problema:
"Maria é magra ou Bernardo é barrigudo; se Lúcia é linda então César não é careca; se Bernardo é barrigudo então César é careca; ora, Lúcia é linda."
Logo:
Maria é magra e Bernardo não é barrigudo
Bernardo é barrigudo ou César é careca
César é careca e Maria é Magra
Maria não é magra e Bernardo é barrigudo
Lúcia é linda e César é careca
Seguindo os passos estratégicos para a resolução, conseguimos identificar o valor lógico de cada proposição simples:
Lúcia é linda = V
César não é careca = V
Bernardo é barrigudo = F
Maria é magra = V
Agora vamos analisar cada alternativa:
Maria é magra e Bernardo não é barrigudo
V                                    V                               = V
Aqui já encontramos o gabarito da questão, uma proposição, com ambas as proposições que a compõem sendo verdadeiras, ligadas pelo conectivo “e”, só poderá ser Verdadeira, mas vamos analisar as demais alternativas.
Bernardo é barrigudo ou César é careca
F                                      F                = F
Nesta alternativa temos o conectivo “ou” e sabemos que bastaria uma verdade para a proposição ser verdadeira, o que não ocorre, por isso a alternativa está errada.
César é careca e Maria é Magra
F                           V                = F
Conectivo “e” para ser verdadeira, ambas as proposições devem ser verdadeiras, assim alternativa errada.
Maria não é magra e Bernardo é barrigudo', 'F                                     F                         = F', 'Novamente conectivo “e”, agora com ambas as proposições falsas, tornando a proposição falsa.', 'Lúcia é linda e César é careca', 'V                      F                  = F', 'Conectivo “e”, basta uma proposição falsa para tornar a proposição falsa.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 08. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
INSTITUTO ACESS – 2024', 'Considere a seguinte proposição “Vou para o rio e vou nadar”, assinale a alternativa que indique a negação para a proposição.', 'Vou ao rio e não vou nadar.', 'Não vou ao rio e vou nadar.', 'Não vou ao rio e não vou nadar.', 'Não vou ao rio ou não vou nadar.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'FUNDATEC – 2024
Assinale a alternativa que indica a negação correta da proposição composta “A pasta é azul ou a grama é verde”.', 'A pasta não é azul ou a grama não é verde.', 'A pasta não é verde ou a grama não é azul.', 'A pasta é azul ou a grama não é verde.', 'A pasta não é azul e a grama não é verde.', 'A grama não é azul e a pasta não é verde.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/CEBRASPE – 2024
Texto CB3A3-I
P: “O adversário tentou desgastar o candidato, mas a artilharia contra ele não teve sucesso.”
Assinale a opção que apresenta uma negação da proposição P, presente no texto CB3A3-I.', 'O adversário não tentou desgastar o candidato ou a artilharia contra ele teve sucesso.', 'O adversário não tentou desgastar o candidato, mas a artilharia contra ele teve sucesso.', 'Se a artilharia contra o candidato não teve sucesso, o adversário tentou desgastá-lo.', 'Se o adversário não tentou desgastar o candidato, então a artilharia contra ele não teve sucesso.', 'O adversário tentou não desgastar o candidato, mas a artilharia contra ele teve sucesso.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 10. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/CEBRASPE – 2023
“Avisei em 1984, mas vocês não me ouviram”, disse James Cameron, diretor do filme O Exterminador do Futuro, acerca dos riscos do avanço descontrolado da inteligência artificial. Acerca da afirmação precedente, do diretor James Cameron, julgue o item subsequente.
A negação da afirmação de Cameron pode ser escrita como “Não avisei em 1984 e vocês não me ouviram”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 10. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/CEBRASPE – 2022
Texto CG2A2-I
Considere a seguinte proposição.
P: Como subestimou a inteligência dos adversários e não gostou do que viu, o candidato extravasou aflição e externou seu incômodo.
Assinale a opção que apresenta a negação da proposição "o candidato subestimou a inteligência dos adversários e não gostou do que viu".
Alternativas', 'O candidato não subestimou a inteligência dos adversários e gostou do que viu.', 'O candidato superestimou a inteligência dos adversários ou gostou do que viu.', 'O candidato não subestimou a inteligência dos adversários e não gostou do que viu.', 'O candidato não subestimou a inteligência dos adversários ou gostou do que viu.', 'O candidato não subestimou a inteligência dos adversários ou não gostou do que viu.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 10. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
CESPE/ CEBRASPE – 2024
Ao comentar em uma rede social a respeito de informações veiculadas por um jornalista, certo internauta escreveu: “Ou o jornalista é muito mal informado ou age de má-fé. Em minha opinião, as duas coisas.”
Com base no texto precedente e nos aspectos de lógica sentencial, julgue o item seguinte.
A negação da proposição “Ou o jornalista é muito mal informado ou age de má-fé” pode ser corretamente expressa por “O jornalista é muito mal informado se, e somente se, age de má-fé”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 11. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2024
Certo pensador, ao comentar a respeito de determinada ideologia, manifestou a seguinte opinião: “Essa ideologia é igual às outras: se você acredita, não precisa de explicação; se você não acredita, não adianta explicação.”
Uma pesquisa revelou que, de 1.000 pessoas de uma cidade, 300 conhecem e acreditam na referida ideologia, 400 a conhecem, mas não acreditam nela, 200 não a conhecem e 100 a conhecem, mas são indiferentes (nem dizem acreditar, nem dizem desacreditar).
Considerando essa situação hipotética, julgue o item seguinte.
A negação do trecho ‘se você acredita, não precisa de explicação; se você não acredita, não adianta explicação’ pode ser expressa corretamente por ‘você acredita, mas precisa de explicação, ou você não acredita, mas adianta explicação’.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 11. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2024
Texto CB2A3-I
P1: Se as projeções de investimento forem superestimadas, a previsão de capex não se confirmará.
P2: Se a previsão de capex não se confirmar, haverá menor geração de caixa.
P3: Se as projeções conservadoras de produção se confirmarem, haverá menor geração de caixa.
P4: Se houver menor geração de caixa, a capacidade da empresa de distribuir dividendos atraentes estará comprometida.
P5: Se a capacidade da empresa de distribuir dividendos atraentes estiver comprometida, a cotação das ações cairá.
C: A cotação das ações caiu.
Assinale a opção que corresponde a uma negação da proposição P3 do texto CB2A3-I.', 'As projeções conservadoras de produção se confirmaram, mas não houve menor geração de caixa.', 'Se as projeções conservadoras de produção não se confirmarem, não haverá menor geração de caixa.', 'Se não houve menor geração de caixa, as projeções conservadoras de produção não se confirmaram.', 'As projeções conservadoras de produção não se confirmarão ou haverá menor geração de caixa.', 'As projeções conservadoras de produção se confirmaram ou houve maior geração de caixa.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 11. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2023
Assinale a opção que apresenta corretamente uma negação da proposição “Se nunca foi campeão da Champions League, seu time é muito ruim”.', 'Se sempre foi campeão da Champions League, seu time é muito bom.', 'Se nunca foi campeão da Champions League, seu time não é muito ruim', 'Se seu time não é muito ruim, ele sempre foi campeão da Champions League.', 'Nunca foi campeão da Champions League, mas seu time não é muito ruim.', 'Mesmo seu time sendo muito bom, ele nunca será campeão da Champions League.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 11. Gabarito Oficial: Alternativa D.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2023
P1: Não há uma prova com o nome do aluno nos arquivos do professor.
P2: Se não há uma prova com o nome do aluno nos arquivos do professor, então o aluno esqueceu-se de colocar seu nome na prova, não a fez ou, se a fez, o professor perdeu a prova dele.
P3: Não há prova sem nome nos arquivos do professor.
P4: Se não há prova sem nome nos arquivos do professor, então o aluno não se esqueceu de colocar seu nome na prova.
P5: A assinatura do aluno não consta da lista de presença do dia da prova.
P6: Se a assinatura do aluno não consta da lista de presença do dia da prova, então o aluno não fez a prova.
Tendo como referência as proposições P1 a P6, anteriormente apresentadas, julgue o item a seguir.
A negação da proposição P6 pode ser corretamente expressa por “a assinatura do aluno não consta da lista de presença do dia da prova, mas o aluno não deixou de fazer a prova”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 11. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
CESPE/ CEBRASPE 2024
P: “Como Carlos enfrentou resistência dos produtores locais, articulou e negociou o fornecimento com produtores de outros estados.”
Considerando a proposição P precedente, julgue o próximo item.
A negação de P pode ser corretamente expressa por “Carlos enfrentou resistência dos produtores locais, mas não negociou ou não articulou o fornecimento com produtores de outros estados.”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 12. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2023
Considerando que as proposições lógicas simples sejam representadas por letras maiúsculas e que os símbolos lógicos usuais estejam representados conforme a tabela precedente, julgue o próximo item, relacionados à proposição lógica (P∧R) ⇒ (~Q).A proposição lógica P∧(R∧Q) é equivalente à negação da proposição (P∧R) ⇒ (~Q).', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 12. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2023
P1: “Se o custo operacional aumenta, aumentamos o preço cobrado pelo nosso produto.”
P2: “Se o preço do produto substituto aumenta, aumentamos o preço cobrado pelo nosso produto.”
P3: “Aumentamos o preço cobrado pelo nosso produto, mas o custo operacional não aumentou.”
C: “Logo, o preço do produto substituto aumentou.”
Considerando o argumento constituído pelas premissas P1, P2 e P3 e pela conclusão C, anteriormente apresentadas, julgue o item seguinte.
A proposição P3 pode ser vista como uma negação da proposição P1.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 12. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2023
Considerando os conectivos lógicos usuais e assumindo que as letras maiúsculas representam proposições lógicas, julgue o item seguinte, relativos à lógica proposicional.
A negação da sentença “Se eu me alimento de forma saudável, então terei uma boa qualidade de vida no período da terceira idade” corresponde à sentença “Se eu não me alimento de forma saudável, então não terei uma boa qualidade de vida no período da terceira idade”.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 12. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'CESPE/ CEBRASPE – 2021
Assinale a opção que apresenta uma proposição que constitui uma negação da proposição “Se o bezerro tem brucelose, então o bezerro tem tuberculose”.', '“Se o bezerro tem tuberculose, então o bezerro não tem brucelose”.', '“O bezerro não tem brucelose e o bezerro tem tuberculose”.', '“O bezerro tem brucelose e o bezerro não tem tuberculose”.', '“Se o bezerro não tem brucelose, então o bezerro não tem tuberculose”.', '“O bezerro não tem brucelose se, e somente se, o bezerro não tem tuberculose”.', 'C', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 12. Gabarito Oficial: Alternativa C.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
EGEDUC – 2024
Considere as seguintes proposições:
P: "Todos os seres humanos são mortais."
Q: "A água ferve a 100°C ao nível do mar."
R: "O céu é verde."
S: "2 + 2 = 5."
A negação de P é: "Existe algum ser humano que não é mortal."', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 13. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'INSTITUTO ACCESS – 2024
Assinale a alternativa que negue a proposição “Alguns mineiros gostam de queijo.”', 'Todos os mineiros gostam de queijo.', 'Nenhum mineiro gosta de queijo.', 'Existe um mineiro que gosta de queijo.', 'Existe um mineiro que não gosta de queijo.', 'Nenhuma das anteriores (N.D.A.)', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 13. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'INSTITUTO ACCESS – 2024', 'Considere a seguinte afirmação: Nenhum matemático é racional. A negação dessa afirmação é:', 'Todo matemático é racional.', 'Algum matemático é racional.', 'Algum matemático não é racional.', 'Algum racional não é matemático.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 13. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'FUNATEC – 2024
Assinale de forma correta a assertiva que representa a negação da seguinte proposição lógica: P1:', '“Ninguém foi à festa”.', 'Todos foram à festa.', 'Pelo menos uma pessoa foi à festa.', '10 pessoas foram à festa.', 'Somente duas pessoas foram à festa.', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 13. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Hora de Praticar
IGEDUC – 2024
O texto seguinte servirá de base para responder à questão.
Considere as seguintes proposições:
P: "Se chove, então a grama fica molhada." Q: "Se a grama não está molhada, então não choveu." R: "Chove e a grama não fica molhada."
A proposição P não é logicamente equivalente à proposição Q.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 15. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'FGV – 2024
Considere a proposição condicional: “Se bebe leite, não gosta de vinho”.
Tal proposição é logicamente equivalente a', '“Não bebe leite ou não gosta de vinho”.', '“Não bebe leite e não gosta de vinho”.', '“Se não bebe leite, gosta de vinho”.', '“Se não gosta de vinho, bebe leite”.', '“Bebe leite ou gosta de vinho”.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 15. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'IBEST – 2024
Três amigas, Andressa, Beatriz e Carolina, subiram ao pódio de uma competição de judô. Sabe-se que cada uma delas ganhou uma medalha diferente: ouro, prata ou bronze. Admitindo que as proposições “Se Andressa ganhou a medalha de prata, então Carolina ganhou a medalha de ouro”; “Ou Beatriz ganhou a medalha de ouro, ou Andressa ganhou a medalha de prata”; e “Ou Carolina ganhou a medalha de ouro, ou Beatriz ganhou a medalha de prata” são verdadeiras, julgue o item.
As proposições “Se Andressa ganhou a medalha de prata, então Carolina ganhou a medalha de ouro” e “Andressa não ganhou a medalha de ouro ou Carolina ganhou a medalha de prata” são logicamente equivalentes.', '( ) Certo', '( ) Errado', 'NÃ£o se aplica', 'NÃ£o se aplica', 'NÃ£o se aplica', 'B', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 15. Gabarito Oficial: Alternativa B.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'FGV – 2024
A proposição “Se hoje é domingo, então pelo menos uma padaria está fechada” é logicamente equivalente a', '“Se todas as padarias estão abertas, então hoje não é domingo”.', '“Se todas as padarias estão fechadas, então hoje não é domingo”.', '“Se hoje não é domingo, então todas as padarias estão abertas”.', '“Se hoje não é domingo, então todas as padarias estão fechadas”.', '“Hoje é domingo e nenhuma padaria está fechada”.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 15. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'INSTITUTO ACCESS - 2024', 'Considere a seguinte proposição composta “vou ao mercado ou economizo dinheiro”. Assinale a alternativa que apresenta equivalência.', 'Se não vou ao mercado então economizo dinheiro.', 'Vou ao mercado e economizo dinheiro.', 'Não vou ao mercado e economizo dinheiro.', 'Se vou ao mercado então economizo dinheiro.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 15. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Aula 17
RACIOCÍNIO LÓGICO MATEMÁTICO
Aula 17
IMPORTANTE! PIRATARIA É CRIME!
Antes de você iniciar seus estudos, vamos tratar de um assunto um pouco chato, porém necessário. Sempre é bom relembrar que pirataria é crime, podendo chegar a 4 (quatro) anos de prisão, além de multa (artigo 184 do Código Penal). Ademais, a distribuição não autorizada também infringe a lei de Direitos Autorais (Lei nº 9.610, de 19 de fevereiro de 1998). Sendo assim, pedimos encarecidamente a sua compreensão para não compartilhar nosso material por nenhum meio (grupos de WhatsApp ou Telegram, sites, Instagram, etc.)
Pedimos também que, caso você veja nosso material circulando de maneira ilegal, nos avise, para que possamos tomar as medidas necessárias.
O compartilhamento do material importará no bloqueio imediato do aluno à plataforma. Obrigado pela compreensão.
Copyright      2024 – Todos os direitos reservados
Lógica de Associação
Resolvendo Problemas de Associação
A resolução de problemas de associação exige habilidades de organização e raciocínio lógico, essenciais para conectar corretamente informações que, à primeira vista, podem parecer isoladas. Uma das formas mais eficazes de abordar esses problemas é utilizando tabelas, que ajudam a visualizar as inter-relações entre os diferentes elementos do enigma. Neste texto, vamos explorar como utilizar tabelas para resolver problemas de associação, apresentando dois exemplos práticos e explicando cada passo de forma clara e didática.
Exemplo 1:
Alberto, Clara e Eduardo são três irmãos, e suas idades são 10, 12 e 15 anos, não necessariamente nesta ordem. Cada um deles pratica um desses esportes: futebol, basquete e voleibol, também não necessariamente nessa ordem. Alberto não pratica voleibol, Eduardo é 5 anos mais novo que Clara, e quem pratica basquetebol é o mais velho entre os três irmãos.
Clara tem 15 anos e Eduardo tem 12 anos.
Se Alberto pratica futebol, então ele tem 12 anos.
Basquete é o esporte praticado por Alberto.
Se Clara tem 15 anos, então ela pratica voleibol.
O irmão praticante de voleibol não tem 10 anos
Passo 1: Identificar os Elementos e Categorias
O primeiro passo na resolução desse problema é identificar os elementos e as categorias que precisamos associar. Neste caso, temos:
- Elementos: Alberto, Clara e Eduardo (os três irmãos).
- Categorias: Idades (10, 12 e 15 anos) e Esportes (futebol, basquete e voleibol).
Passo 2: Construir a Tabela
Agora, criamos uma tabela com duas colunas: uma para as idades e outra para os esportes. A tabela deve ser preenchida gradualmente conforme as pistas fornecidas.
- A primeira pista nos diz que Alberto não pratica voleibol. Isso significa que podemos eliminar a possibilidade de Alberto praticar voleibol. Podemos marcar um "X" na intersecção de Alberto e voleibol na tabela de esportes.
- A segunda pista nos informa que Eduardo é cinco anos mais novo que Clara. Isso nos dá uma relação direta entre as idades de Eduardo e Clara. Eduardo, portanto, tem 10 anos e Clara tem 15 anos.
Assim podemos determinar as idades dos irmãos:
- A terceira pista afirma que quem pratica basquete é o irmão mais velho. Como Clara tem 15 anos, ela deve ser a que pratica basquete, já que é a mais velha.
Agora podemos preencher as associações restantes:
- Como Clara é a mais velha e pratica basquete, a única opção restante para o esporte de Alberto é futebol.', '- A única associação que sobra para Eduardo, então, é que ele pratica voleibol e tem 10 anos.', 'Com base na organização das pistas e na tabela, podemos concluir que:', '- Clara: 15 anos, basquete.', '- Eduardo: 10 anos, voleibol.', '- Alberto: 12 anos, futebol.', 'A', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 17. Gabarito Oficial: Alternativa A.');
INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES (2, 'Aula 18
IMPORTANTE! PIRATARIA É CRIME!
Antes de você iniciar seus estudos, vamos tratar de um assunto um pouco chato, porém necessário. Sempre é bom relembrar que pirataria é crime, podendo chegar a 4 (quatro) anos de prisão, além de multa (artigo 184 do Código Penal). Ademais, a distribuição não autorizada também infringe a lei de Direitos Autorais (Lei nº 9.610, de 19 de fevereiro de 1998). Sendo assim, pedimos encarecidamente a sua compreensão para não compartilhar nosso material por nenhum meio (grupos de WhatsApp ou Telegram, sites, Instagram, etc.)
Pedimos também que, caso você veja nosso material circulando de maneira ilegal, nos avise, para que possamos tomar as medidas necessárias.
O compartilhamento do material importará no bloqueio imediato do aluno à plataforma. Obrigado pela compreensão.
Copyright      2024 – Todos os direitos reservados
Verdades e Mentiras
Apresentação do Tema
O estudo de "verdades e mentiras" no contexto das proposições é uma área fascinante da lógica que nos desafia a repensar a forma como lidamos com afirmações, verdades e falácias. Embora esse tema seja bastante popular, não é comum encontrá-lo explicitamente mencionado em editais de concursos. Seu nome surgiu de maneira informal, ganhando reconhecimento ao longo dos anos conforme foi aparecendo em exames.
O entendimento desse tema é essencial, pois desenvolve a capacidade de análise crítica, lógica e a habilidade de identificar e resolver paradoxos, competências valiosas para qualquer área de atuação. Apesar de não possuir uma teoria específica, esse tema exige um tipo particular de raciocínio lógico, que abordaremos ao longo deste material.
Entendendo o Conceito: O Enigma das Verdades e Mentiras
O conceito de "verdades e mentiras" remete a proposições que envolvem afirmações cujo valor lógico (verdadeiro ou falso) nem sempre é óbvio de imediato. Em muitos casos, como veremos a seguir, uma simples análise das premissas não é suficiente, sendo necessário considerar a interação entre as afirmações feitas para determinar o valor de cada uma. O desafio central é lidar com a ambiguidade e a possibilidade de uma afirmação ser verdadeira ou falsa dependendo do ponto de vista adotado, o que exige uma atenção especial ao raciocínio lógico.
Análise de questão
(VUNESP – 2013 – PC-SP – Investigador de Polícia) Em um reino distante, um homem cometeu um crime e foi condenado à forca. Para que a sentença fosse executada, o rei mandou que construíssem duas forcas e determinou que fosse denominado de Forca da Verdade e a Forca da Mentira. Além disso, ordenou que na hora da execução o prisioneiro deveria proferir uma sentença assertiva qualquer. Se a sentença fosse verdadeira, ele deveria ser enforcado na Forca da Verdade. Se, por outro lado, a sentença fosse falsa, ele deveria ser enforcado na Forca da Mentira. Assim, no momento da execução, foi solicitado que o prisioneiro proferisse a sua asserção. Ao fazer isso, o carrasco ficou completamente sem saber o que fazer e a execução foi cancelada! Assinale qual das alternativas representa a asserção que o prisioneiro teria proferido.
“Está chovendo forte”.
“O carrasco não vai me executar”.
“A soma dos ângulos de um triângulo é cento e oitenta graus”.
“Dois mais dois é igual a cinco”.
Serei enforcado na Forca da Mentira”.
Análise das Alternativas
Vamos analisar as alternativas de sentenças que o prisioneiro poderia proferir e como elas afetariam seu destino:
1. Sentença: Está chovendo forte
-  Se essa sentença for verdadeira (realmente estivesse chovendo forte), o prisioneiro seria enforcado na forca da verdade. Caso contrário, ele iria para a forca da mentira. De qualquer maneira, ele seria executado. Logo, essa sentença não o salvaria da execução.
2. Sentença: O carrasco não vai me executar
- A frase seria considerada falsa, já que o carrasco estava prestes a executá-lo, resultando em enforcamento na forca da mentira.
3. Sentença: A soma dos ângulos de um triângulo é 180 graus
- Sendo uma verdade matemática, essa proposição levaria o prisioneiro à forca da verdade. Novamente, não previne sua execução.', '4. Sentença: Dois mais dois é igual a cinco', '- Falsa por definição, esta sentença resultaria no enforcamento na forca da mentira.', '5. Sentença: Serei enforcado na forca da mentira', '- Esta opção cria um paradoxo que cancela a execução, pois se levado à forca da mentira, a sentença seria verdadeira, enquanto que, se fosse levado à forca da verdade, a sentença seria falsa. Frase sempre terá um valor lógico contrário aquele que a Forca exige.', 'O exemplo da sentença "Serei enforcado na forca da mentira" é um excelente exemplo do que chamamos de paradoxo. Esse tipo de enigma cria uma situação onde a veracidade de uma proposição não pode ser decidida sem gerar uma contradição. Isso ocorre porque a afirmação é autorreferencial, ou seja, ela se refere a si mesma, o que gera um ciclo vicioso de raciocínio. Resolver paradoxos como esse exige um olhar atento às relações lógicas envolvidas, um conceito central no estudo das verdades e mentiras.', 'D', 'QuestÃ£o oficial de concurso extraÃ­da da apostila da PolÃ­cia Civil do ParanÃ¡ (PCPR): RLM 18. Gabarito Oficial: Alternativa D.');
