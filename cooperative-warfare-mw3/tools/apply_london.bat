@echo off
title MW3 co-op patch v0.0.49h34
echo ==== MW3 co-op patch v0.0.49h34 - apply_london.bat ====
setlocal
cd /d "%~dp0"
rem Put this folder inside your TeknoMW3 folder. Needs the OAT patch-zone rebuild first (oat\12_build_patch_zone.bat then oat\7_install_patch_zone.bat) for the fixed SAS body.
set "ZONE=..\zone\english\london.ff"
if not exist "%ZONE%" (
  echo Cannot find %ZONE% - this folder must sit directly inside your TeknoMW3 folder.
  pause & exit /b 1
)
set "SRC=%ZONE%"
if exist "%ZONE%.orig" set "SRC=%ZONE%.orig"
echo Patching from: %SRC%
if not exist out mkdir out
python patch_zone_multi.py "%SRC%" out\london.ff maps/london lon\london.cgsc lon\london.cgsc.stack maps/london_uav lon\london_uav.cgsc lon\london_uav.cgsc.stack
if errorlevel 1 (
  echo Patch failed. Send me the text above.
  pause & exit /b 1
)
set /p GO=Install now? Your original stays as london.ff.orig. Type Y: 
if /i "%GO%"=="Y" (
  if not exist "%ZONE%.orig" copy /y "%ZONE%" "%ZONE%.orig" >nul
  copy /y out\london.ff "%ZONE%" >nul
  echo Installed. To undo, copy london.ff.orig over london.ff.
)
pause
