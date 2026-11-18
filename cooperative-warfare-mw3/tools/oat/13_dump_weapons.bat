@echo off
title MW3 co-op patch v0.0.49h16
echo ==== MW3 co-op patch v0.0.49h16 - 13_dump_weapons.bat ====
setlocal
cd /d "%~dp0"
rem Put in TeknoMW3\OAT windows\ (next to Unlinker.exe). Read-only: changes nothing in your game.
if not exist Unlinker.exe ( echo Unlinker.exe not found here. & pause & exit /b 1 )
set "GAME=%~dp0.."
set "ZONE=%GAME%\zone\english"
if not exist out mkdir out
if exist wdump rd /s /q wdump
mkdir wdump
for %%Z in (ny_manhattan so_nyse_ny_manhattan so_heliswitch_berlin intro) do (
  if exist "%ZONE%\%%Z.ff" (
    echo === weapons from %%Z ===
    Unlinker.exe -v --include-assets weapon -o "%~dp0wdump\%%Z" --search-path "%GAME%" "%ZONE%\%%Z.ff" > out\log_wdump_%%Z.txt 2>&1
  )
)
dir /s /b wdump > out\wdump_files.txt
powershell -NoProfile -Command "Compress-Archive -Force -Path wdump\*,out\log_wdump_*.txt,out\wdump_files.txt -DestinationPath weapons_dump_results.zip"
echo.
echo DONE. Send me weapons_dump_results.zip (in this folder).
pause
