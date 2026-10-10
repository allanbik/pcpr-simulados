#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Servidor Local de Teste e Demonstração Instantânea
Portal de Provas e Simulados PC PR 2026 (Banca FGV)
Permite testar 100% das funcionalidades da SPA sem depender de instalação prévia do XAMPP/MySQL.
"""

import http.server
import socketserver
import json
import re
import random
import os
import urllib.parse
from datetime import datetime

PORT = 8000
BASE_DIR = os.path.dirname(os.path.abspath(__file__))

DB_STATE = {
    "disciplinas": [
        {"id": 1, "nome": "Língua Portuguesa", "tipo": "Gerais", "peso_questoes": 15},
        {"id": 2, "nome": "Raciocínio Lógico-Matemático", "tipo": "Gerais", "peso_questoes": 10},
        {"id": 3, "nome": "Realidade do PR", "tipo": "Gerais", "peso_questoes": 10},
        {"id": 4, "nome": "Direito Administrativo", "tipo": "Especificos", "peso_questoes": 10},
        {"id": 5, "nome": "Direito Constitucional", "tipo": "Especificos", "peso_questoes": 10},
        {"id": 6, "nome": "Direito Penal", "tipo": "Especificos", "peso_questoes": 15},
        {"id": 7, "nome": "Direito Processual Penal", "tipo": "Especificos", "peso_questoes": 15},
        {"id": 8, "nome": "Legislação Penal Especial", "tipo": "Especificos", "peso_questoes": 15}
    ],
    "questoes": [],
    "historico": []
}

def parse_sql_tuples(text):
    """Extrai tuplas de questoes do SQL respeitando aspas e quebras de linha"""
    items = []
    i = 0
    n = len(text)
    
    while i < n:
        if text[i] == '(':
            start = i
            i += 1
            fields = []
            cur_field = []
            in_quote = False
            
            while i < n:
                ch = text[i]
                if ch == '\\' and i + 1 < n and text[i+1] == "'":
                    cur_field.append("'")
                    i += 1
                elif ch == "'" and not in_quote:
                    in_quote = True
                elif ch == "'" and in_quote:
                    if i + 1 < n and text[i+1] == "'":
                        cur_field.append("'")
                        i += 1
                    else:
                        in_quote = False
                elif ch == ',' and not in_quote:
                    fields.append("".join(cur_field).strip())
                    cur_field = []
                elif ch == ')' and not in_quote:
                    fields.append("".join(cur_field).strip())
                    i += 1
                    break
                else:
                    cur_field.append(ch)
                i += 1
                
            # Verifica se é uma tupla de 9 campos (disciplina_id + 7 textos + gabarito)
            if len(fields) == 9 and fields[0].isdigit():
                gab = fields[7].strip("'").strip().upper()
                if gab in ['A', 'B', 'C', 'D', 'E']:
                    items.append({
                        "disciplina_id": int(fields[0]),
                        "enunciado": fields[1],
                        "alt_a": fields[2],
                        "alt_b": fields[3],
                        "alt_c": fields[4],
                        "alt_d": fields[5],
                        "alt_e": fields[6],
                        "gabarito": gab,
                        "comentario": fields[8]
                    })
        else:
            i += 1
            
    return items

def carregar_questoes_sql(filepath):
    if not os.path.exists(filepath):
        return []
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except Exception:
        return []

    disc_map = {d["id"]: d for d in DB_STATE["disciplinas"]}
    raw_tuples = parse_sql_tuples(content)
    
    res = []
    q_id = len(DB_STATE["questoes"]) + 1
    
    for item in raw_tuples:
        d_id = item["disciplina_id"]
        d_info = disc_map.get(d_id, {"nome": "Conhecimentos Diversos", "tipo": "Gerais"})
        
        item["id"] = q_id
        item["disciplina_nome"] = d_info["nome"]
        item["disciplina_tipo"] = d_info["tipo"]
        res.append(item)
        q_id += 1
        
    return res

# Carrega base inicial
db_sql_path = os.path.join(BASE_DIR, "database.sql")
DB_STATE["questoes"] = carregar_questoes_sql(db_sql_path)
print(f"[*] Base inicial carregada: {len(DB_STATE['questoes'])} questoes disponiveis.")


class SimuladoHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', 'Content-Type, Authorization')
        super().end_headers()

    def do_OPTIONS(self):
        self.send_response(200)
        self.end_headers()

    def do_GET(self):
        parsed = urllib.parse.urlparse(self.path)
        query = urllib.parse.parse_qs(parsed.query)
        action = query.get('action', [''])[0]

        if parsed.path.endswith('api.php') or action:
            self.tratar_api(action, 'GET')
            return

        return super().do_GET()

    def do_POST(self):
        parsed = urllib.parse.urlparse(self.path)
        query = urllib.parse.parse_qs(parsed.query)
        action = query.get('action', [''])[0]

        if parsed.path.endswith('api.php') or action:
            self.tratar_api(action, 'POST')
            return

        self.send_error(404, "Rota nao encontrada")

    def tratar_api(self, action, method):
        if action == 'gerar-prova' and method == 'GET':
            self.api_gerar_prova()
        elif action == 'importar-apostilas':
            self.api_importar_apostilas()
        elif action == 'salvar-resultado' and method == 'POST':
            self.api_salvar_resultado()
        elif action == 'historico' and method == 'GET':
            self.api_historico()
        elif action == 'disciplinas' and method == 'GET':
            self.send_json(200, {"sucesso": True, "disciplinas": DB_STATE["disciplinas"]})
        else:
            self.send_json(200, {
                "nome": "API Test Server PC PR 2026",
                "versao": "1.0.0",
                "total_questoes_ativas": len(DB_STATE["questoes"])
            })

    def api_gerar_prova(self):
        todas_questoes = []
        distribuicao = []

        for d in DB_STATE["disciplinas"]:
            d_id = d["id"]
            cota = d["peso_questoes"]
            disponiveis = [q for q in DB_STATE["questoes"] if q["disciplina_id"] == d_id]

            if len(disponiveis) >= cota:
                sorteadas = random.sample(disponiveis, cota)
            else:
                sorteadas = disponiveis

            distribuicao.append({
                "disciplina_id": d_id,
                "disciplina": d["nome"],
                "tipo": d["tipo"],
                "cota_esperada": cota,
                "questoes_obtidas": len(sorteadas)
            })
            todas_questoes.extend(sorteadas)

        random.shuffle(todas_questoes)

        for idx, q in enumerate(todas_questoes):
            q_copia = dict(q)
            q_copia["numero"] = idx + 1
            todas_questoes[idx] = q_copia

        self.send_json(200, {
            "sucesso": True,
            "edital": "PC PR 2026 - Concurso Agente de Policia e Papiloscopista",
            "banca": "FGV - Fundacao Getulio Vargas",
            "total_questoes": len(todas_questoes),
            "duracao_segundos": 18000,
            "distribuicao": distribuicao,
            "questoes": todas_questoes
        })

    def api_importar_apostilas(self):
        sql_apostilas = os.path.join(BASE_DIR, "questoes_apostilas.sql")
        novas = carregar_questoes_sql(sql_apostilas)

        existentes_enunc = {q["enunciado"][:60] for q in DB_STATE["questoes"]}
        adicionadas = 0

        for n in novas:
            if n["enunciado"][:60] not in existentes_enunc:
                n["id"] = len(DB_STATE["questoes"]) + 1
                DB_STATE["questoes"].append(n)
                adicionadas += 1

        self.send_json(200, {
            "sucesso": True,
            "mensagem": f"{adicionadas} questoes das apostilas foram importadas com sucesso!",
            "importadas": adicionadas,
            "total_no_banco": len(DB_STATE["questoes"])
        })

    def api_salvar_resultado(self):
        content_len = int(self.headers.get('Content-Length', 0))
        post_data = self.rfile.read(content_len).decode('utf-8')
        try:
            body = json.loads(post_data)
        except Exception:
            self.send_json(400, {"sucesso": False, "erro": "JSON invalido"})
            return

        usuario_nome = body.get('usuario_nome', 'Candidato PC PR 2026')
        tempo_gasto = int(body.get('tempo_gasto_segundos', 0))
        respostas = body.get('respostas', {})

        map_questoes = {q["id"]: q for q in DB_STATE["questoes"]}

        total_questoes = len(respostas)
        total_acertos = 0
        total_erros = 0
        desempenho_disc = {}
        detalhes = []

        for qid_str, resp_user in respostas.items():
            qid = int(qid_str)
            q_info = map_questoes.get(qid)
            if not q_info:
                continue

            resp_user_norm = str(resp_user).strip().upper()
            gabarito = q_info["gabarito"].strip().upper()
            acertou = (resp_user_norm != "" and resp_user_norm == gabarito)

            if acertou:
                total_acertos += 1
            else:
                total_erros += 1

            d_nome = q_info["disciplina_nome"]
            if d_nome not in desempenho_disc:
                desempenho_disc[d_nome] = {
                    "disciplina": d_nome,
                    "tipo": q_info["disciplina_tipo"],
                    "total": 0,
                    "acertos": 0,
                    "erros": 0,
                    "percentual": 0.0
                }
            desempenho_disc[d_nome]["total"] += 1
            if acertou:
                desempenho_disc[d_nome]["acertos"] += 1
            else:
                desempenho_disc[d_nome]["erros"] += 1

            detalhes.append({
                "questao_id": qid,
                "disciplina": d_nome,
                "tipo": q_info["disciplina_tipo"],
                "enunciado": q_info["enunciado"],
                "alt_a": q_info["alt_a"],
                "alt_b": q_info["alt_b"],
                "alt_c": q_info["alt_c"],
                "alt_d": q_info["alt_d"],
                "alt_e": q_info["alt_e"],
                "resposta_usuario": resp_user_norm,
                "gabarito_oficial": gabarito,
                "acertou": acertou,
                "comentario": q_info["comentario"]
            })

        for d in desempenho_disc.values():
            if d["total"] > 0:
                d["percentual"] = round((d["acertos"] / d["total"]) * 100, 1)

        perc_global = round((total_acertos / max(1, total_questoes)) * 100, 2)

        boas = [f"{d['disciplina']} ({d['percentual']}%)" for d in desempenho_disc.values() if d["percentual"] >= 70]
        fracas = [f"{d['disciplina']} ({d['percentual']}%)" for d in desempenho_disc.values() if d["percentual"] < 60]

        diag = "Parabens pelo simulado realizado!"
        if boas and fracas:
            diag = f"Voce foi muito bem em {', '.join(boas)}, mas precisa reforcacar seus estudos em {', '.join(fracas)}."
        elif fracas:
            diag = f"Atencao aos pontos criticos: concentre suas revisoes em {', '.join(fracas)}."
        elif boas:
            diag = "Excelente retencao! Seu aproveitamento foi muito consistente em todas as disciplinas da PC PR."

        horas = tempo_gasto // 3600
        minutos = (tempo_gasto % 3600) // 60
        segundos = tempo_gasto % 60
        tempo_formatado = f"{horas:02d}h {minutos:02d}m {segundos:02d}s"

        simulado_id = len(DB_STATE["historico"]) + 1
        registro = {
            "id": simulado_id,
            "usuario_nome": usuario_nome,
            "total_questoes": total_questoes,
            "total_acertos": total_acertos,
            "total_erros": total_erros,
            "percentual_acerto": perc_global,
            "tempo_gasto_segundos": tempo_gasto,
            "tempo_formatado": tempo_formatado,
            "data_formatada": datetime.now().strftime("%d/%m/%Y %H:%M"),
            "desempenho_disciplinas": list(desempenho_disc.values())
        }
        DB_STATE["historico"].insert(0, registro)

        self.send_json(201, {
            "sucesso": True,
            "simulado_id": simulado_id,
            "usuario_nome": usuario_nome,
            "total_questoes": total_questoes,
            "total_acertos": total_acertos,
            "total_erros": total_erros,
            "percentual_acerto": perc_global,
            "tempo_gasto_segundos": tempo_gasto,
            "tempo_formatado": tempo_formatado,
            "feedback_diagnostico": diag,
            "desempenho_disciplinas": list(desempenho_disc.values()),
            "questoes_corrigidas": detalhes
        })

    def api_historico(self):
        self.send_json(200, {
            "sucesso": True,
            "historico": DB_STATE["historico"]
        })

    def send_json(self, status, payload):
        self.send_response(status)
        self.send_header('Content-Type', 'application/json; charset=utf-8')
        self.end_headers()
        self.wfile.write(json.dumps(payload, ensure_ascii=False, indent=2).encode('utf-8'))


if __name__ == '__main__':
    os.chdir(BASE_DIR)
    socketserver.TCPServer.allow_reuse_address = True
    with socketserver.TCPServer(("", PORT), SimuladoHandler) as httpd:
        print("=======================================================")
        print(f"PORTAL DE SIMULADOS PC PR 2026 INICIADO COM SUCESSO!")
        print(f"Acesse no navegador: http://localhost:{PORT}")
        print("=======================================================")
        httpd.serve_forever()
