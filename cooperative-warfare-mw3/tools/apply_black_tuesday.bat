@echo off
title MW3 co-op patch v0.0.49h34
echo ==== MW3 co-op patch v0.0.49h34 - apply_black_tuesday.bat ====
setlocal
cd /d "%~dp0"
rem Put the patch_kit17 folder inside your TeknoMW3 folder. Nothing else needed.
set "ZONE=..\zone\english\ny_manhattan.ff"
if not exist "%ZONE%" (
  echo Cannot find %ZONE% - this folder must sit directly inside your TeknoMW3 folder.
  pause & exit /b 1
)
set "SRC=%ZONE%"
if exist "%ZONE%.orig" set "SRC=%ZONE%.orig"
echo Patching from: %SRC%
if not exist out mkdir out
echo Patching two scripts in one pass (about a minute, uses less memory)...
python patch_zone_multi.py "%SRC%" out\ny_manhattan.ff 969 bt\969.cgsc bt\969.cgsc.stack maps/ny_manhattan_code_intro bt\code_intro.cgsc bt\code_intro.cgsc.stack
if errorlevel 1 (
  echo Patch failed. Send me the text above.
  pause & exit /b 1
)
set /p GO=Install now? Your original stays as ny_manhattan.ff.orig. Type Y: 
if /i "%GO%"=="Y" (
  if not exist "%ZONE%.orig" copy /y "%ZONE%" "%ZONE%.orig" >nul
  copy /y out\ny_manhattan.ff "%ZONE%" >nul
  echo Installed. To undo, copy ny_manhattan.ff.orig over ny_manhattan.ff.
)
pause
