v0.0.49h34: NUMPAD CHECKPOINT MENU in every mission: press Numpad 0 to open the list of this level checkpoints, then Numpad 1-9 to jump (a number with no checkpoint does nothing), Numpad 0 again closes. Everything else = h28. No OAT rebuild needed.

v0.0.49h28: everything from h27 plus the retargeted bodies. REQUIRED once: oat\12_build_patch_zone.bat then oat\7_install_patch_zone.bat (the body fix lives in patch.ff, not in the apply_*.bat files). Then run the apply_*.bat for each mission.

v0.0.49h27: Persona Non Grata P2 seat is searched beside P1 with wall clearance, camera pitch 14, base raised 16 units; Turbulence/Innocent place P2 on a clear spot (not inside props). No OAT rebuild needed.

v0.0.49h26: London FLIR HUD hidden for everyone (the engine shows it on both screens); Black Tuesday P2 seat shift 36 on the node right vector + 18s keep-beside guard; Innocent starts without the loadout signal. oat\ is the same as h24 - rebuild patch.ff only if you have not yet.

v0.0.49h24: SAS/Delta/Loyalist bodies are rebound to the Army skeleton (oat\retarget.py). REBUILD patch.ff: oat\12_build_patch_zone.bat then oat\7_install_patch_zone.bat, then apply_london.bat etc. London P2 is the SAS body again.

v0.0.49h23 - all missions rebuilt on the latest scripts. Put this folder inside TeknoMW3. Each apply_*.bat patches one mission (original kept as .orig).
Only needed once: oat\12_build_patch_zone.bat then oat\7_install_patch_zone.bat (patch.ff, no MP5).
apply_london.bat | apply_innocent.bat | apply_black_tuesday.bat | apply_persona_non_grata.bat | apply_turbulence.bat
Changes: London P2 uses Army body; Innocent together-HUD now appears after load; Black Tuesday has no showtoplayer/playerphysicstrace (crash suspect); Turbulence bodies are coop_body_loyalist_d (bent spine / no anims fix attempt).

h30: Innocent fix. patch_innocent.ff carries its own copy of maps/innocent that overrides innocent.ff, so earlier Innocent patches never ran. apply_innocent.bat now patches both. Other missions unchanged (only version strings).

h31: checkpoint menu now opens with F9 (or numpad 0) and picks with number row 1-9 (or numpad). Digits 1-9 also switch weapons while the menu is open.

h34: the checkpoint menu is removed from every mission (it crashed Innocent after ~4 s and London on load). undo_menu_other_missions.bat restores the zones the h32 menu tool patched. Innocent: P1 now uses the Army body (like London), P2 is only held in place for the first 6 s.
