/**
 * PORTAL DE PROVAS E SIMULADOS - PC PR 2026 (BANCA FGV)
 * Aplicação SPA Vanilla JavaScript
 */

'use strict';

const App = {
    // Configurações
    CONFIG: {
        DURACAO_SEGUNDOS: 5 * 3600, // 5 horas
        STORAGE_KEY: 'pcpr_simulado_ativo_v1',
        USER_KEY: 'pcpr_usuario_ativo_v1',
        LEADS_KEY: 'pcpr_leads_cadastrados_v1',
        HISTORICO_KEY: 'pcpr_historico_local_v1',
        API_BASE: 'api.php'
    },

    // Estado da Aplicação
    state: {
        telaAtual: 'dashboard', // 'dashboard' | 'simulado' | 'resultado'
        usuarioAtivo: null,     // { email, nome, cargo, dataLogin }
        pendenteAcaoAposLogin: null, // 'iniciarSimulado'
        questoes: [],
        respostas: {},          // { [questao_id]: 'A'|'B'|'C'|'D'|'E' }
        marcadasRevisao: {},    // { [questao_id]: true }
        questaoAtualIdx: 0,
        modoVisualizacao: 'foco', // 'foco' (paginada) | 'completa' (scroll)
        tempoRestante: 5 * 3600,
        timerId: null,
        simuladoIniciadoEm: null,
        resultado: null,
        filtroMatriz: 'todas',  // 'todas' | 'pendentes' | 'marcadas'
        filtroRevisao: 'erros'  // 'todas' | 'erros' | 'acertos'
    },

    // Inicialização da Aplicação
    init() {
        this.cacheDOMElements();
        this.bindEvents();
        this.carregarUsuarioAtivo();
        this.carregarHistoricoDashboard();
        this.verificarSimuladoSalvo();
    },

    // Mapeamento de elementos do DOM
    cacheDOMElements() {
        this.dom = {
            // Header e Cronômetro
            topHeader: document.getElementById('topHeader'),
            timerDigits: document.getElementById('timerDigits'),
            timerBox: document.getElementById('timerBox'),
            progressCount: document.getElementById('progressCount'),
            progressBarFill: document.getElementById('progressBarFill'),
            btnFinishHeader: document.getElementById('btnFinishHeader'),
            btnVoltarHome: document.getElementById('btnVoltarHome'),

            // Controle de Acesso / Usuário no Header
            userPillHeader: document.getElementById('userPillHeader'),
            headerUserEmail: document.getElementById('headerUserEmail'),
            headerUserCargo: document.getElementById('headerUserCargo'),
            btnUserLogout: document.getElementById('btnUserLogout'),
            btnOpenLoginModal: document.getElementById('btnOpenLoginModal'),

            // Telas
            viewDashboard: document.getElementById('viewDashboard'),
            viewExam: document.getElementById('viewExam'),
            viewResults: document.getElementById('viewResults'),

            // Dashboard & Hero
            btnStartExamHero: document.getElementById('btnStartExamHero'),
            btnImportarApostilas: document.getElementById('btnImportarApostilas'),
            userGreetingBanner: document.getElementById('userGreetingBanner'),
            greetingUserEmail: document.getElementById('greetingUserEmail'),
            greetingUserCargo: document.getElementById('greetingUserCargo'),
            btnSwitchUserHero: document.getElementById('btnSwitchUserHero'),
            btnIdentificarHero: document.getElementById('btnIdentificarHero'),
            historyTableBody: document.getElementById('historyTableBody'),
            btnExportLeads: document.getElementById('btnExportLeads'),

            // Simulado
            questionsMatrix: document.getElementById('questionsMatrix'),
            examContainer: document.getElementById('examContainer'),
            btnModeFocus: document.getElementById('btnModeFocus'),
            btnModeScroll: document.getElementById('btnModeScroll'),
            filterMatrixPills: document.querySelectorAll('.btn-filter-pill'),

            // Modal de Finalização
            confirmModal: document.getElementById('confirmModal'),
            modalTextPending: document.getElementById('modalTextPending'),
            btnModalCancel: document.getElementById('btnModalCancel'),
            btnModalConfirm: document.getElementById('btnModalConfirm'),

            // Modal de Controle de Acesso (E-mail)
            accessModal: document.getElementById('accessModal'),
            formAccess: document.getElementById('formAccess'),
            accessEmail: document.getElementById('accessEmail'),
            accessName: document.getElementById('accessName'),
            accessCargo: document.getElementById('accessCargo'),
            accessErrorMsg: document.getElementById('accessErrorMsg'),
            btnCancelAccess: document.getElementById('btnCancelAccess'),
            btnSubmitAccess: document.getElementById('btnSubmitAccess'),

            // Resultados
            resultPercent: document.getElementById('resultPercent'),
            resultScoreText: document.getElementById('resultScoreText'),
            resultStatusBadge: document.getElementById('resultStatusBadge'),
            statAcertos: document.getElementById('statAcertos'),
            statErros: document.getElementById('statErros'),
            statTempo: document.getElementById('statTempo'),
            diagnosticText: document.getElementById('diagnosticText'),
            subjectsBarsContainer: document.getElementById('subjectsBarsContainer'),
            reviewListContainer: document.getElementById('reviewListContainer'),
            reviewFilterBtns: document.querySelectorAll('.btn-review-filter'),
            btnNovoSimuladoResultado: document.getElementById('btnNovoSimuladoResultado')
        };
    },

    // Event Listeners
    bindEvents() {
        // Gerar simulado
        this.dom.btnStartExamHero.addEventListener('click', () => this.iniciarNovoSimulado());
        if (this.dom.btnNovoSimuladoResultado) {
            this.dom.btnNovoSimuladoResultado.addEventListener('click', () => this.iniciarNovoSimulado());
        }

        // Controle de Acesso
        if (this.dom.btnOpenLoginModal) {
            this.dom.btnOpenLoginModal.addEventListener('click', () => this.abrirModalAcesso());
        }
        if (this.dom.btnIdentificarHero) {
            this.dom.btnIdentificarHero.addEventListener('click', () => this.abrirModalAcesso());
        }
        if (this.dom.btnSwitchUserHero) {
            this.dom.btnSwitchUserHero.addEventListener('click', () => this.abrirModalAcesso());
        }
        if (this.dom.btnUserLogout) {
            this.dom.btnUserLogout.addEventListener('click', () => this.logoutUsuario());
        }
        if (this.dom.formAccess) {
            this.dom.formAccess.addEventListener('submit', (e) => this.salvarAcessoUsuario(e));
        }
        if (this.dom.btnCancelAccess) {
            this.dom.btnCancelAccess.addEventListener('click', () => this.fecharModalAcesso());
        }
        if (this.dom.btnExportLeads) {
            this.dom.btnExportLeads.addEventListener('click', () => this.exportarLeadsCSV());
        }

        // Importar questões das apostilas
        if (this.dom.btnImportarApostilas) {
            this.dom.btnImportarApostilas.addEventListener('click', () => this.importarQuestoesApostilas());
        }

        // Finalizar prova
        this.dom.btnFinishHeader.addEventListener('click', () => this.abrirModalConfirmacao());
        this.dom.btnModalCancel.addEventListener('click', () => this.fecharModalConfirmacao());
        this.dom.btnModalConfirm.addEventListener('click', () => this.finalizarSimulado());

        // Alternância de modo (Foco vs Prova Completa)
        this.dom.btnModeFocus.addEventListener('click', () => this.mudarModoVisualizacao('foco'));
        this.dom.btnModeScroll.addEventListener('click', () => this.mudarModoVisualizacao('completa'));

        // Filtro da matriz lateral de questões
        this.dom.filterMatrixPills.forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.dom.filterMatrixPills.forEach(b => b.classList.remove('active'));
                e.target.classList.add('active');
                this.state.filtroMatriz = e.target.dataset.filter;
                this.renderizarMatrizNavegacao();
            });
        });

        // Filtros da tela de resultados
        this.dom.reviewFilterBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.dom.reviewFilterBtns.forEach(b => b.classList.remove('active'));
                const target = e.currentTarget;
                target.classList.add('active');
                this.state.filtroRevisao = target.dataset.filter;
                this.renderizarRevisaoQuestoes();
            });
        });
    },

    // Troca de Visões
    mostrarTela(nome) {
        this.state.telaAtual = nome;
        this.dom.viewDashboard.classList.remove('active');
        this.dom.viewExam.classList.remove('active');
        this.dom.viewResults.classList.remove('active');

        if (nome === 'dashboard') {
            this.dom.viewDashboard.classList.add('active');
            this.dom.btnFinishHeader.style.display = 'none';
            this.dom.timerBox.style.display = 'none';
            window.scrollTo({ top: 0, behavior: 'smooth' });
        } else if (nome === 'simulado') {
            this.dom.viewExam.classList.add('active');
            this.dom.btnFinishHeader.style.display = 'flex';
            this.dom.timerBox.style.display = 'flex';
        } else if (nome === 'resultado') {
            this.dom.viewResults.classList.add('active');
            this.dom.btnFinishHeader.style.display = 'none';
            this.dom.timerBox.style.display = 'none';
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    },

    // ==========================================================================
    // CRONÔMETRO REGRESSIVO (5 HORAS)
    // ==========================================================================
    iniciarCronometro() {
        if (this.state.timerId) clearInterval(this.state.timerId);

        this.atualizarDisplayCronometro();

        this.state.timerId = setInterval(() => {
            this.state.tempoRestante--;

            this.atualizarDisplayCronometro();
            this.salvarProgressoLocal();

            if (this.state.tempoRestante <= 0) {
                clearInterval(this.state.timerId);
                this.exibirNotificacao("Tempo limite de 5 horas esgotado! Seu simulado será finalizado e corrigido automaticamente.", "error");
                this.finalizarSimulado();
            }
        }, 1000);
    },

    pararCronometro() {
        if (this.state.timerId) {
            clearInterval(this.state.timerId);
            this.state.timerId = null;
        }
    },

    atualizarDisplayCronometro() {
        const total = Math.max(0, this.state.tempoRestante);
        const horas = Math.floor(total / 3600);
        const minutos = Math.floor((total % 3600) / 60);
        const segundos = total % 60;

        const strH = String(horas).padStart(2, '0');
        const strM = String(minutos).padStart(2, '0');
        const strS = String(segundos).padStart(2, '0');

        this.dom.timerDigits.textContent = `${strH}:${strM}:${strS}`;

        // Alertas de tempo
        this.dom.timerBox.classList.remove('timer-warning', 'timer-danger');
        if (total <= 900) { // Menos de 15 minutos
            this.dom.timerBox.classList.add('timer-danger');
        } else if (total <= 3600) { // Menos de 1 hora
            this.dom.timerBox.classList.add('timer-warning');
        }
    },

    // ==========================================================================
    // API: GERAR NOVO SIMULADO (HÍBRIDO: API PHP OU GITHUB PAGES OFFLINE)
    // ==========================================================================
    async iniciarNovoSimulado() {
        // Controle de Acesso Obrigatório: exige pelo menos e-mail antes de começar
        if (!this.state.usuarioAtivo) {
            this.abrirModalAcesso('iniciarSimulado');
            return;
        }

        try {
            this.dom.btnStartExamHero.disabled = true;
            this.dom.btnStartExamHero.innerHTML = '<span>Sorteando 100 Questões FGV...</span>';

            let data = null;

            // Se NÃO estiver no GitHub Pages, tenta carregar da API PHP
            const isGitHubPages = window.location.hostname.endsWith('github.io') || window.location.protocol === 'file:';
            if (!isGitHubPages) {
                try {
                    const response = await fetch(`${this.CONFIG.API_BASE}?action=gerar-prova`);
                    if (response.ok) {
                        const text = await response.text();
                        if (text.trim().startsWith('{')) {
                            data = JSON.parse(text);
                        }
                    }
                } catch (netErr) {
                    console.warn('API PHP não disponível, acionando motor Jamstack/GitHub Pages:', netErr);
                }
            }

            // Se a API não respondeu (ex: GitHub Pages), usa o motor local com BANCO_QUESTOES_COMPLETO
            if (!data || !data.sucesso || !data.questoes || data.questoes.length === 0) {
                data = this.gerarProvaLocal();
            }

            if (!data || !data.questoes || data.questoes.length === 0) {
                throw new Error('Não foi possível carregar as questões. Verifique se o arquivo data/questoes.js foi carregado.');
            }

            // Reseta estado
            this.state.questoes = data.questoes;
            this.state.respostas = {};
            this.state.marcadasRevisao = {};
            this.state.questaoAtualIdx = 0;
            this.state.tempoRestante = this.CONFIG.DURACAO_SEGUNDOS;
            this.state.simuladoIniciadoEm = Date.now();
            this.state.resultado = null;

            this.salvarProgressoLocal();
            this.iniciarCronometro();

            // Renderiza Prova
            this.mostrarTela('simulado');
            this.renderizarMatrizNavegacao();
            this.renderizarAreaQuestoes();
            this.atualizarBarraProgresso();

        } catch (err) {
            console.error(err);
            alert(`Erro ao iniciar simulado: ${err.message}`);
        } finally {
            this.dom.btnStartExamHero.disabled = false;
            this.dom.btnStartExamHero.innerHTML = '<span>⚡ Iniciar Simulado PC PR 2026 (100 Questões)</span>';
        }
    },

    /**
     * Motor Jamstack para execução direta no GitHub Pages (sem PHP/MySQL)
     * Respeita rigorosamente a distribuição de 100 questões do edital PC PR 2026 (FGV)
     */
    gerarProvaLocal() {
        let banco = [];
        if (typeof window !== 'undefined' && window.BANCO_QUESTOES_COMPLETO && Array.isArray(window.BANCO_QUESTOES_COMPLETO)) {
            banco = window.BANCO_QUESTOES_COMPLETO;
        } else if (typeof BANCO_QUESTOES_COMPLETO !== 'undefined' && Array.isArray(BANCO_QUESTOES_COMPLETO)) {
            banco = BANCO_QUESTOES_COMPLETO;
        }

        if (!banco || banco.length === 0) {
            console.error('BANCO_QUESTOES_COMPLETO não encontrado ou vazio!');
            return null;
        }

        const cotas = [
            { id: 1, nome: "Língua Portuguesa", tipo: "Gerais", cota: 15 },
            { id: 2, nome: "Raciocínio Lógico-Matemático", tipo: "Gerais", cota: 10 },
            { id: 3, nome: "Realidade do PR", tipo: "Gerais", cota: 10 },
            { id: 4, nome: "Direito Administrativo", tipo: "Especificos", cota: 10 },
            { id: 5, nome: "Direito Constitucional", tipo: "Especificos", cota: 10 },
            { id: 6, nome: "Direito Penal", tipo: "Especificos", cota: 15 },
            { id: 7, nome: "Direito Processual Penal", tipo: "Especificos", cota: 15 },
            { id: 8, nome: "Legislação Penal Especial", tipo: "Especificos", cota: 15 }
        ];

        let selecionadas = [];
        let distribuicao = [];

        cotas.forEach(c => {
            const doGrupo = banco.filter(q => q.disciplina_id === c.id);
            const embaralhadas = [...doGrupo].sort(() => 0.5 - Math.random());
            const tiradas = embaralhadas.slice(0, Math.min(c.cota, embaralhadas.length));

            distribuicao.push({
                disciplina_id: c.id,
                disciplina: c.nome,
                tipo: c.tipo,
                cota_esperada: c.cota,
                questoes_obtidas: tiradas.length
            });

            selecionadas.push(...tiradas);
        });

        // Embaralha todas as 100 questões
        selecionadas.sort(() => 0.5 - Math.random());

        const formatadas = selecionadas.map((q, idx) => ({
            ...q,
            numero: idx + 1
        }));

        return {
            sucesso: true,
            edital: "PC PR 2026 - Concurso Agente de Polícia e Papiloscopista",
            banca: "FGV - Fundação Getulio Vargas",
            total_questoes: formatadas.length,
            duracao_segundos: 18000,
            distribuicao: distribuicao,
            questoes: formatadas
        };
    },

    // ==========================================================================
    // API: IMPORTAR QUESTÕES DAS APOSTILAS
    // ==========================================================================
    async importarQuestoesApostilas() {
        if (!confirm("Deseja importar as 262 questões extraídas das apostilas para o banco de dados MySQL?")) {
            return;
        }

        try {
            this.dom.btnImportarApostilas.disabled = true;
            this.dom.btnImportarApostilas.innerHTML = '<span>⏳ Importando 262 questões...</span>';

            const response = await fetch(`${this.CONFIG.API_BASE}?action=importar-apostilas`, {
                method: 'POST'
            });
            const data = await response.json();

            if (!data.sucesso) {
                throw new Error(data.erro || 'Falha ao importar questões.');
            }

            alert(`Sucesso! ${data.mensagem}\nTotal de questões agora no banco: ${data.total_no_banco}`);
            this.dom.btnImportarApostilas.innerHTML = `<span>✓ ${data.importadas} Questões Importadas!</span>`;
            this.dom.btnImportarApostilas.style.borderColor = '#10b981';
            this.dom.btnImportarApostilas.style.color = '#10b981';

        } catch (err) {
            console.error(err);
            alert(`Erro na importação: ${err.message}\nVocê também pode importar diretamente o arquivo questoes_apostilas.sql no phpMyAdmin.`);
            this.dom.btnImportarApostilas.disabled = false;
            this.dom.btnImportarApostilas.innerHTML = '<span>📥 Importar +262 Questões das Apostilas</span>';
        }
    },

    // ==========================================================================
    // RENDERIZAÇÃO DA PROVA
    // ==========================================================================
    renderizarMatrizNavegacao() {
        this.dom.questionsMatrix.innerHTML = '';

        this.state.questoes.forEach((q, idx) => {
            const questaoId = q.id;
            const respondida = this.state.respostas[questaoId] !== undefined;
            const flagada = !!this.state.marcadasRevisao[questaoId];

            // Filtros da barra lateral
            if (this.state.filtroMatriz === 'pendentes' && respondida) return;
            if (this.state.filtroMatriz === 'marcadas' && !flagada) return;

            const btn = document.createElement('button');
            btn.className = 'matrix-btn';
            btn.textContent = idx + 1;
            btn.dataset.index = idx;
            btn.title = `Questão ${idx + 1} - ${q.disciplina_nome}`;

            if (idx === this.state.questaoAtualIdx && this.state.modoVisualizacao === 'foco') {
                btn.classList.add('active-current');
            }
            if (respondida) {
                btn.classList.add('answered');
            }
            if (flagada) {
                btn.classList.add('flagged');
            }

            btn.addEventListener('click', () => {
                this.irParaQuestao(idx);
            });

            this.dom.questionsMatrix.appendChild(btn);
        });
    },

    mudarModoVisualizacao(modo) {
        this.state.modoVisualizacao = modo;
        this.dom.btnModeFocus.classList.toggle('active', modo === 'foco');
        this.dom.btnModeScroll.classList.toggle('active', modo === 'completa');
        this.renderizarAreaQuestoes();
        this.renderizarMatrizNavegacao();
    },

    irParaQuestao(index) {
        this.state.questaoAtualIdx = index;
        if (this.state.modoVisualizacao === 'foco') {
            this.renderizarAreaQuestoes();
            this.renderizarMatrizNavegacao();
            window.scrollTo({ top: 90, behavior: 'smooth' });
        } else {
            // Scroll até a questão correspondente
            const cardEl = document.getElementById(`q-card-${index}`);
            if (cardEl) {
                cardEl.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }
        }
    },

    renderizarAreaQuestoes() {
        this.dom.examContainer.innerHTML = '';

        if (this.state.modoVisualizacao === 'foco') {
            // Renderiza apenas a questão atual
            const q = this.state.questoes[this.state.questaoAtualIdx];
            if (!q) return;

            const card = this.criarCardQuestao(q, this.state.questaoAtualIdx, true);
            this.dom.examContainer.appendChild(card);
        } else {
            // Renderiza todas as 100 questões em scroll contínuo
            this.state.questoes.forEach((q, idx) => {
                const card = this.criarCardQuestao(q, idx, false);
                this.dom.examContainer.appendChild(card);
            });
        }
    },

    criarCardQuestao(q, idx, incluirNavegacaoRodape) {
        const card = document.createElement('div');
        card.className = 'question-card';
        card.id = `q-card-${idx}`;

        const questaoId = q.id;
        const respondidaVal = this.state.respostas[questaoId];
        const isFlagged = !!this.state.marcadasRevisao[questaoId];

        // Header da Questão
        const header = document.createElement('div');
        header.className = 'question-header';
        header.innerHTML = `
            <div class="question-meta">
                <span class="badge-num">Questão ${idx + 1}</span>
                <span class="badge-subject">${q.disciplina_nome}</span>
                <span class="badge-type">${q.disciplina_tipo}</span>
            </div>
            <button class="btn-flag-review ${isFlagged ? 'active' : ''}" type="button" data-qid="${questaoId}">
                ★ ${isFlagged ? 'Marcada para Revisão' : 'Marcar para Revisão'}
            </button>
        `;

        // Evento do botão marcar para revisão
        const flagBtn = header.querySelector('.btn-flag-review');
        flagBtn.addEventListener('click', () => {
            this.toggleMarcarRevisao(questaoId);
        });

        // Enunciado
        const statement = document.createElement('div');
        statement.className = 'question-statement';
        statement.textContent = q.enunciado;

        // Alternativas A, B, C, D, E
        const altsGroup = document.createElement('div');
        altsGroup.className = 'alternatives-group';

        const letras = ['A', 'B', 'C', 'D', 'E'];
        letras.forEach(letra => {
            const textoAlt = q[`alt_${letra.toLowerCase()}`];
            const isSelected = respondidaVal === letra;

            const label = document.createElement('label');
            label.className = `alt-label ${isSelected ? 'selected' : ''}`;
            label.innerHTML = `
                <input type="radio" name="resp_${questaoId}" value="${letra}" class="alt-input" ${isSelected ? 'checked' : ''}>
                <div class="alt-letter">${letra}</div>
                <div class="alt-text">${textoAlt}</div>
            `;

            label.addEventListener('click', (e) => {
                this.selecionarResposta(questaoId, letra);
            });

            altsGroup.appendChild(label);
        });

        card.appendChild(header);
        card.appendChild(statement);
        card.appendChild(altsGroup);

        // Rodapé com navegação (se modo foco)
        if (incluirNavegacaoRodape) {
            const footerNav = document.createElement('div');
            footerNav.className = 'question-footer-nav';

            const btnPrev = document.createElement('button');
            btnPrev.className = 'btn-nav-prev';
            btnPrev.innerHTML = '&larr; Anterior';
            btnPrev.disabled = idx === 0;
            btnPrev.addEventListener('click', () => {
                if (this.state.questaoAtualIdx > 0) {
                    this.irParaQuestao(this.state.questaoAtualIdx - 1);
                }
            });

            const btnNext = document.createElement('button');
            btnNext.className = 'btn-nav-next';
            btnNext.innerHTML = (idx === this.state.questoes.length - 1) ? 'Finalizar Prova &rarr;' : 'Próxima &rarr;';
            btnNext.addEventListener('click', () => {
                if (this.state.questaoAtualIdx < this.state.questoes.length - 1) {
                    this.irParaQuestao(this.state.questaoAtualIdx + 1);
                } else {
                    this.abrirModalConfirmacao();
                }
            });

            footerNav.appendChild(btnPrev);
            footerNav.appendChild(btnNext);
            card.appendChild(footerNav);
        }

        return card;
    },

    selecionarResposta(questaoId, letra) {
        this.state.respostas[questaoId] = letra;
        this.salvarProgressoLocal();
        this.atualizarBarraProgresso();
        this.renderizarMatrizNavegacao();

        // Atualiza visual dos cards de alternativas na tela
        const cardEl = document.querySelector(`[data-qid="${questaoId}"]`)?.closest('.question-card') ||
                       document.getElementById(`q-card-${this.state.questaoAtualIdx}`);

        if (cardEl) {
            const labels = cardEl.querySelectorAll('.alt-label');
            labels.forEach(lbl => {
                const input = lbl.querySelector('input');
                if (input && input.value === letra) {
                    lbl.classList.add('selected');
                    input.checked = true;
                } else {
                    lbl.classList.remove('selected');
                }
            });
        }
    },

    toggleMarcarRevisao(questaoId) {
        if (this.state.marcadasRevisao[questaoId]) {
            delete this.state.marcadasRevisao[questaoId];
        } else {
            this.state.marcadasRevisao[questaoId] = true;
        }
        this.salvarProgressoLocal();
        this.renderizarMatrizNavegacao();
        this.renderizarAreaQuestoes();
    },

    atualizarBarraProgresso() {
        const total = this.state.questoes.length || 100;
        const respondidas = Object.keys(this.state.respostas).length;
        const perc = Math.round((respondidas / total) * 100);

        this.dom.progressCount.innerHTML = `Respondidas: <strong>${respondidas}</strong> / ${total}`;
        this.dom.progressBarFill.style.width = `${perc}%`;
    },

    // ==========================================================================
    // FINALIZAÇÃO E ENVIO (POST /salvar-resultado)
    // ==========================================================================
    abrirModalConfirmacao() {
        const total = this.state.questoes.length || 100;
        const respondidas = Object.keys(this.state.respostas).length;
        const pendentes = total - respondidas;

        if (pendentes > 0) {
            this.dom.modalTextPending.textContent = `Atenção: você ainda tem ${pendentes} questões não respondidas. Deseja finalizar mesmo assim?`;
            this.dom.modalTextPending.style.display = 'block';
        } else {
            this.dom.modalTextPending.textContent = `Excelente! Você respondeu todas as ${total} questões do simulado.`;
            this.dom.modalTextPending.style.display = 'block';
        }

        this.dom.confirmModal.classList.add('active');
    },

    fecharModalConfirmacao() {
        this.dom.confirmModal.classList.remove('active');
    },

    async finalizarSimulado() {
        this.fecharModalConfirmacao();
        this.pararCronometro();

        const tempoTotalDisponivel = this.CONFIG.DURACAO_SEGUNDOS;
        const tempoGastoSegundos = Math.max(0, tempoTotalDisponivel - this.state.tempoRestante);

        // Prepara payload com identificação do candidato
        const user = this.state.usuarioAtivo;
        const payload = {
            usuario_email: user ? user.email : 'candidato@email.com',
            usuario_nome: user ? (user.nome || user.email) : 'Candidato PC PR 2026',
            usuario_cargo: user ? user.cargo : 'Agente de Polícia',
            tempo_gasto_segundos: tempoGastoSegundos,
            respostas: this.state.respostas
        };

        let data = null;

        try {
            this.dom.btnFinishHeader.disabled = true;
            this.dom.btnFinishHeader.textContent = 'Corrigindo...';

            const isGitHubPages = window.location.hostname.endsWith('github.io') || window.location.protocol === 'file:';
            if (!isGitHubPages) {
                try {
                    const response = await fetch(`${this.CONFIG.API_BASE}?action=salvar-resultado`, {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify(payload)
                    });
                    if (response.ok) {
                        const text = await response.text();
                        if (text.trim().startsWith('{')) {
                            data = JSON.parse(text);
                        }
                    }
                } catch (netErr) {
                    console.warn('API PHP não disponível para salvar resultado, acionando motor local:', netErr);
                }
            }

            // Fallback para correção direta no navegador (GitHub Pages)
            if (!data || !data.sucesso) {
                data = this.corrigirProvaLocal(payload);
            }

            if (!data) {
                throw new Error('Erro ao processar correção da prova.');
            }

            // Limpa armazenamento local do simulado em andamento
            localStorage.removeItem(this.CONFIG.STORAGE_KEY);

            this.state.resultado = data;
            this.exibirTelaResultados(data);
            this.carregarHistoricoDashboard();

        } catch (err) {
            console.error(err);
            alert(`Falha na correção: ${err.message}`);
        } finally {
            this.dom.btnFinishHeader.disabled = false;
            this.dom.btnFinishHeader.innerHTML = '<span>🏁 Finalizar e Corrigir Prova</span>';
        }
    },

    /**
     * Motor de correção local para o GitHub Pages (roda no cliente)
     */
    corrigirProvaLocal(payload) {
        const respostas = payload.respostas || {};
        const tempoGasto = payload.tempo_gasto_segundos || 0;
        const questoes = this.state.questoes || [];

        let totalAcertos = 0;
        let totalErros = 0;
        let desempenhoDisc = {};
        let corrigidas = [];

        questoes.forEach(q => {
            const qid = q.id;
            const respUser = (respostas[qid] || "").toString().trim().toUpperCase();
            const gabarito = (q.gabarito || "").toString().trim().toUpperCase();
            const acertou = (respUser !== "" && respUser === gabarito);

            if (acertou) totalAcertos++;
            else totalErros++;

            const dNome = q.disciplina_nome;
            if (!desempenhoDisc[dNome]) {
                desempenhoDisc[dNome] = {
                    disciplina: dNome,
                    tipo: q.disciplina_tipo,
                    total: 0,
                    acertos: 0,
                    erros: 0,
                    percentual: 0
                };
            }
            desempenhoDisc[dNome].total++;
            if (acertou) desempenhoDisc[dNome].acertos++;
            else desempenhoDisc[dNome].erros++;

            corrigidas.push({
                questao_id: qid,
                disciplina: dNome,
                tipo: q.disciplina_tipo,
                enunciado: q.enunciado,
                alt_a: q.alt_a,
                alt_b: q.alt_b,
                alt_c: q.alt_c,
                alt_d: q.alt_d,
                alt_e: q.alt_e,
                resposta_usuario: respUser,
                gabarito_oficial: gabarito,
                acertou: acertou,
                comentario: q.comentario
            });
        });

        Object.values(desempenhoDisc).forEach(d => {
            d.percentual = d.total > 0 ? Math.round((d.acertos / d.total) * 1000) / 10 : 0;
        });

        const percGlobal = Math.round((totalAcertos / Math.max(1, questoes.length)) * 1000) / 10;

        const boas = Object.values(desempenhoDisc).filter(d => d.percentual >= 70).map(d => `${d.disciplina} (${d.percentual}%)`);
        const fracas = Object.values(desempenhoDisc).filter(d => d.percentual < 60).map(d => `${d.disciplina} (${d.percentual}%)`);

        let diag = "Simulado finalizado!";
        if (boas.length > 0 && fracas.length > 0) {
            diag = `Você foi muito bem em ${boas.join(', ')}, mas precisa reforçar seus estudos em ${fracas.join(', ')}.`;
        } else if (fracas.length > 0) {
            diag = `Atenção: concentre sua preparação nas matérias críticas: ${fracas.join(', ')}.`;
        } else if (boas.length > 0) {
            diag = `Excelente aproveitamento! Domínio consistente em todas as disciplinas avaliadas.`;
        }

        const h = Math.floor(tempoGasto / 3600);
        const m = Math.floor((tempoGasto % 3600) / 60);
        const s = tempoGasto % 60;
        const tempoFmt = `${String(h).padStart(2, '0')}h ${String(m).padStart(2, '0')}m ${String(s).padStart(2, '0')}s`;

        const resultado = {
            sucesso: true,
            simulado_id: Date.now(),
            usuario_nome: payload.usuario_nome || 'Candidato PC PR',
            total_questoes: questoes.length,
            total_acertos: totalAcertos,
            total_erros: totalErros,
            percentual_acerto: percGlobal,
            tempo_gasto_segundos: tempoGasto,
            tempo_formatado: tempoFmt,
            feedback_diagnostico: diag,
            desempenho_disciplinas: Object.values(desempenhoDisc),
            questoes_corrigidas: corrigidas
        };

        // Salva no histórico do LocalStorage com identificação do candidato
        try {
            const histKey = this.CONFIG.HISTORICO_KEY;
            const histAtual = JSON.parse(localStorage.getItem(histKey) || '[]');
            const user = this.state.usuarioAtivo;
            const novoReg = {
                id: histAtual.length + 1,
                usuario_email: user ? user.email : (payload.usuario_email || 'candidato@email.com'),
                usuario_nome: user ? (user.nome || user.email) : (payload.usuario_nome || 'Candidato PC PR'),
                usuario_cargo: user ? user.cargo : (payload.usuario_cargo || 'Agente de Polícia'),
                data_formatada: new Date().toLocaleDateString('pt-BR') + ' ' + new Date().toLocaleTimeString('pt-BR', {hour: '2-digit', minute:'2-digit'}),
                total_questoes: questoes.length,
                total_acertos: totalAcertos,
                total_erros: totalErros,
                percentual_acerto: percGlobal,
                tempo_formatado: tempoFmt
            };
            histAtual.unshift(novoReg);
            localStorage.setItem(histKey, JSON.stringify(histAtual.slice(0, 30)));

            this.registrarSimuladoNoLead();
        } catch (e) {
            console.warn('Erro ao salvar histórico local:', e);
        }

        return resultado;
    },

    // ==========================================================================
    // TELA DE RESULTADOS E ANÁLISE PEDAGÓGICA
    // ==========================================================================
    exibirTelaResultados(res) {
        this.mostrarTela('resultado');

        // Resumo Geral
        this.dom.resultPercent.textContent = `${res.percentual_acerto}%`;
        this.dom.resultScoreText.textContent = `Você acertou ${res.total_acertos} de ${res.total_questoes} questões`;

        if (res.percentual_acerto >= 75) {
            this.dom.resultStatusBadge.className = 'badge-score high';
            this.dom.resultStatusBadge.textContent = 'Classificado na Prova Objetiva (Nota Alta)';
        } else if (res.percentual_acerto >= 60) {
            this.dom.resultStatusBadge.className = 'badge-score medium';
            this.dom.resultStatusBadge.textContent = 'Competitivo / Na Linha de Corte';
        } else {
            this.dom.resultStatusBadge.className = 'badge-score low';
            this.dom.resultStatusBadge.textContent = 'Abaixo da Nota de Corte Esperada';
        }

        this.dom.statAcertos.textContent = res.total_acertos;
        this.dom.statErros.textContent = res.total_erros;
        this.dom.statTempo.textContent = res.tempo_formatado || `${Math.floor(res.tempo_gasto_segundos/60)} min`;

        // Feedback Textual Inteligente Solicitado no Prompt
        this.dom.diagnosticText.textContent = res.feedback_diagnostico;

        // Desempenho por Disciplina (Barras Gráficas)
        this.dom.subjectsBarsContainer.innerHTML = '';
        if (res.desempenho_disciplinas && Array.isArray(res.desempenho_disciplinas)) {
            res.desempenho_disciplinas.forEach(disc => {
                const barItem = document.createElement('div');
                barItem.className = 'subject-bar-item';

                let barClass = 'bad';
                if (disc.percentual >= 75) barClass = 'good';
                else if (disc.percentual >= 60) barClass = 'medium';

                barItem.innerHTML = `
                    <div class="bar-header">
                        <span>${disc.disciplina} (${disc.tipo})</span>
                        <span><strong>${disc.acertos}/${disc.total}</strong> (${disc.percentual}%)</span>
                    </div>
                    <div class="bar-container">
                        <div class="bar-fill ${barClass}" style="width: ${disc.percentual}%"></div>
                    </div>
                `;
                this.dom.subjectsBarsContainer.appendChild(barItem);
            });
        }

        // Renderiza questões corrigidas
        this.renderizarRevisaoQuestoes();
    },

    renderizarRevisaoQuestoes() {
        if (!this.state.resultado || !this.state.resultado.questoes_corrigidas) return;

        this.dom.reviewListContainer.innerHTML = '';
        const lista = this.state.resultado.questoes_corrigidas;

        let filtradas = lista;
        if (this.state.filtroRevisao === 'erros') {
            filtradas = lista.filter(q => !q.acertou);
        } else if (this.state.filtroRevisao === 'acertos') {
            filtradas = lista.filter(q => q.acertou);
        }

        if (filtradas.length === 0) {
            this.dom.reviewListContainer.innerHTML = `
                <div style="text-align: center; padding: 2rem; color: #64748b;">
                    Nenhuma questão encontrada para este filtro.
                </div>
            `;
            return;
        }

        filtradas.forEach((q, idx) => {
            const card = document.createElement('div');
            card.className = `review-question-card ${q.acertou ? 'correct' : 'wrong'}`;

            const letras = ['A', 'B', 'C', 'D', 'E'];
            let htmlAlts = '';

            letras.forEach(letra => {
                const textoAlt = q[`alt_${letra.toLowerCase()}`];
                let classeAlt = 'review-alt-item';

                if (letra === q.gabarito_oficial) {
                    classeAlt += ' official-correct';
                } else if (!q.acertou && letra === q.resposta_usuario) {
                    classeAlt += ' user-wrong';
                }

                htmlAlts += `
                    <div class="${classeAlt}">
                        <strong>${letra})</strong> ${textoAlt}
                        ${letra === q.gabarito_oficial ? ' <span style="font-weight:700;">(Gabarito Oficial FGV)</span>' : ''}
                        ${(!q.acertou && letra === q.resposta_usuario) ? ' <span style="font-weight:700;">(Sua Resposta)</span>' : ''}
                    </div>
                `;
            });

            card.innerHTML = `
                <div class="review-meta">
                    <div>
                        <strong style="color: var(--primary);">Questão ${q.questao_id}</strong> - 
                        <span style="font-size: 0.85rem; color: #475569;">${q.disciplina} (${q.tipo})</span>
                    </div>
                    <span class="review-status-badge ${q.acertou ? 'correct' : 'wrong'}">
                        ${q.acertou ? '✓ Acertou' : '✕ Errou'}
                    </span>
                </div>
                <div style="font-size: 0.98rem; margin-bottom: 1rem; color: #1e293b; line-height: 1.6;">
                    ${q.enunciado}
                </div>
                <div style="margin-bottom: 1rem;">
                    ${htmlAlts}
                </div>
                <div class="commentary-box">
                    <h4>💡 Gabarito Comentado e Fundamentação:</h4>
                    <div class="commentary-content">${q.comentario}</div>
                </div>
            `;

            this.dom.reviewListContainer.appendChild(card);
        });
    },

    // ==========================================================================
    // HISTÓRICO NO DASHBOARD (LOCALSTORAGE + API PHP HÍBRIDO)
    // ==========================================================================
    async carregarHistoricoDashboard() {
        let historico = [];

        // 1. Tenta carregar do LocalStorage
        try {
            const histLocal = JSON.parse(localStorage.getItem(this.CONFIG.HISTORICO_KEY) || '[]');
            if (Array.isArray(histLocal) && histLocal.length > 0) {
                historico = histLocal;
            }
        } catch (e) {
            console.warn('Erro ao ler histórico local:', e);
        }

        // 2. Se não houver histórico local e não for GitHub Pages, tenta a API PHP
        const isGitHubPages = window.location.hostname.endsWith('github.io') || window.location.protocol === 'file:';
        if (historico.length === 0 && !isGitHubPages) {
            try {
                const response = await fetch(`${this.CONFIG.API_BASE}?action=historico`);
                if (response.ok) {
                    const text = await response.text();
                    if (text.trim().startsWith('{')) {
                        const data = JSON.parse(text);
                        if (data.sucesso && Array.isArray(data.historico)) {
                            historico = data.historico;
                        }
                    }
                }
            } catch (err) {
                console.warn("Não foi possível carregar o histórico via API:", err);
            }
        }

        if (historico.length === 0) {
            this.dom.historyTableBody.innerHTML = `
                <tr>
                    <td colspan="6" style="text-align: center; color: #94a3b8; padding: 1.5rem;">
                        Nenhum simulado registrado até o momento. Identifique-se com seu e-mail e clique em "Iniciar Simulado" acima para começar seu primeiro teste!
                    </td>
                </tr>
            `;
            return;
        }

        this.dom.historyTableBody.innerHTML = '';
        historico.forEach(item => {
            const tr = document.createElement('tr');

            let badgeClass = 'low';
            if (item.percentual_acerto >= 75) badgeClass = 'high';
            else if (item.percentual_acerto >= 60) badgeClass = 'medium';

            const userDisplay = item.usuario_email ? item.usuario_email : (item.usuario_nome || 'Candidato PC PR');

            tr.innerHTML = `
                <td><strong>#${item.id}</strong></td>
                <td><span style="font-weight: 600; color: #0b1f38;">${userDisplay}</span></td>
                <td>${item.data_formatada}</td>
                <td>${item.total_acertos} / ${item.total_questoes}</td>
                <td><span class="badge-score ${badgeClass}">${item.percentual_acerto}%</span></td>
                <td>${item.tempo_formatado}</td>
            `;
            this.dom.historyTableBody.appendChild(tr);
        });
    },

    // ==========================================================================
    // CONTROLE DE ACESSO & IDENTIFICAÇÃO DO CANDIDATO
    // ==========================================================================
    carregarUsuarioAtivo() {
        try {
            const salvo = localStorage.getItem(this.CONFIG.USER_KEY);
            if (salvo) {
                this.state.usuarioAtivo = JSON.parse(salvo);
            }
        } catch (e) {
            console.warn('Erro ao carregar usuário ativo:', e);
            this.state.usuarioAtivo = null;
        }
        this.atualizarUIUsuario();
    },

    atualizarUIUsuario() {
        const u = this.state.usuarioAtivo;
        if (u && u.email) {
            // Header
            if (this.dom.userPillHeader) this.dom.userPillHeader.style.display = 'inline-flex';
            if (this.dom.headerUserEmail) this.dom.headerUserEmail.textContent = u.nome || u.email;
            if (this.dom.headerUserCargo) this.dom.headerUserCargo.textContent = u.cargo || 'Agente PC PR';
            if (this.dom.btnOpenLoginModal) this.dom.btnOpenLoginModal.style.display = 'none';

            // Hero
            if (this.dom.userGreetingBanner) this.dom.userGreetingBanner.style.display = 'flex';
            if (this.dom.greetingUserEmail) this.dom.greetingUserEmail.textContent = u.nome || u.email;
            if (this.dom.greetingUserCargo) this.dom.greetingUserCargo.textContent = u.cargo || 'Agente de Polícia';
            if (this.dom.btnIdentificarHero) this.dom.btnIdentificarHero.style.display = 'none';
        } else {
            // Header
            if (this.dom.userPillHeader) this.dom.userPillHeader.style.display = 'none';
            if (this.dom.btnOpenLoginModal) this.dom.btnOpenLoginModal.style.display = 'inline-flex';

            // Hero
            if (this.dom.userGreetingBanner) this.dom.userGreetingBanner.style.display = 'none';
            if (this.dom.btnIdentificarHero) this.dom.btnIdentificarHero.style.display = 'inline-flex';
        }
    },

    abrirModalAcesso(acaoAposLogin = null) {
        this.state.pendenteAcaoAposLogin = acaoAposLogin;
        if (this.dom.accessModal) {
            this.dom.accessModal.classList.add('active');
            if (this.dom.accessErrorMsg) this.dom.accessErrorMsg.style.display = 'none';
            if (this.state.usuarioAtivo) {
                if (this.dom.accessEmail) this.dom.accessEmail.value = this.state.usuarioAtivo.email || '';
                if (this.dom.accessName) this.dom.accessName.value = this.state.usuarioAtivo.nome || '';
                if (this.dom.accessCargo) this.dom.accessCargo.value = this.state.usuarioAtivo.cargo || 'Agente de Polícia';
            }
            setTimeout(() => {
                if (this.dom.accessEmail) this.dom.accessEmail.focus();
            }, 100);
        }
    },

    fecharModalAcesso() {
        if (this.dom.accessModal) {
            this.dom.accessModal.classList.remove('active');
        }
        this.state.pendenteAcaoAposLogin = null;
    },

    salvarAcessoUsuario(e) {
        if (e && e.preventDefault) e.preventDefault();

        const email = (this.dom.accessEmail ? this.dom.accessEmail.value : '').trim().toLowerCase();
        const nome = (this.dom.accessName ? this.dom.accessName.value : '').trim();
        const cargo = (this.dom.accessCargo ? this.dom.accessCargo.value : 'Agente de Polícia');

        // Validação simples de e-mail
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!email || !emailRegex.test(email)) {
            if (this.dom.accessErrorMsg) {
                this.dom.accessErrorMsg.textContent = 'Por favor, insira um endereço de e-mail válido para acessar.';
                this.dom.accessErrorMsg.style.display = 'block';
            }
            return;
        }

        const usuario = {
            email: email,
            nome: nome,
            cargo: cargo,
            dataLogin: new Date().toISOString()
        };

        // Salva usuário ativo
        localStorage.setItem(this.CONFIG.USER_KEY, JSON.stringify(usuario));
        this.state.usuarioAtivo = usuario;

        // Salva ou atualiza na lista de leads cadastrados
        this.registrarLead(usuario);

        this.atualizarUIUsuario();
        this.fecharModalAcesso();

        // Se o usuário clicou em iniciar antes de se identificar, dispara a prova agora
        if (this.state.pendenteAcaoAposLogin === 'iniciarSimulado') {
            this.state.pendenteAcaoAposLogin = null;
            this.iniciarNovoSimulado();
        } else {
            this.carregarHistoricoDashboard();
        }
    },

    logoutUsuario() {
        if (confirm('Deseja realmente desconectar o candidato ativo?')) {
            localStorage.removeItem(this.CONFIG.USER_KEY);
            this.state.usuarioAtivo = null;
            this.atualizarUIUsuario();
            this.carregarHistoricoDashboard();
        }
    },

    registrarLead(usuario) {
        try {
            const leads = JSON.parse(localStorage.getItem(this.CONFIG.LEADS_KEY) || '[]');
            const idx = leads.findIndex(l => l.email === usuario.email);
            const agora = new Date().toLocaleString('pt-BR');

            if (idx >= 0) {
                leads[idx].ultimoAcesso = agora;
                leads[idx].cargo = usuario.cargo || leads[idx].cargo;
                if (usuario.nome) leads[idx].nome = usuario.nome;
            } else {
                leads.push({
                    email: usuario.email,
                    nome: usuario.nome || '',
                    cargo: usuario.cargo || 'Agente de Polícia',
                    primeiroAcesso: agora,
                    ultimoAcesso: agora,
                    simuladosFeitos: 0
                });
            }
            localStorage.setItem(this.CONFIG.LEADS_KEY, JSON.stringify(leads));
        } catch (e) {
            console.warn('Erro ao salvar lead:', e);
        }
    },

    registrarSimuladoNoLead() {
        if (!this.state.usuarioAtivo || !this.state.usuarioAtivo.email) return;
        try {
            const leads = JSON.parse(localStorage.getItem(this.CONFIG.LEADS_KEY) || '[]');
            const idx = leads.findIndex(l => l.email === this.state.usuarioAtivo.email);
            if (idx >= 0) {
                leads[idx].simuladosFeitos = (leads[idx].simuladosFeitos || 0) + 1;
                leads[idx].ultimoSimulado = new Date().toLocaleString('pt-BR');
                localStorage.setItem(this.CONFIG.LEADS_KEY, JSON.stringify(leads));
            }
        } catch (e) {}
    },

    exportarLeadsCSV() {
        try {
            const leads = JSON.parse(localStorage.getItem(this.CONFIG.LEADS_KEY) || '[]');
            if (leads.length === 0) {
                alert('Nenhum candidato cadastrado até o momento.');
                return;
            }

            let csv = '\uFEFF'; // BOM para Excel abrir acentos em UTF-8
            csv += 'E-mail;Nome;Cargo Pretendido;Primeiro Acesso;Último Acesso;Simulados Concluídos\n';

            leads.forEach(l => {
                csv += `"${l.email}";"${l.nome || ''}";"${l.cargo || ''}";"${l.primeiroAcesso || ''}";"${l.ultimoAcesso || ''}";"${l.simuladosFeitos || 0}"\n`;
            });

            const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `candidatos_pcpr_simulados_${new Date().toISOString().slice(0,10)}.csv`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);
        } catch (err) {
            alert('Erro ao exportar relatório CSV: ' + err.message);
        }
    },

    // ==========================================================================
    // LOCALSTORAGE (RECUPERAÇÃO CONTRA F5 / REFRESH)
    // ==========================================================================
    salvarProgressoLocal() {
        if (!this.state.questoes || this.state.questoes.length === 0) return;

        const dados = {
            questoes: this.state.questoes,
            respostas: this.state.respostas,
            marcadasRevisao: this.state.marcadasRevisao,
            questaoAtualIdx: this.state.questaoAtualIdx,
            tempoRestante: this.state.tempoRestante,
            simuladoIniciadoEm: this.state.simuladoIniciadoEm
        };
        localStorage.setItem(this.CONFIG.STORAGE_KEY, JSON.stringify(dados));
    },

    verificarSimuladoSalvo() {
        const salvoRaw = localStorage.getItem(this.CONFIG.STORAGE_KEY);
        if (!salvoRaw) return;

        try {
            const salvo = JSON.parse(salvoRaw);
            if (salvo && salvo.questoes && salvo.questoes.length > 0 && salvo.tempoRestante > 0) {
                const retomar = confirm("Identificamos um simulado em andamento no seu navegador. Deseja continuar de onde parou?");
                if (retomar) {
                    this.state.questoes = salvo.questoes;
                    this.state.respostas = salvo.respostas || {};
                    this.state.marcadasRevisao = salvo.marcadasRevisao || {};
                    this.state.questaoAtualIdx = salvo.questaoAtualIdx || 0;
                    this.state.tempoRestante = salvo.tempoRestante || (5 * 3600);
                    this.state.simuladoIniciadoEm = salvo.simuladoIniciadoEm || Date.now();

                    this.mostrarTela('simulado');
                    this.iniciarCronometro();
                    this.renderizarMatrizNavegacao();
                    this.renderizarAreaQuestoes();
                    this.atualizarBarraProgresso();
                } else {
                    localStorage.removeItem(this.CONFIG.STORAGE_KEY);
                }
            }
        } catch (e) {
            localStorage.removeItem(this.CONFIG.STORAGE_KEY);
        }
    }
};

// Inicia quando o DOM estiver pronto
document.addEventListener('DOMContentLoaded', () => {
    App.init();
});
