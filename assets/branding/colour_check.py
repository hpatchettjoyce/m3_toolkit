"""Report the colour profile and the colours inside PNG, SVG, PDF and AI files.

Usage: python3 colour_check.py FILE [FILE ...]

Each colour is named against the brand palette (Brand_Style.md): "Bright" is the
artwork's value, "Dull" is the guide's printed hex label. No third-party
libraries; PNGs are decoded with zlib, PDFs/AIs by inflating their streams.
"""
import re
import struct
import subprocess
import sys
import zlib
from collections import Counter
from pathlib import Path

# name: (Bright, Dull), from Brand_Style.md
PALETTE = {
    "Red Wine": ("#3A000C", "#34050D"), "Bright Red": ("#7E0019", "#730B1D"),
    "Light Clay": ("#D09180", "#C89583"), "Gold Stone": ("#EEA145", "#E4A557"),
    "Sandstone": ("#E4B77F", "#DEBA87"), "Marble": ("#F3E1CA", "#F1E3CE"),
    "Basil Leaf": ("#122806", "#17270B"), "Olive": ("#4B540A", "#4D541A"),
    "Light Olive": ("#B5B99B", "#B7BA9F"), "Deep Water": ("#042B2A", "#102A2A"),
    "Turquoise": ("#3BA9A9", "#5CA7A8"), "Dusty Sky": ("#ABC7C7", "#B1C7C8"),
    "Off-Black": ("#001212", "#041212"), "Off-White": ("#F8F2E4", "#F8F3E6"),
    "Charcoal": ("#354141", "#374141"), "Grey": ("#989F9F", "#999F9F"),
    "Parchment": ("#FCF8EF", "#FBF8F0"),
}


def name_of(hex_):
    """Exact palette match, else the nearest within 2 points (PDF rounding)."""
    rgb = [int(hex_[i:i + 2], 16) for i in (1, 3, 5)]
    best = None
    for name, pair in PALETTE.items():
        for kind, value in zip(("Bright", "Dull"), pair):
            v = [int(value[i:i + 2], 16) for i in (1, 3, 5)]
            d = max(abs(a - b) for a, b in zip(rgb, v))
            if best is None or d < best[0]:
                best = (d, name, kind)
    d, name, kind = best
    if d == 0:
        return f"{name} ({kind})"
    if d <= 2:
        return f"≈ {name} ({kind}, within {d})"
    return "not a brand colour"


def icc_name(profile):
    """An ICC profile's description, plus which colour space its primaries match."""
    return f"{icc_desc(profile)} ({icc_primaries(profile)})"


def icc_primaries(profile):
    """Compare the red primary with sRGB's and Display P3's (D50, rounded)."""
    count, = struct.unpack(">I", profile[128:132])
    for i in range(count):
        sig, off, ln = struct.unpack(">4sII", profile[132 + 12 * i:144 + 12 * i])
        if sig == b"rXYZ":
            x = round(struct.unpack(">i", profile[off + 8:off + 12])[0] / 65536, 3)
            return {0.436: "sRGB primaries", 0.515: "Display P3 primaries"}.get(x, f"other primaries, red X={x}")
    return "no RGB primaries"


def icc_desc(profile):
    count, = struct.unpack(">I", profile[128:132])
    for i in range(count):
        sig, off, ln = struct.unpack(">4sII", profile[132 + 12 * i:144 + 12 * i])
        if sig == b"desc":
            tag = profile[off:off + ln]
            if tag[:4] == b"desc":
                n, = struct.unpack(">I", tag[8:12])
                return tag[12:12 + n - 1].decode("latin1")
            if tag[:4] == b"mluc":
                n, o = struct.unpack(">II", tag[20:28])
                return tag[o:o + n].decode("utf-16-be")
    return "unnamed profile"


def check_png(path):
    data = path.read_bytes()
    pos, idat, profile = 8, b"", "none (viewers read it as sRGB)"
    while pos < len(data):
        n, = struct.unpack(">I", data[pos:pos + 4])
        kind, body = data[pos + 4:pos + 8], data[pos + 8:pos + 8 + n]
        pos += 12 + n
        if kind == b"IHDR":
            w, h, depth, ctype = struct.unpack(">IIBB", body[:10])
        elif kind == b"IDAT":
            idat += body
        elif kind == b"iCCP":
            name, rest = body.split(b"\0", 1)
            profile = icc_name(zlib.decompress(rest[1:]))
        elif kind == b"sRGB":
            profile = "sRGB (sRGB chunk)"
    print(f"  profile: {profile}")
    if depth != 8 or ctype not in (2, 6):
        print("  (only 8-bit RGB/RGBA PNGs are decoded)")
        return
    bpp = 4 if ctype == 6 else 3
    raw, stride = zlib.decompress(idat), w * bpp
    prev, counts, i = bytearray(stride), Counter(), 0
    for _ in range(h):  # undo PNG row filters
        f, line = raw[i], bytearray(raw[i + 1:i + 1 + stride])
        i += 1 + stride
        for x in range(stride):
            a = line[x - bpp] if x >= bpp else 0
            b, c = prev[x], (prev[x - bpp] if x >= bpp else 0)
            if f == 1:
                line[x] = (line[x] + a) & 255
            elif f == 2:
                line[x] = (line[x] + b) & 255
            elif f == 3:
                line[x] = (line[x] + (a + b) // 2) & 255
            elif f == 4:
                p = a + b - c
                pa, pb, pc = abs(p - a), abs(p - b), abs(p - c)
                line[x] = (line[x] + (a if pa <= pb and pa <= pc else b if pb <= pc else c)) & 255
        prev = line
        for x in range(0, stride, bpp):
            if bpp == 3 or line[x + 3] == 255:  # fully opaque pixels only
                counts["#%02X%02X%02X" % tuple(line[x:x + 3])] += 1
    for hex_, n in counts.most_common(3):
        print(f"  pixels {hex_}  x{n:,}  {name_of(hex_)}")


def check_svg(path):
    text = path.read_text(errors="replace")
    print("  profile: none (SVG colours are sRGB by definition)")
    found = [h.upper() for h in re.findall(r"#[0-9a-fA-F]{6}\b", text)]
    found += ["#%02X%02X%02X" % tuple(map(int, m)) for m in re.findall(r"rgb\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)", text)]
    for hex_, n in Counter(found).most_common(6):
        print(f"  fill {hex_}  x{n}  {name_of(hex_)}")


def check_pdf(path):
    data = path.read_bytes()
    streams = []
    for m in re.finditer(rb"stream\r?\n", data):
        end = data.find(b"endstream", m.end())
        try:
            streams.append(zlib.decompress(data[m.end():end]))
        except zlib.error:
            pass
    profiles = Counter(f"{s[16:20].decode().strip()}: {icc_name(s)}" for s in streams if s[36:40] == b"acsp")
    print("  profiles:", ", ".join(profiles) or "none embedded")
    text = b"\n".join(s for s in streams if s[36:40] != b"acsp").decode("latin1")
    rgb = Counter()
    for r, g, b in re.findall(r"(?<![\d.])([01]?\.?\d*) ([01]?\.?\d*) ([01]?\.?\d*)\s+(?:rg|RG|sc|scn|SC|SCN)\b", text):
        try:
            rgb["#%02X%02X%02X" % tuple(round(float(v) * 255) for v in (r, g, b))] += 1
        except ValueError:
            pass
    cmyk = len(re.findall(r"[\d.]+ [\d.]+ [\d.]+ [\d.]+ (?:k|K)\b", text))
    print(f"  CMYK colour settings: {cmyk}   RGB colour settings: {sum(rgb.values())}")
    for hex_, n in rgb.most_common():
        if name_of(hex_) != "not a brand colour":
            print(f"  fill {hex_}  x{n}  {name_of(hex_)}")
    # named swatches in Illustrator's XMP, stored as attributes or as elements
    xmp = data.decode("latin1")
    for block in re.findall(r"swatchName.*?blue[=>]\"?\d+", xmp, re.S):
        f = {}
        for key, value in re.findall(r"(swatchName|mode|red|green|blue)(?:=\"|>)([^\"<]*)", block):
            f.setdefault(key, value)  # first hit; closing tags match again, empty
        if f.get("mode") != "RGB" or not all(k in f for k in ("red", "green", "blue")):
            continue
        hex_ = "#%02X%02X%02X" % (int(f["red"]), int(f["green"]), int(f["blue"]))
        if name_of(hex_) != "not a brand colour":
            print(f"  swatch '{f['swatchName']}' {hex_}  {name_of(hex_)}")
    try:  # hex labels printed as text (needs poppler's pdftotext)
        out = subprocess.run(["pdftotext", str(path), "-"], capture_output=True, text=True).stdout
        for hex_ in sorted(set(h.upper() for h in re.findall(r"#\s?([0-9A-Fa-f]{6})\b", out))):
            print(f"  text label #{hex_}  {name_of('#' + hex_)}")
    except FileNotFoundError:
        pass


for arg in sys.argv[1:]:
    p = Path(arg)
    print(p.name)
    {".png": check_png, ".svg": check_svg, ".pdf": check_pdf, ".ai": check_pdf}.get(p.suffix.lower(), lambda _: print("  unsupported type"))(p)
