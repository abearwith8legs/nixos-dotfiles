{ config, pkgs, lib, inputs, ... }:
let
  pythonEnv = pkgs.python3.withPackages (p: with p; [
    fiona
    geopandas
    matplotlib
    numpy
    pandas
    rasterio
    shapely
  ]);
in {
  nixpkgs.overlays = [
    (final: prev: {
      floorp-bin-unwrapped = prev.floorp-bin-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "12.16.4";
        src = prev.fetchurl {
          url = "https://github.com/Floorp-Projects/Floorp/releases/download/v${version}/floorp-linux-x86_64.tar.xz";
          sha256 = "5192fcf1ac000e0f5e56d08cb088de799671958573d2fe5d42b8352f1599bdf7";
        };
        passthru = (oldAttrs.passthru or { }) // {
          libName = "floorp-bin-${version}";
        };
      });

      limo = prev.limo.overrideAttrs (oldAttrs: {
        postPatch = (oldAttrs.postPatch or "") + ''
          sed -i '1i #include <cstdint>' src/core/progressnode.h
          sed -i '1i #include <cstdint>' src/core/installer.h
          sed -i '1i #include <iomanip>' src/core/versionchangelog.h
        '';
      });

      reaper-reapack-extension = prev.reaper-reapack-extension.overrideAttrs (oldAttrs: {
        NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " -Wno-error=deprecated";
      });

      reaper-sws-extension = prev.reaper-sws-extension.overrideAttrs (oldAttrs: {
        NIX_CFLAGS_COMPILE = (oldAttrs.NIX_CFLAGS_COMPILE or "") + " -std=c++17 -Wno-error";
      });
    })
  ];

  environment.systemPackages = with pkgs; [
    # --- Web & Communication ---
    brave
    floorp-bin
    stoat-desktop
    thunderbird
    vesktop
    zoom-us

    # --- Office, Notes & Productivity ---
    anki
    kdePackages.okular
    libreoffice
    obsidian

    # --- Graphics & Design ---
    gimp
    imgbrd-grabber
    inkscape
    krita
    pinta
    qgis

    # --- Media, Audio & TTS ---
    alsa-utils
    beets
    chromaprint
    ffmpeg
    feishin
    mpv
    picard
    piper-tts
    puddletag
    speechd
    spotatui
    newsflash

    # --- Gaming & Launchers ---
    deadlock-mod-manager
    gargoyle
    heroic
    lutris
    mudlet
    r2modman
    (prismlauncher.override {
      jdks = [
        temurin-bin-8
        temurin-bin-17
        temurin-bin-21
      ];
    })

    # --- Gaming Utilities & Compatibility ---
    gamescope
    limo
    mangohud
    protonup-qt
    wine
    winetricks

    # --- Text Editors & IDEs ---
    emacs
    geany
    helix
    micro
    neovim
    vscodium

    # --- Development & Languages ---
    android-tools
    git
    jq
    pythonEnv
    python3Packages.virtualenv
    temurin-bin
    racket
    nim
    nimble
    nimlsp

    # --- Terminal Core & CLI Utilities ---
    fish
    htop
    innoextract
    ouch
    starship
    wezterm
    wget

    # --- Terminal Candy (Visuals) ---
    asciiquarium
    cava
    cbonsai
    fastfetch
    lavat
    tenki
    unimatrix

    # --- System Management & GUI Tools ---
    fsearch
    inputs.nix-software-center.packages.${pkgs.stdenv.hostPlatform.system}.nix-software-center

    # --- Disk, Hardware & Boot ---
    efibootmgr
    glmark2
    gparted
    grub2_efi
    ntfs3g
    os-prober
    parted
    pciutils

    # --- Networking & P2P ---
    ookla-speedtest
    qbittorrent
    sshfs
    syncthing
  ];
}
