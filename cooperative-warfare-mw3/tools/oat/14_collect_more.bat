@echo off
title MW3 co-op patch v0.0.49h16
echo ==== MW3 co-op patch v0.0.49h16 - 14_collect_more.bat ====
setlocal
cd /d "%~dp0"
rem Put in TeknoMW3\OAT windows\ (same folder as Unlinker.exe). Read-only. Run AFTER 13_dump_weapons.bat.
if not exist zone_dump\iw5\intro ( echo zone_dump\iw5\intro not found - run 11_dump_skeletons.bat first. & pause & exit /b 1 )
if exist more rd /s /q more
mkdir more
for /r zone_dump %%F in (*pmc_africa* *russian_military* *fullbody_price* *fullbody_nikolai* *body_doctor*) do copy /y "%%F" more\ >nul 2>&1
dir /b more > out\more_found.txt
powershell -NoProfile -Command "Compress-Archive -Force -Path more\*,out\more_found.txt,out\wdump_files.txt -DestinationPath more_results.zip"
echo DONE. Send me more_results.zip AND weapons_dump_results.zip.
pause
