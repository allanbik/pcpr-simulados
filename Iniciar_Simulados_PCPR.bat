@echo off
title Portal de Simulados PC PR 2026 - Banca FGV
cd /d "E:\Projetos"

echo ========================================================
echo   PORTAL DE PROVAS E SIMULADOS - PC PR 2026 (FGV)
echo ========================================================
echo.
echo Iniciando servidor local...
echo.

start "" "http://localhost:8000"
python server.py

pause
