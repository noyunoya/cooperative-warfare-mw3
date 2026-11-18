@echo off
title MW3 co-op patch v0.0.49h16
echo ==== MW3 co-op patch v0.0.49h16 - 7_install_patch_zone.bat ====
setlocal
cd /d "%~dp0"
set "ZONE=%~dp0..\zone\english"
if not exist buildp\zone_out\patch\patch.ff ( echo Build it first with 6_build_patch_zone.bat & pause & exit /b 1 )
if not exist "%ZONE%\patch.ff.orig" copy /y "%ZONE%\patch.ff" "%ZONE%\patch.ff.orig" >nul
attrib -r "%ZONE%\patch.ff" >nul 2>&1
copy /y buildp\zone_out\patch\patch.ff "%ZONE%\patch.ff" >nul
echo Installed. Original saved as patch.ff.orig
echo To undo: copy patch.ff.orig over patch.ff  (patch.ff is used by the whole game, so keep the .orig!)
pause
