@echo off
title MW3 co-op patch v0.0.49h34
echo ==== MW3 co-op patch v0.0.49h34 - apply_innocent.bat ====
setlocal
cd /d "%~dp0"
rem Innocent has TWO zones holding maps/innocent: innocent.ff and patch_innocent.ff (the second one overrides the first). Both get patched.
set "Z1=..\zone\english\innocent.ff"
set "Z2=..\zone\english\patch_innocent.ff"
if not exist "%Z1%" (
  echo Cannot find %Z1% - this folder must sit directly inside your TeknoMW3 folder.
  pause & exit /b 1
)
set "S1=%Z1%"
if exist "%Z1%.orig" set "S1=%Z1%.orig"
set "S2=%Z2%"
if exist "%Z2%.orig" set "S2=%Z2%.orig"
if not exist out mkdir out
python patch_zone.py "%S1%" maps/innocent inn\innocent.cgsc inn\innocent.cgsc.stack out\innocent.ff --allow-grow
if errorlevel 1 ( echo Patch failed. Send me the text above. & pause & exit /b 1 )
python patch_zone.py "%S2%" maps/innocent inn\innocent.cgsc inn\innocent.cgsc.stack out\patch_innocent.ff --allow-grow
if errorlevel 1 ( echo Patch 2 failed. Send me the text above. & pause & exit /b 1 )
set /p GO=Install now? Originals stay as .orig. Type Y: 
if /i "%GO%"=="Y" (
  if not exist "%Z1%.orig" copy /y "%Z1%" "%Z1%.orig" >nul
  if not exist "%Z2%.orig" copy /y "%Z2%" "%Z2%.orig" >nul
  copy /y out\innocent.ff "%Z1%" >nul
  copy /y out\patch_innocent.ff "%Z2%" >nul
  echo Installed v0.0.49h34. To undo, copy the .orig files back over innocent.ff and patch_innocent.ff.
)
pause
