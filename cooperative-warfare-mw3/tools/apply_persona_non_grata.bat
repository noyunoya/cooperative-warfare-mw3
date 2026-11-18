@echo off
title MW3 co-op patch v0.0.49h34
echo ==== MW3 co-op patch v0.0.49h34 - apply_persona_non_grata.bat ====
setlocal
cd /d "%~dp0"
rem Put the patch_kit17 folder inside your TeknoMW3 folder. Nothing else needed.
set "ZONE=..\zone\english\intro.ff"
if not exist "%ZONE%" (
  echo Cannot find %ZONE% - this folder must sit directly inside your TeknoMW3 folder.
  pause & exit /b 1
)
set "SRC=%ZONE%"
if exist "%ZONE%.orig" set "SRC=%ZONE%.orig"
echo Patching from: %SRC%
if not exist out mkdir out
echo NOTE: needs the patch zone rebuilt first (oat\12_build_patch_zone.bat then oat\7_install_patch_zone.bat).
echo Patching two scripts in one pass (about a minute)...
python patch_zone_multi.py "%SRC%" out\intro.ff maps/intro pnc\intro.cgsc pnc\intro.cgsc.stack maps/intro_code pnc\intro_code.cgsc pnc\intro_code.cgsc.stack
if errorlevel 1 (
  echo Patch failed. Send me the text above.
  pause & exit /b 1
)
set /p GO=Install now? Your original stays as intro.ff.orig. Type Y: 
if /i "%GO%"=="Y" (
  if not exist "%ZONE%.orig" copy /y "%ZONE%" "%ZONE%.orig" >nul
  copy /y out\intro.ff "%ZONE%" >nul
  echo Installed. To undo, copy intro.ff.orig over intro.ff.
)
pause
