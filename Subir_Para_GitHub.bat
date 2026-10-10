@echo off
chcp 65001 > nul
title Publicar Projeto no GitHub - Simulados PC PR 2026
color 0B

echo ======================================================================
echo    🏛️  PORTAL DE PROVAS E SIMULADOS PC PR 2026 - BANCA FGV
echo                 Publicação Automática no GitHub
echo ======================================================================
echo.

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

echo [1/3] Verificando repositório Git local...
cd /d "E:\Projetos"
"%GIT_CMD%" status >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERRO] Repositório local não encontrado em E:\Projetos!
    pause
    exit /b 1
)
echo [OK] Repositório local validado e comit gravado.
echo.

echo ======================================================================
echo  PASSO NECESSÁRIO NO GITHUB:
echo  1. Acesse: https://github.com/new
echo  2. Nomeie o repositório (ex: pcpr-simulados)
echo  3. Deixe Marcado como 'Public' (para GitHub Pages gratuito)
echo  4. NÃO marque 'Add a README file'
echo  5. Clique no botão verde 'Create repository'
echo ======================================================================
echo.

set /p REPO_URL="Cole aqui o link do seu repositório no GitHub (ex: https://github.com/seu-usuario/pcpr-simulados.git): "

if "%REPO_URL%"=="" (
    echo [AVISO] Nenhuma URL informada. Operação cancelada.
    pause
    exit /b 1
)

echo.
echo [2/3] Vinculando repositório remoto 'origin'...
"%GIT_CMD%" remote remove origin >nul 2>nul
"%GIT_CMD%" remote add origin %REPO_URL%
"%GIT_CMD%" branch -M main

echo [3/3] Enviando arquivos para o GitHub (git push)...
"%GIT_CMD%" push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ======================================================================
    echo  🎉 SUCESSO! SEU CÓDIGO ESTÁ NO GITHUB!
    echo ======================================================================
    echo.
    echo Para ativar o site no ar (GitHub Pages):
    echo  1. Abra seu repositório no GitHub
    echo  2. Vá em 'Settings' (no menu superior)
    echo  3. Clique em 'Pages' (no menu lateral esquerdo)
    echo  4. Em 'Branch', selecione 'main' e pasta '/(root)' e clique em 'Save'
    echo  5. Seu portal estará no ar em poucos segundos!
    echo ======================================================================
) else (
    echo.
    echo [AVISO] Ocorreu uma pendência durante o envio.
    echo Se solicitou login/senha, use seu Personal Access Token do GitHub ou faça login via navegador.
)

echo.
pause
