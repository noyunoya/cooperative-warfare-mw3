#!/usr/bin/env python3
"""
patch_zone_multi.py - replaces SEVERAL scripts in an MW3 (2011) .ff fastfile in ONE pass (low memory).

Usage:
    python patch_zone_multi.py <zone.ff> <out.ff> <asset1> <new1.cgsc> <new1.cgsc.stack> [<asset2> <new2.cgsc> <new2.cgsc.stack> ...]

Always uses "grow" mode (zone header sizes are raised), same as patch_zone.py --allow-grow.
The original zone is never modified.
"""
import hashlib, struct, sys, zlib, gc
from patch_zone import find_asset


def decompress_ff_ba(path):
    with open(path, "rb") as f:
        head = f.read(21)
        dc = zlib.decompressobj()
        out = bytearray()
        while True:
            chunk = f.read(1 << 22)
            if not chunk:
                break
            out += dc.decompress(chunk)
            if dc.eof:
                break
    if not dc.eof or dc.unused_data:
        raise SystemExit("this does not look like a single-stream MW3 fastfile")
    return head, out


def main():
    a = sys.argv[1:]
    if len(a) < 5 or (len(a) - 2) % 3:
        print(__doc__)
        return 1
    ff, outp = a[0], a[1]
    jobs = [(a[i], a[i + 1], a[i + 2]) for i in range(2, len(a), 3)]
    head, raw = decompress_ff_ba(ff)
    print("zone loaded: %d MB decompressed" % (len(raw) >> 20))
    hdr = list(struct.unpack("<11I", raw[:44]))
    for name, cg, st in jobs:
        start, s, comp, ln, bc = find_asset(raw, name)
        code = open(cg, "rb").read()
        stack = open(st, "rb").read()
        end = s + comp + bc
        print("%s: old stack len=%d bytecode=%d -> new stack len=%d bytecode=%d" % (name, ln, bc, len(stack), len(code)))
        zb = zlib.compress(stack, 9)
        new_asset = struct.pack("<6I", 0xFFFFFFFF, len(zb), len(stack), len(code), 0xFFFFFFFF, 0xFFFFFFFF) \
            + name.encode() + b"\x00" + zb + code
        delta = len(new_asset) - (end - start)
        pad = ((abs(delta) + 0xFFF) // 0x1000 + 1) * 0x1000
        raw[start:end] = new_asset
        hdr[1] += pad
        for i in range(2, 11):
            if hdr[i]:
                hdr[i] += pad
        print("  patched %s (size %+d, header raised by %d)" % (name, delta, pad))
    hdr[0] = len(raw) - 44
    raw[:44] = struct.pack("<11I", *hdr)
    for name, cg, st in jobs:
        find_asset(raw, name)
    want = hashlib.sha1(raw).hexdigest()
    print("compressing (about a minute)...")
    comp = zlib.compressobj(6)
    with open(outp, "wb") as f:
        f.write(head)
        mv = memoryview(raw)
        for i in range(0, len(raw), 1 << 22):
            f.write(comp.compress(mv[i:i + (1 << 22)]))
        f.write(comp.flush())
        mv.release()
    del raw
    gc.collect()
    print("verifying...")
    h = hashlib.sha1()
    dc = zlib.decompressobj()
    with open(outp, "rb") as f:
        f.read(21)
        while True:
            chunk = f.read(1 << 22)
            if not chunk:
                break
            h.update(dc.decompress(chunk))
            if dc.eof:
                break
    if h.hexdigest() != want:
        print("VERIFY FAILED - do not install this file")
        return 3
    print("wrote %s. Re-read check OK." % outp)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except MemoryError:
        print("OUT OF MEMORY - close other programs and run again, then tell Claude.")
        sys.exit(4)
