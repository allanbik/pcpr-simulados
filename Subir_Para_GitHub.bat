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
echo [1/4] Verificando repositório e arquivos...
"%GIT_CMD%" status >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] Repositório Git não encontrado em E:\Projetos!
    pause
    exit /b 1
)

set "REPO_URL=https://github.com/allanbik/pcpr-simulados.git"

echo [OK] Repositório local pronto.
echo Repositório de Destino: %REPO_URL%
echo.

echo [2/4] Gravando alterações locais (git add e commit)...
"%GIT_CMD%" add .
"%GIT_CMD%" commit -m "feat: controle de acesso por e-mail, exportacao de leads e correcao de questoes no GitHub Pages" >nul 2>nul
echo [OK] Modificações locais salvas com sucesso.
echo.

echo [3/4] Vinculando repositório remoto 'origin'...
"%GIT_CMD%" remote remove origin >nul 2>nul
"%GIT_CMD%" remote add origin %REPO_URL%
"%GIT_CMD%" branch -M main

echo [4/4] Enviando projeto para o GitHub (git push)...
echo.
echo OBS: Se o navegador abrir uma janela do GitHub, basta clicar em 'Sign in' / 'Authorize'.
echo.
"%GIT_CMD%" push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ======================================================================
    echo  🎉 SUCESSO! SEU CÓDIGO ESTÁ ATUALIZADO NO GITHUB!
    echo ======================================================================
    echo.
    echo  O GitHub Pages atualizará o seu site automaticamente em cerca de 30s:
    echo  👉 https://allanbik.github.io/pcpr-simulados/
    echo ======================================================================
) else (
    echo.
    echo ======================================================================
    echo  [AVISO DE AUTENTICAÇÃO]
    echo  Caso tenha ocorrido erro de envio:
    echo  1. Verifique sua conexão com a internet.
    echo  2. Certifique-se de que sua conta está autorizada no GitHub.
    echo ======================================================================
)

echo.
pause
