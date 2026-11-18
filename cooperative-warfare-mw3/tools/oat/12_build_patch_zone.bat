@echo off
title MW3 co-op patch v0.0.49h16
echo ==== MW3 co-op patch v0.0.49h16 - 12_build_patch_zone.bat ====
setlocal
cd /d "%~dp0"
rem Put in the SAME folder as Linker.exe and zone_dump (the folder where 4c worked).
if not exist Linker.exe ( echo Linker.exe not found here. & pause & exit /b 1 )
if not exist zone_dump\iw5\patch\zone_source\patch.zone ( echo zone_dump\iw5\patch\zone_source\patch.zone missing - run step 1 again. & pause & exit /b 1 )
set "GAME=%~dp0.."
set "ZONE=%GAME%\zone\english"
set "SRC=%ZONE%\patch.ff"
if exist "%ZONE%\patch.ff.orig" set "SRC=%ZONE%\patch.ff.orig"
set "INTRO=%ZONE%\intro.ff"
if exist "%ZONE%\intro.ff.orig" set "INTRO=%ZONE%\intro.ff.orig"
set "NYM=%ZONE%\ny_manhattan.ff"
if exist "%ZONE%\ny_manhattan.ff.orig" set "NYM=%ZONE%\ny_manhattan.ff.orig"
set "LON=%ZONE%\london.ff"
if exist "%ZONE%\london.ff.orig" set "LON=%ZONE%\london.ff.orig"
if not exist "%LON%" ( echo london.ff not found in %ZONE% - copy it there first. & pause & exit /b 1 )
if not exist out mkdir out
if exist buildp rd /s /q buildp
mkdir buildp\zone_raw\patch\zone_source
mkdir buildp\load
copy /y "%SRC%" buildp\load\patch_src.ff >nul
copy /y zone_dump\iw5\patch\zone_source\patch.zone buildp\zone_raw\patch\zone_source\patch.zone >nul
>> buildp\zone_raw\patch\zone_source\patch.zone echo.
>> buildp\zone_raw\patch\zone_source\patch.zone echo // ---- added: co-op bodies, 2 players ----
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_body_delta
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_head_delta
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_body_us_army
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_head_us_army
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,mp_body_henchmen_assault_d
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,head_russianwoodland_a
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,mp_body_delta_elite_assault_bb
if not exist assets\xmodel\coop_body_loyalist_d.json ( echo assets folder missing - copy the whole oat folder contents. & pause & exit /b 1 )
robocopy assets buildp\zone_raw\patch /E /NFL /NDL /NJH /NJS >nul
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_body_loyalist_d
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_body_delta_aa
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_body_delta_smg_a
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,viewhands_sas
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,viewhands_player_sas
>> buildp\zone_raw\patch\zone_source\patch.zone echo xmodel,coop_body_sas_assault
if exist zone_dump\iw5\patch\english robocopy zone_dump\iw5\patch\english buildp\zone_raw\patch\english /E /NFL /NDL /NJH /NJS >nul
echo === linking patch (loads several big zones, give it a minute) ===
Linker.exe -v -b "%~dp0buildp" -l "%~dp0buildp\load\patch_src.ff" -l "%ZONE%\code_post_gfx.ff" -l "%ZONE%\common.ff" -l "%ZONE%\common_specialops.ff" -l "%ZONE%\so_nyse_ny_manhattan.ff" -l "%ZONE%\so_heliswitch_berlin.ff" -l "%ZONE%\so_milehigh_hijack.ff" -l "%INTRO%" -l "%NYM%" -l "%LON%" patch > out\log_link_patch5.txt 2>&1
echo.
if exist buildp\zone_out\patch\patch.ff (
  for %%A in (buildp\zone_out\patch\patch.ff) do echo BUILT patch.ff  %%~zA bytes
) else (
  echo Build failed.
)
echo Send me out\log_link_patch5.txt either way.
pause
