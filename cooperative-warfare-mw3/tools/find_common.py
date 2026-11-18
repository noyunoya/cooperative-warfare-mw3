#!/usr/bin/env python3
"""
find_common.py - hunts the SHARED scripts (maps/_utility, maps/_load, common_scripts/...,
animscripts/utility, and so on) in a MW3 (2011) game folder, extracts them, and (optionally)
decompiles them with gsc-tool.

Reads your game files only; never changes them.

Usage (Windows terminal, in the folder holding this file):
    python find_common.py "C:\\Program Files (x86)\\Steam\\steamapps\\common\\Call of Duty Modern Warfare 3"

  - It scans the folder and all subfolders for .ff files.
  - If gsc-tool.exe is next to this script it also decompiles what it found.
  - Numeric-named scripts (shared libraries stored under an id) are included for the core zones
    (code_*, common*, ui, patch*).
  - Options:  --all          extract every script, not only the shared ones
              --no-decompile skip gsc-tool even if it is present

Output: common_result.zip next to this script (small). Upload that zip.
"""
import os, re, shutil, struct, subprocess, sys, zipfile, zlib

HERE = os.path.dirname(os.path.abspath(__file__))
OUT_ZIP = os.path.join(HERE, "common_result.zip")
WORK = os.path.join(HERE, "common_work")
FF = 0xFFFFFFFF
NAME = re.compile(rb"([A-Za-z0-9_\-/\.]{3,100})\x00x[\x01\x5e\x9c\xda]")

CORE = re.compile(r"^(code_|common|ui$|patch$|patch_specialops|patch_survival|specialops|sp_common|shared)", re.I)

# what counts as "shared"
SHARED = re.compile(
    r"^(maps/_|common_scripts/|codescripts/|character/|maps/ss_util|maps/.*_util|"
    r"animscripts/(?!traverse/)|vehicles/)")


def decompress_ff(data):
    if data[:8] != b"IWffu100":
        return None
    dc = zlib.decompressobj()
    out, pos = [], 21
    try:
        while pos < len(data):
            out.append(dc.decompress(data[pos:pos + (1 << 24)]))
            pos += 1 << 24
            if dc.eof:
                break
    except zlib.error:
        pass
    return b"".join(out)


def scriptfiles(raw):
    for m in NAME.finditer(raw):
        i = m.start()
        if i < 24:
            continue
        p0, comp, ln, bc, p1, p2 = struct.unpack("<6I", raw[i - 24:i])
        if (p0, p1, p2) != (FF, FF, FF) or not (0 < comp <= ln and 0 < bc <= ln):
            continue
        start = m.end() - 2
        try:
            stack = zlib.decompress(raw[start:start + comp])
        except zlib.error:
            continue
        if len(stack) != ln:
            continue
        code = raw[start + comp:start + comp + bc]
        if len(code) != bc:
            continue
        yield m.group(1).decode(), stack, code


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    flags = {a for a in sys.argv[1:] if a.startswith("--")}
    if not args:
        print(__doc__)
        return 1
    ffs = []
    for a in args:
        if os.path.isfile(a):
            ffs.append(a)
        else:
            for root, _, names in os.walk(a):
                ffs += [os.path.join(root, n) for n in names if n.lower().endswith(".ff")]
    ffs.sort()
    print("found %d .ff files" % len(ffs))

    shutil.rmtree(WORK, ignore_errors=True)
    os.makedirs(WORK)
    report = []
    extracted = []  # (zone, name, cgsc path)
    for f in ffs:
        raw = None
        try:
            raw = decompress_ff(open(f, "rb").read())
        except OSError as e:
            print("skip", f, e)
        if raw is None:
            continue
        zone = os.path.splitext(os.path.basename(f))[0]
        named = []
        for name, stack, code in scriptfiles(raw):
            hashed = name.isdigit()  # some shared libraries (e.g. maps/_introscreen) are stored under a numeric id
            if hashed and not (CORE.match(zone) or "--all" in flags):
                continue
            named.append(("#" + name if hashed else name, len(code)))
            if "--all" in flags or hashed or SHARED.match(name):
                base = os.path.join(WORK, "scripts", zone, "_hashed" if hashed else "", name)
                os.makedirs(os.path.dirname(base), exist_ok=True)
                open(base + ".cgsc", "wb").write(code)
                open(base + ".cgsc.stack", "wb").write(stack)
                extracted.append((zone, name, base + ".cgsc"))
        shared_n = sum(1 for n, _ in named if SHARED.match(n) or n.startswith("#"))
        print("%-42s %4d named scripts, %3d shared" % (os.path.relpath(f, args[0]) if os.path.isdir(args[0]) else f, len(named), shared_n))
        report.append("== %s  (%d named, %d shared)" % (f, len(named), shared_n))
        for n, sz in sorted(named):
            report.append("   %s%s  [%d bytes]" % ("* " if (SHARED.match(n) or n.startswith("#")) else "  ", n, sz))
    open(os.path.join(WORK, "report.txt"), "w", encoding="utf-8").write("\n".join(report))
    print("\nextracted %d scripts" % len(extracted))

    # optional decompile
    tool = os.path.join(HERE, "gsc-tool.exe")
    log = []
    done = 0
    if os.path.isfile(tool) and "--no-decompile" not in flags and extracted:
        print("gsc-tool.exe found: decompiling (this can take a minute)...")
        outdir = os.path.join(WORK, "decompiled")
        for zone, name, cgsc in extracted:
            before = set()
            for r, _, fs in os.walk(WORK):
                before.update(os.path.join(r, x) for x in fs if x.endswith(".gsc"))
            try:
                p = subprocess.run([tool, "-m", "decomp", "-g", "iw5", "-s", "pc", "-z", cgsc],
                                   cwd=WORK, capture_output=True, text=True, timeout=120)
                log.append("%s/%s: %s %s" % (zone, name, p.stdout.strip()[-200:], p.stderr.strip()[-200:]))
            except Exception as e:
                log.append("%s/%s: ERROR %s" % (zone, name, e))
                continue
            new = []
            for r, _, fs in os.walk(WORK):
                for x in fs:
                    pth = os.path.join(r, x)
                    if x.endswith(".gsc") and pth not in before:
                        new.append(pth)
            for pth in new[:1]:
                dst = os.path.join(outdir, zone, name + ".gsc")
                os.makedirs(os.path.dirname(dst), exist_ok=True)
                shutil.move(pth, dst)
                done += 1
            for pth in new[1:]:
                os.remove(pth)
        print("decompiled %d of %d" % (done, len(extracted)))
        open(os.path.join(WORK, "decompile_log.txt"), "w", encoding="utf-8").write("\n".join(log))
    else:
        print("(gsc-tool.exe not next to this script, so not decompiling; the raw files are in the zip)")

    with zipfile.ZipFile(OUT_ZIP, "w", zipfile.ZIP_DEFLATED) as z:
        for r, _, fs in os.walk(WORK):
            for x in fs:
                p = os.path.join(r, x)
                z.write(p, os.path.relpath(p, WORK))
    print("\nWrote %s (%d KB). Upload that file." % (OUT_ZIP, os.path.getsize(OUT_ZIP) // 1024))
    return 0


if __name__ == "__main__":
    sys.exit(main())
