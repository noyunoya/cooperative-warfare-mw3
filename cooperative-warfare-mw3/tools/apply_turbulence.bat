@echo off
title MW3 co-op patch v0.0.49h34
echo ==== MW3 co-op patch v0.0.49h34 - apply_turbulence.bat (Turbulence / hijack, airplane start) ====
setlocal
cd /d "%~dp0"
rem Put this folder inside your TeknoMW3 folder. Nothing else needed (no OAT rebuild).
set "ZONE=..\zone\english\hijack.ff"
if not exist "%ZONE%" (
  echo Cannot find %ZONE% - this folder must sit directly inside your TeknoMW3 folder.
  pause & exit /b 1
)
set "SRC=%ZONE%"
if exist "%ZONE%.orig" set "SRC=%ZONE%.orig"
echo Patching from: %SRC%
if not exist out mkdir out
python patch_zone.py "%SRC%" maps/hijack hj\hijack.cgsc hj\hijack.cgsc.stack out\hijack.ff --allow-grow
if errorlevel 1 (
  echo Patch failed. Send me the text above.
  pause & exit /b 1
)
set /p GO=Install now? Your original stays as hijack.ff.orig. Type Y: 
if /i "%GO%"=="Y" (
  if not exist "%ZONE%.orig" copy /y "%ZONE%" "%ZONE%.orig" >nul
  copy /y out\hijack.ff "%ZONE%" >nul
  echo Installed. To undo, copy hijack.ff.orig over hijack.ff.
)
pause
