# 🏛️ Portal de Provas e Simulados - PC PR 2026 (Banca FGV)
### Concurso Público para Agente de Polícia e Papiloscopista Policial

Sistema Full-Stack completo desenvolvido para geração inteligente de simulados aleatórios respeitando rigorosamente as cotas de disciplinas do Edital PC PR 2026 da Banca FGV, com cronômetro de 5 horas, interface SPA responsiva, correção automática e análise pedagógica por disciplina com gabarito comentado.

---

## 🎯 Regras de Negócio e Distribuição das Questões (100 Itens)

A prova objetiva segue a divisão oficial do edital com 100 questões de múltipla escolha (A, B, C, D, E):

### 1. Conhecimentos Gerais (35 questões no total):
- **Língua Portuguesa:** 15 questões
- **Raciocínio Lógico-Matemático (RLM):** 10 questões
- **Realidade do Paraná:** 10 questões

### 2. Conhecimentos Específicos (65 questões no total):
- **Direito Administrativo:** 10 questões
- **Direito Constitucional:** 10 questões
- **Direito Penal:** 15 questões
- **Direito Processual Penal:** 15 questões
- **Legislação Penal Especial:** 15 questões

---

## 🚀 Tecnologias Utilizadas

- **Backend:** PHP 8.x Orientado a Objetos (API RESTful com PDO, CORS, JSON).
- **Banco de Dados:** MySQL 8.0 (com índices, chaves estrangeiras, transações e suporte nativo a JSON).
- **Frontend:** HTML5 semântico, CSS3 moderno (design focado na leitura estilo concurso) e JavaScript Vanilla (Single Page Application sem dependências externas).
- **Infraestrutura:** Pronto para **XAMPP**, **WampServer**, **Docker** ou PHP Built-in Server.

---

## 📂 Estrutura de Arquivos

```
e:\Projetos\
├── css/
│   └── style.css            # Folha de estilo moderna, responsiva com paleta PC PR
├── data/
│   ├── questoes.js          # Banco estruturado com 362 questões para execução direta no navegador (GitHub Pages)
│   └── questoes.json        # Dataset completo de 362 questões em formato JSON
├── js/
│   └── app.js               # SPA Vanilla JS: cronômetro, navegação 1-100, motor híbrido (API / Client-Side) e LocalStorage
├── api.php                  # API RESTful em PHP OOP (rotas: gerar-prova, salvar-resultado, importar-apostilas)
├── db.php                   # Singleton PDO com tratamento de erros e suporte a .env
├── database.sql             # Esquema DDL + 100 questões iniciais no padrão FGV
├── questoes_apostilas.sql   # 262 questões extraídas dos arquivos Word (.docx) das apostilas
├── database_completo.sql    # Banco unificado com 362 questões de concursos e simulados
├── extrair_questoes.ps1     # Script extrator automático de questões dos arquivos DOCX
├── index.html               # Dashboard, ambiente de simulado e tela de resultados
├── Iniciar_Simulados_PCPR.bat # Inicializador 1-clique no Windows
├── server.py                # Servidor local Python integrado com suporte a API
├── docker-compose.yml       # Orquestração de containers PHP + MySQL
├── Dockerfile               # Imagem PHP 8.2 Apache com pdo_mysql
├── .htaccess                # Configurações de mod_rewrite e UTF-8 para Apache
└── README.md                # Documentação técnica e guia de execução
```

---

## 🛠️ Como Executar Localmente

### Opção 1: Executando via XAMPP (Recomendado no Windows)

1. **Inicie o XAMPP Control Panel** e dê **Start** nos módulos **Apache** e **MySQL**.
2. **Crie e Popule o Banco de Dados:**
   - Abra o navegador em `http://localhost/phpmyadmin`.
   - Clique em **Importar** (ou crie o banco `pcpr_simulados`).
   - Selecione o arquivo `database.sql` e clique em **Executar**.
3. **Mova ou Aponte o Projeto:**
   - Coloque a pasta do projeto dentro de `C:\xampp\htdocs\` (ex: `C:\xampp\htdocs\pcpr-simulados`) ou crie um VirtualHost/Alias apontando para `e:\Projetos`.
4. **Acesse a Aplicação:**
   - Acesse no navegador: `http://localhost/pcpr-simulados/` ou `http://localhost/Projetos/`.

---

### Opção 2: Executando com Docker (1 Comando)

Se você possui o Docker Desktop instalado:

1. No terminal, na raiz do projeto (`e:\Projetos`), execute:
   ```bash
   docker compose up -d
   ```
2. O Docker irá subir os containers `pcpr_simulados_web` (porta 8080) e `pcpr_simulados_db` (porta 3306), importando automaticamente o arquivo `database.sql`.
3. Acesse a aplicação em:
   ```
   http://localhost:8080
   ```

---

### Opção 3: Executando com o Servidor Embutido do PHP

1. Certifique-se de que o MySQL local esteja em execução e com o script `database.sql` importado.
2. Inicie o servidor embutido do PHP no terminal:
   ```bash
   php -S 127.0.0.1:8000
   ```
3. Abra no navegador: `http://127.0.0.1:8000`.

---

## 📡 Documentação dos Endpoints da API RESTful

### 1. `GET api.php?action=gerar-prova`
- **Descrição:** Busca as disciplinas cadastradas e executa uma query `ORDER BY RAND() LIMIT :cota` para cada matéria, unindo tudo em um array de 100 questões embaralhadas e renumeradas de 1 a 100.
- **Resposta (200 OK):**
  ```json
  {
    "sucesso": true,
    "edital": "PC PR 2026 - Concurso Agente de Polícia e Papiloscopista",
    "banca": "FGV - Fundação Getulio Vargas",
    "total_questoes": 100,
    "duracao_segundos": 18000,
    "distribuicao": [
      { "disciplina": "Língua Portuguesa", "cota_esperada": 15, "questoes_obtidas": 15 },
      { "disciplina": "Raciocínio Lógico-Matemático", "cota_esperada": 10, "questoes_obtidas": 10 }
    ],
    "questoes": [
      {
        "id": 42,
        "numero": 1,
        "disciplina_id": 6,
        "disciplina_nome": "Direito Penal",
        "disciplina_tipo": "Especificos",
        "enunciado": "...",
        "alt_a": "...", "alt_b": "...", "alt_c": "...", "alt_d": "...", "alt_e": "..."
      }
    ]
  }
  ```

### 2. `POST api.php?action=salvar-resultado`
- **Descrição:** Recebe as respostas do usuário, valida o gabarito oficial contra o banco de dados, calcula acertos/erros globais e por matéria, gera diagnóstico inteligente e salva o resultado no histórico.
- **Corpo da Requisição (JSON):**
  ```json
  {
    "usuario_nome": "Candidato PC PR 2026",
    "tempo_gasto_segundos": 12450,
    "respostas": {
      "1": "B",
      "2": "C",
      "3": "A"
    }
  }
  ```
- **Resposta (201 Created):**
  ```json
  {
    "sucesso": true,
    "simulado_id": 1,
    "total_questoes": 100,
    "total_acertos": 78,
    "total_erros": 22,
    "percentual_acerto": 78.0,
    "tempo_formatado": "03h 27m 30s",
    "feedback_diagnostico": "Você foi muito bem em Direito Penal (86.7%), mas precisa concentrar mais estudos em Raciocínio Lógico-Matemático (40.0%).",
    "desempenho_disciplinas": [ ... ],
    "questoes_corrigidas": [ ... ]
  }
  ```

### 3. `GET api.php?action=historico`
- **Descrição:** Retorna a listagem dos últimos simulados realizados salvos no banco.

---

## ✨ Destaques de Usabilidade e UX do Frontend

1. **Cronômetro Regressivo de 5h Fixo:** Acompanha o candidato no topo, com alertas de cor quando o tempo está se esgotando.
2. **Matriz de Navegação 1-100:** Visualização em grade compacta mostrando instantaneamente quais questões estão Respondidas (Azul), Pendentes (Cinza) ou Marcadas para Revisão (Amarelo).
3. **Alternância de Visualização:** Suporte a "Modo Questão por Questão (Foco)" e "Modo Prova Completa (Scroll Contínuo de 100 questões)".
4. **Proteção Contra F5 (LocalStorage):** Se o usuário fechar a aba ou atualizar a página acidentalmente, o simulado é recuperado com as respostas e o tempo intactos.
5. **Tela de Resultados Completa:** Resumo visual, barras de aproveitamento por disciplina, diagnóstico em texto claro e filtro para revisar **apenas os erros** com os gabaritos fundamentados da FGV.
