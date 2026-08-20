#!/usr/bin/env python3
"""
Build Ship-Amber.svg from a real, known-good Kvantum base theme instead of
a hand-written SVG (Kvantum's element-ID contract is intricate enough that
a from-scratch SVG is likely to misrender several widget states).

Usage:
    1. Make sure kdePackages.qtstyleplugin-kvantum is installed (it is,
       once modules/ship-theme.nix is in your imports).
    2. Find a base theme's SVG on your system, e.g.:
         fd -e svg . /run/current-system/sw/share/Kvantum
       "KvArc" or "KvFlatDark" are good minimal starting points if present;
       otherwise any theme you like the *shape* of works, since this script
       only touches color and corner radius, not layout.
    3. Run:
         python3 recolor-kvantum.py <path/to/Base.svg> Ship-Amber.svg
    4. Copy the result to
         assets/ship-theme/amber/Kvantum/Ship-Amber/Ship-Amber.svg
    5. Open Kvantum Manager -> Install/Update a Theme, point it at the
       Ship-Amber folder, and eyeball it against real widgets before
       committing to the flake. Expect to tweak colors by hand afterward --
       this gets you a valid, non-broken starting point, not a finished
       theme.
"""
import re
import sys

# Base16-derived amber palette (from the rice guide's Nostromo Amber scheme)
REPLACEMENTS = {
    # generic dark bg / near-black tones -> amber bg ramp
    "#1d1d1d": "#0d0906",
    "#181818": "#0d0906",
    "#212121": "#1a1108",
    "#2a2a2a": "#2b1c0e",
    "#2e2e2e": "#2b1c0e",
    "#333333": "#4d3218",
    "#3a3a3a": "#4d3218",
    # generic light/fg tones -> amber fg ramp
    "#eeeeee": "#ffb000",
    "#ffffff": "#ffcf66",
    "#e0e0e0": "#ffb000",
    "#cccccc": "#a86800",
    "#bbbbbb": "#a86800",
    # generic accent blues -> amber accent
    "#3daee9": "#ffb000",
    "#2980b9": "#a86800",
    "#1d99f3": "#ffb000",
    "#0d74c8": "#a86800",
}

RADIUS_ZERO = re.compile(r'(rx|ry)="[0-9.]+"')


def recolor(svg_text: str) -> str:
    out = svg_text
    for old, new in REPLACEMENTS.items():
        out = re.sub(old, new, out, flags=re.IGNORECASE)
    # Square off corners for the console-panel look. Comment this out if
    # you want to keep the base theme's rounding.
    out = RADIUS_ZERO.sub(lambda m: f'{m.group(1)}="0"', out)
    return out


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        sys.exit(1)
    src, dst = sys.argv[1], sys.argv[2]
    with open(src, "r", encoding="utf-8") as f:
        svg = f.read()
    with open(dst, "w", encoding="utf-8") as f:
        f.write(recolor(svg))
    print(f"wrote {dst} -- open it in Kvantum Manager's preview and compare "
          f"against {src} before trusting it")


if __name__ == "__main__":
    main()
