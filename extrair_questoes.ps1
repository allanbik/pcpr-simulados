# ==============================================================================
# SCRIPT EXTRATOR DE QUESTOES DAS APOSTILAS (DOCX -> SQL) - VERSAO PROFISSA
# Extração refinada com separação inteligente de Enunciado e Alternativas A a E
# ==============================================================================

Add-Type -AssemblyName System.IO.Compression.FileSystem

$baseDir = "E:\Aulas PC\Apostilas Finalizadas"
$outputSql = "E:\Projetos\questoes_apostilas.sql"

function Escape-Sql($str) {
    if ([string]::IsNullOrEmpty($str)) { return "" }
    return $str.Replace("'", "''").Replace("\", "\\").Trim()
}

function Is-CommandLine($s) {
    return ($s -match '^\s*(Assinale|Marque|Considerando|Julgue|Com base|A partir|Tendo em vista|Diante|Nesse sentido|Sobre|Quanto|Em rela[çc][ãa]o)\b.*(alternativa|op[çc][ãa]o|afirmativa|corret|incorret|abaixo|a seguir|assertiva)')
}

$extractedQuestions = @()
$subDirs = Get-ChildItem -Path $baseDir -Directory

foreach ($dir in $subDirs) {
    $dirName = $dir.Name
    $discId = 0
    $discNome = ""
    
    if ($dirName -match "Port") {
        $discId = 1
        $discNome = "Língua Portuguesa"
    } elseif ($dirName -match "RLM|L[oó]gic") {
        $discId = 2
        $discNome = "Raciocínio Lógico-Matemático"
    } elseif ($dirName -match "Constit") {
        $discId = 5
        $discNome = "Direito Constitucional"
    } elseif ($dirName -match "Process") {
        $discId = 7
        $discNome = "Direito Processual Penal"
    } elseif ($dirName -match "Penal") {
        $discId = 6
        $discNome = "Direito Penal"
    } else {
        continue
    }
    
    $docxFiles = Get-ChildItem -Path $dir.FullName -Recurse -Filter "*.docx"
    Write-Output "Extraindo de $($discNome)..."
    
    foreach ($file in $docxFiles) {
        try {
            $zip = [System.IO.Compression.ZipFile]::OpenRead($file.FullName)
            $entry = $zip.GetEntry("word/document.xml")
            if (-not $entry) { $zip.Dispose(); continue }
            
            $reader = New-Object System.IO.StreamReader($entry.Open())
            $xml = $reader.ReadToEnd()
            $reader.Close()
            $zip.Dispose()
            
            $text = $xml -replace '</w:p>', "`n"
            $text = $text -replace '<[^>]+>', ''
            $text = [System.Net.WebUtility]::HtmlDecode($text)
            $lines = $text -split "`n" | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
            
            # Localiza a secao Gabarito
            $gabIdx = -1
            for ($i = 0; $i -lt $lines.Count; $i++) {
                if ($lines[$i] -match "^\s*Gabarito\s*:?") {
                    $gabIdx = $i
                    break
                }
            }
            if ($gabIdx -lt 0) { continue }
            
            # Extrai os gabaritos oficiais listados ao final da apostila
            $gabaritos = @()
            for ($k = $gabIdx + 1; $k -lt $lines.Count; $k++) {
                $item = $lines[$k]
                if ($item -match '^([A-E])$') {
                    $gabaritos += $Matches[1].ToUpper()
                } elseif ($item -match '^\d+[\s\.\-]+([A-E])$') {
                    $gabaritos += $Matches[1].ToUpper()
                } elseif ($item -match '^CERTO$') {
                    $gabaritos += "A"
                } elseif ($item -match '^ERRADO$') {
                    $gabaritos += "B"
                }
            }
            if ($gabaritos.Count -eq 0) { continue }
            
            # Localiza inicio dos exercicios
            $startIdx = -1
            for ($i = 0; $i -lt $gabIdx; $i++) {
                if ($lines[$i] -match "Hora de Praticar|Exerc[ií]cios|QUEST[ÕO]ES DE CONCURSO") {
                    $startIdx = $i
                    break
                }
            }
            if ($startIdx -lt 0) {
                $startIdx = [Math]::Max(0, $gabIdx - ($gabaritos.Count * 12))
            }
            
            # Divide os blocos por linha divisoria
            $blocks = @()
            $cur = @()
            for ($i = $startIdx; $i -lt $gabIdx; $i++) {
                $l = $lines[$i]
                if ($l -match '^_{5,}') {
                    if ($cur.Count -gt 0) {
                        $blocks += ,$cur
                        $cur = @()
                    }
                } else {
                    if ($l -notmatch '^[-0-9]{8,}') {
                        $cur += $l
                    }
                }
            }
            if ($cur.Count -gt 0) {
                $blocks += ,$cur
            }
            
            # Associa blocos aos gabaritos
            $count = [Math]::Min($gabaritos.Count, $blocks.Count)
            for ($q = 0; $q -lt $count; $q++) {
                $blk = $blocks[$q]
                $gab = $gabaritos[$q]
                
                if ($blk.Count -ge 3) {
                    $enunciado = ""
                    $altA = ""
                    $altB = ""
                    $altC = ""
                    $altD = ""
                    $altE = ""
                    
                    $penultima = $blk[$blk.Count - 2]
                    $ultima    = $blk[$blk.Count - 1]
                    
                    if ($penultima -match "Certo" -and $ultima -match "Errad") {
                        # Modelo Certo / Errado (Cebraspe)
                        $enunciado = ($blk[0..($blk.Count - 3)] -join "`n")
                        $altA = "( ) Certo"
                        $altB = "( ) Errado"
                        $altC = "Não se aplica"
                        $altD = "Não se aplica"
                        $altE = "Não se aplica"
                    } elseif ($blk.Count -ge 5) {
                        # Analisa se são 4 ou 5 alternativas
                        $linhaCincoAtras = if ($blk.Count -ge 6) { $blk[$blk.Count - 5] } else { "" }
                        
                        if ($blk.Count -ge 6 -and (-not (Is-CommandLine $linhaCincoAtras))) {
                            # 5 alternativas (A, B, C, D, E)
                            $altE = $blk[$blk.Count - 1]
                            $altD = $blk[$blk.Count - 2]
                            $altC = $blk[$blk.Count - 3]
                            $altB = $blk[$blk.Count - 4]
                            $altA = $blk[$blk.Count - 5]
                            $enunciado = ($blk[0..($blk.Count - 6)] -join "`n")
                        } else {
                            # 4 alternativas (A, B, C, D) onde a linha anterior é comando
                            $altD = $blk[$blk.Count - 1]
                            $altC = $blk[$blk.Count - 2]
                            $altB = $blk[$blk.Count - 3]
                            $altA = $blk[$blk.Count - 4]
                            $altE = "Nenhuma das anteriores (N.D.A.)"
                            $enunciado = ($blk[0..($blk.Count - 5)] -join "`n")
                        }
                    } else {
                        continue
                    }
                    
                    # Remove prefixos como (A), A), A -
                    $altA = $altA -replace '^\([A-E]\)\s*', '' -replace '^[A-E]\)\s*', '' -replace '^[A-E]\s*-\s*', ''
                    $altB = $altB -replace '^\([A-E]\)\s*', '' -replace '^[A-E]\)\s*', '' -replace '^[A-E]\s*-\s*', ''
                    $altC = $altC -replace '^\([A-E]\)\s*', '' -replace '^[A-E]\)\s*', '' -replace '^[A-E]\s*-\s*', ''
                    $altD = $altD -replace '^\([A-E]\)\s*', '' -replace '^[A-E]\)\s*', '' -replace '^[A-E]\s*-\s*', ''
                    $altE = $altE -replace '^\([A-E]\)\s*', '' -replace '^[A-E]\)\s*', '' -replace '^[A-E]\s*-\s*', ''
                    
                    $aulaNome = $file.BaseName.Replace("OK - ", "").Replace("Apostila Resumida - ", "").Trim()
                    $comentario = "Questão oficial de concurso extraída da apostila da Polícia Civil do Paraná (PCPR): $aulaNome. Gabarito Oficial: Alternativa $gab."
                    
                    $extractedQuestions += [PSCustomObject]@{
                        disciplina_id   = $discId
                        disciplina_nome = $discNome
                        enunciado       = $enunciado
                        alt_a           = $altA
                        alt_b           = $altB
                        alt_c           = $altC
                        alt_d           = $altD
                        alt_e           = $altE
                        gabarito        = $gab
                        comentario      = $comentario
                        origem          = $file.Name
                    }
                }
            }
        } catch {
            Write-Warning "Erro ao processar $($file.Name): $_"
        }
    }
}

Write-Output "`n======================================================="
Write-Output "Total de questoes extraidas com sucesso: $($extractedQuestions.Count)"
Write-Output "======================================================="

$byDisc = $extractedQuestions | Group-Object disciplina_nome
foreach ($g in $byDisc) {
    Write-Output "- $($g.Name): $($g.Count) questoes"
}

$sqlLines = @()
$sqlLines += "-- =============================================================================="
$sqlLines += "-- QUESTOES EXTRAIDAS DAS APOSTILAS DA PC PR (BANCA FGV / CONCURSOS)"
$sqlLines += "-- Total de questoes: $($extractedQuestions.Count)"
$sqlLines += "-- =============================================================================="
$sqlLines += "USE pcpr_simulados;"
$sqlLines += ""

foreach ($q in $extractedQuestions) {
    $eEnunc = Escape-Sql $q.enunciado
    $eA     = Escape-Sql $q.alt_a
    $eB     = Escape-Sql $q.alt_b
    $eC     = Escape-Sql $q.alt_c
    $eD     = Escape-Sql $q.alt_d
    $eE     = Escape-Sql $q.alt_e
    $eGab   = Escape-Sql $q.gabarito
    $eCom   = Escape-Sql $q.comentario
    
    $sqlLines += "INSERT INTO questoes (disciplina_id, enunciado, alt_a, alt_b, alt_c, alt_d, alt_e, gabarito, comentario) VALUES ($($q.disciplina_id), '$eEnunc', '$eA', '$eB', '$eC', '$eD', '$eE', '$eGab', '$eCom');"
}

[System.IO.File]::WriteAllLines($outputSql, $sqlLines, [System.Text.Encoding]::UTF8)
Write-Output "`nArquivo SQL atualizado com sucesso em: $outputSql"
