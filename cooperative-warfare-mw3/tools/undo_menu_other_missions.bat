@echo off
title MW3 co-op patch v0.0.49h34
echo ==== MW3 co-op patch v0.0.49h34 - undo_menu_other_missions.bat ====
echo Puts the original zone files back for the missions the checkpoint-menu tool (h32) patched. The menu crashed the game, so it is removed.
setlocal EnableDelayedExpansion
cd /d "%~dp0"
set "ZD=..\zone\english"
if not exist "%ZD%" ( echo Cannot find %ZD% - this folder must sit directly inside your TeknoMW3 folder. & pause & exit /b 1 )
set N=0
for %%Z in (berlin castle dubai hamburg ny_harbor paris_a paris_b payback prague prague_escape rescue_2 warlord paris_ac130 patch_hamburg patch_paris_ac130 patch_prague_escape patch_sp_berlin patch_sp_ny_harbor patch_sp_payback patch_sp_warlord patch_sp_ny_manhattan patch_sp_intro) do (
  if exist "%ZD%\%%Z.ff.orig" (
    copy /y "%ZD%\%%Z.ff.orig" "%ZD%\%%Z.ff" >nul
    echo restored %%Z.ff
    set /a N+=1
  )
)
echo Done: !N! files restored.
pause
