@echo off
chcp 65001 > nul
title Publicar Projeto no GitHub - Simulados PC PR 2026
color 0B

echo ======================================================================
echo    🏛️  PORTAL DE PROVAS E SIMULADOS PC PR 2026 - BANCA FGV
echo                 Publicação no GitHub (allanbik)
echo ======================================================================
echo.

set "PATH=%LOCALAPPDATA%\Programs\Git\cmd;%LOCALAPPDATA%\Programs\Git\gcm;%PATH%"

set "GIT_CMD=%LOCALAPPDATA%\Programs\Git\cmd\git.exe"
if not exist "%GIT_CMD%" (
    where git >nul 2>nul
    if %errorlevel% equ 0 (
        set "GIT_CMD=git"
    ) else (
        echo [ERRO] Git não encontrado!
        pause
        exit /b 1
    )
)

cd /d "E:\Projetos"
echo [1/3] Verificando repositório e arquivos...
"%GIT_CMD%" status >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] Repositório Git não encontrado em E:\Projetos!
    pause
    exit /b 1
)

set "REPO_URL=https://github.com/allanbik/pcpr-simulados.git"

echo [OK] Repositório local pronto para envio.
echo Repositório de Destino: %REPO_URL%
echo.

echo [2/3] Vinculando repositório remoto 'origin'...
"%GIT_CMD%" remote remove origin >nul 2>nul
"%GIT_CMD%" remote add origin %REPO_URL%
"%GIT_CMD%" branch -M main

echo [3/3] Enviando projeto para o GitHub (git push)...
echo.
echo OBS: Se o navegador abrir uma janela do GitHub, basta clicar em 'Sign in' / 'Authorize'.
echo.
"%GIT_CMD%" push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ======================================================================
    echo  🎉 SUCESSO! SEU CÓDIGO ESTÁ NO GITHUB COM SUCESSO!
    echo ======================================================================
    echo.
    echo 🌐 COMO ATIVAR O PORTAL NO AR (GITHUB PAGES):
    echo  1. Abra: https://github.com/allanbik/pcpr-simulados/settings/pages
    echo  2. Em 'Branch', selecione 'main' e a pasta '/(root)'
    echo  3. Clique no botão 'Save'
    echo.
    echo  Em 1 minuto o seu simulado estará disponível no link:
    echo  👉 https://allanbik.github.io/pcpr-simulados/
    echo ======================================================================
) else (
    echo.
    echo ======================================================================
    echo  [AVISO DE AUTENTICAÇÃO]
    echo  Caso tenha ocorrido erro de permissão ou autenticação:
    echo  1. Você pode usar um Personal Access Token (classic) gerado em:
    echo     https://github.com/settings/tokens
    echo  2. Ou adicionar a chave SSH gerada em:
    echo     https://github.com/settings/keys
    echo ======================================================================
)

echo.
pause
