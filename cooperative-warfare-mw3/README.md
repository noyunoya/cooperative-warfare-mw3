# Cooperative Warfare - MW3 SP co-op (TeknoMW3 iw5sp)

Tooling for local 2-player co-op in the MW3 campaign (London, Innocent, Black Tuesday, Persona Non Grata, Turbulence). 

**No game data or game scripts are in this repo.** The tools patch your own installed zones and keep the originals as `.orig`.

- `tools/` - zone patchers (`patch_zone.py`, `patch_zone_multi.py`), the `apply_*.bat` wrappers, and `oat/` (patch.ff build + body retarget scripts). `READ_ME.txt` / `VERSION.txt` are the version notes for the latest kit.
- `mission_scripts/` - OUR co-op functions per level (`*_coop.gsc`) and `INSERTION_POINTS.md` (where the game's own functions call them).

## Status / what is not here yet
The compiled mission scripts in the release kits were built by decompiling the original level script with gsc-tool, adding our functions and the calls listed in `INSERTION_POINTS.md`, and recompiling. A one-click "apply to your own game" tool for that step does not exist yet, so for now the kits (which embed the modified scripts) are distributed privately and this repo documents the method and holds our code.

Licence for our own code: MIT (see LICENSE). Game data and third-party software are not covered; see THIRD_PARTY.md.
