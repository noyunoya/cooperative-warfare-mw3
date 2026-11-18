@echo off
title MW3 co-op patch v0.0.49h16
echo ==== MW3 co-op patch v0.0.49h16 - 16_dump_sas.bat ====
setlocal
cd /d "%~dp0"
rem Put in TeknoMW3\OAT windows\ (next to Unlinker.exe). Read-only: changes nothing in your game.
rem Needs london.ff in zone\english.
if not exist Unlinker.exe ( echo Unlinker.exe not found here. & pause & exit /b 1 )
set "GAME=%~dp0.."
set "ZONE=%GAME%\zone\english"
if not exist "%ZONE%\london.ff" ( echo london.ff not found in zone\english. & pause & exit /b 1 )
if not exist out mkdir out
if exist sasdump rd /s /q sasdump
mkdir sasdump
Unlinker.exe -v --include-assets xmodel -o "%~dp0sasdump\london" --search-path "%GAME%" "%ZONE%\london.ff" > out\log_sasdump.txt 2>&1
if exist sas rd /s /q sas
mkdir sas
for /r sasdump %%F in (*sas* *urban_assault*) do copy /y "%%F" sas\ >nul 2>&1
dir /b sas > out\sas_found.txt
powershell -NoProfile -Command "Compress-Archive -Force -Path sas\*,out\sas_found.txt,out\log_sasdump.txt -DestinationPath sas_dump_results.zip"
echo.
echo DONE. Send me sas_dump_results.zip (in this folder).
pause
