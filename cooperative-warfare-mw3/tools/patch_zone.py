#!/usr/bin/env python3
"""
patch_zone.py - replaces ONE script (scriptfile asset) inside an MW3 (2011) .ff fastfile.

Usage:
    python patch_zone.py <zone.ff> <asset name> <new.cgsc> <new.cgsc.stack> <out.ff>

  zone.ff        the original fastfile (never modified; a new file is written to <out.ff>)
  asset name     the script's name inside the zone, e.g. 969
  new.cgsc       compiled bytecode from gsc-tool (zonetool mode)
  new.cgsc.stack the matching string/stack buffer from gsc-tool

Preferred ("exact fit") mode: the new data is padded to EXACTLY the old sizes, so nothing else in the
zone moves and no zone header value changes. If the new script is bigger than the old one, it falls
back to "grow" mode (zone header sizes are raised) and prints a warning.
"""
import re, struct, sys, zlib


def decompress_ff(data):
    dc = zlib.decompressobj()
    out, pos = [], 21
    while pos < len(data):
        out.append(dc.decompress(data[pos:pos + (1 << 24)]))
        pos += 1 << 24
        if dc.eof:
            break
    if not dc.eof or dc.unused_data:
        raise SystemExit("this does not look like a single-stream MW3 fastfile")
    return b"".join(out)


def find_asset(raw, name):
    pat = re.compile(rb"\xff\xff\xff\xff(.{4})(.{4})(.{4})\xff\xff\xff\xff\xff\xff\xff\xff"
                     + re.escape(name.encode()) + rb"\x00", re.S)
    hits = []
    for m in pat.finditer(raw):
        comp, ln, bc = struct.unpack("<3I", m.group(1) + m.group(2) + m.group(3))
        s = m.end()
        try:
            stack = zlib.decompress(raw[s:s + comp])
        except zlib.error:
            continue
        if len(stack) != ln:
            continue
        if s + comp + bc != len(raw) and raw[s + comp + bc:s + comp + bc + 4] != b"\xff\xff\xff\xff":
            continue
        hits.append((m.start(), s, comp, ln, bc))
    if len(hits) != 1:
        raise SystemExit("expected exactly one script named %r, found %d" % (name, len(hits)))
    return hits[0]


def pack_stack(stack, ln, comp):
    """compress `stack` so it fits exactly in comp bytes and decompresses to <= ln bytes (zero-padded)."""
    if len(stack) > ln:
        return None
    padded = stack + b"\x00" * (ln - len(stack))
    best = None
    for lvl in (9, 6):
        z = zlib.compress(padded, lvl)
        if best is None or len(z) < len(best):
            best = z
    if len(best) > comp:
        return None
    return best + b"\x00" * (comp - len(best)), ln


def main():
    args=[a for a in sys.argv if a!='--allow-grow']
    if len(args) not in (6, 7):
        print(__doc__)
        return 1
    ff, name, cg, st, outp = args[1:6]
    data = open(ff, "rb").read()
    head = data[:21]
    raw = decompress_ff(data)
    hdr = list(struct.unpack("<11I", raw[:44]))
    if hdr[0] != len(raw) - 44:
        print("note: header size field %d != stream length-44 %d" % (hdr[0], len(raw) - 44))
    start, s, comp, ln, bc = find_asset(raw, name)
    code = open(cg, "rb").read()
    stack = open(st, "rb").read()
    print("old: stack comp=%d len=%d  bytecode=%d" % (comp, ln, bc))
    print("new: stack len=%d  bytecode=%d" % (len(stack), len(code)))
    end = s + comp + bc

    packed = None
    if len(args) == 7:   # precompressed strings supplied: use them as they are
        zb = open(args[6], "rb").read()
        d = zlib.decompressobj(); pl = d.decompress(zb)
        if len(zb) == comp and len(pl) == ln and pl[:len(stack)] == stack and len(code) <= bc:
            packed = (zb, ln)
        else:
            print("precompressed strings do not match this zone")
    if not packed and len(code) <= bc:
        packed = pack_stack(stack, ln, comp)
    if packed:
        zbytes, newln = packed
        newcode = code + b"\x00" * (bc - len(code))
        new_asset = struct.pack("<6I", 0xFFFFFFFF, comp, ln, bc, 0xFFFFFFFF, 0xFFFFFFFF) \
            + name.encode() + b"\x00" + zbytes + newcode
        assert len(new_asset) == end - start
        out_raw = raw[:start] + new_asset + raw[end:]
        print("mode: EXACT FIT (zone layout unchanged)")
    else:
        need_b = len(code) - bc
        print("DOES NOT FIT: bytecode %d (room %d); strings %d (room %d), compressed space %d." % (len(code), bc, len(stack), ln, comp))
        if "--allow-grow" not in sys.argv:
            print("Nothing was written. Send these numbers to Claude, who will trim the script and give you a new kit.")
            return 2
        zb = zlib.compress(stack, 9)
        new_asset = struct.pack("<6I", 0xFFFFFFFF, len(zb), len(stack), len(code), 0xFFFFFFFF, 0xFFFFFFFF) \
            + name.encode() + b"\x00" + zb + code
        delta = len(new_asset) - (end - start)
        pad = ((abs(delta) + 0xFFF) // 0x1000 + 1) * 0x1000
        out_raw = raw[:start] + new_asset + raw[end:]
        hdr[0] = len(out_raw) - 44
        hdr[1] += pad
        for i in range(2, 11):
            if hdr[i]:
                hdr[i] += pad
        out_raw = struct.pack("<11I", *hdr) + out_raw[44:]
        print("mode: GROW (size %+d bytes; zone header raised by %d). Less safe: tell Claude if the game crashes." % (delta, pad))

    # prove the result reads back correctly before writing anything
    s2 = find_asset(out_raw, name)
    chk = zlib.decompress(out_raw[s2[1]:s2[1] + s2[2]]) if False else None
    open(outp, "wb").write(head + zlib.compress(out_raw, 6))
    again = decompress_ff(open(outp, "rb").read())
    assert again == out_raw
    find_asset(again, name)
    print("wrote %s (%d MB). Re-read check OK." % (outp, len(open(outp, 'rb').read()) // (1 << 20)))
    return 0


if __name__ == "__main__":
    sys.exit(main())
