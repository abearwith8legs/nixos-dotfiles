{ config, pkgs, lib, ... }:

# Plasma-only. This module is imported for every home-manager host
# (modules/home/default.nix), including bee_nixos which runs GNOME —
# the build still succeeds there since this just copies static files
# and packages a wrapper script, but running `ship-theme amber` on
# GNOME will fail: plasma-apply-lookandfeel, kvantummanager, and
# plasma-apply-colorscheme don't exist without Plasma installed.
let
  # Add "green" / "lcars" / "bladerunner" here once their asset folders
  # exist alongside amber/, matching the same internal layout.
  palettes = [ "amber" ];

  capitalize = s: lib.toUpper (builtins.substring 0 1 s)
    + builtins.substring 1 (builtins.stringLength s - 1) s;

  shipTheme = pkgs.writeShellScriptBin "ship-theme" ''
    set -euo pipefail
    palette="''${1:-}"
    valid="${lib.concatStringsSep " " palettes}"

    if ! printf ' %s ' "$valid" | grep -q " $palette "; then
      echo "usage: ship-theme [$valid]"
      exit 1
    fi

    cap="$(printf '%s' "$palette" | sed 's/./\U&/')"

    plasma-apply-lookandfeel -a "org.ship.$palette"
    kvantummanager --set "Ship-$cap"
    plasma-apply-colorscheme "Ship-$cap"

    wallpaper="$HOME/.config/ship-theme/$palette/wallpaper.png"
    if [ -f "$wallpaper" ]; then
      plasma-apply-wallpaperimage "$wallpaper"
    fi

    qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
  '';

  # One home.file entry set per palette: color scheme, look-and-feel
  # package, and Kvantum theme, each dropped straight into the XDG dirs
  # Plasma actually scans -- no derivation/share-linking indirection needed
  # now that we're in home-manager.
  perPalette = palette:
    let cap = capitalize palette;
    in {
      ".local/share/color-schemes/Ship-${cap}.colors".source =
        ./${palette}/Ship-${cap}.colors;
      ".local/share/plasma/look-and-feel/org.ship.${palette}".source =
        ./${palette}/org.ship.${palette};
      ".local/share/Kvantum/Ship-${cap}".source =
        ./${palette}/Kvantum/Ship-${cap};
    };
in
{
  home.packages = with pkgs; [
    kdePackages.qtstyleplugin-kvantum
    shipTheme
  ];

  home.file = lib.foldl' (acc: p: acc // (perPalette p)) { } palettes;
}
