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
    })
  ];

  environment.systemPackages = with pkgs; [
    # Desktop
    floorp-bin
    brave
    kdePackages.okular
    libreoffice
    obsidian
    vesktop
    stoat-desktop
    pinta
    zoom-us
    krita
    inkscape
    feishin
    spotatui
    imgbrd-grabber
    thunderbird
    gimp
    anki

    # Development & Runtimes
    pythonEnv
    temurin-bin

    # Disk & Boot Management
    efibootmgr
    gparted
    grub2_efi
    ntfs3g
    os-prober
    parted

    # Gaming & Emulation
    lutris
    wine
    winetricks
    r2modman
    deadlock-mod-manager
    mudlet
    gargoyle
    heroic
    mangohud
    gamescope
    prismlauncher
    limo

    # Networking & Sync
    syncthing
    wget
    qbittorrent

    # Shell & Terminal Tools
    fish
    htop
    starship
    wezterm

    # Shell Candy
    cbonsai
    fastfetch
    unimatrix
    asciiquarium
    tenki
    cava
    lavat

    # System Utilities
    glmark2
    inputs.nix-software-center.packages.${pkgs.stdenv.hostPlatform.system}.nix-software-center
    pciutils
    ouch
    git
    fsearch
    innoextract
    speechd
    piper-tts
    alsa-utils
    jq
    protonup-qt
    mpv
    android-tools
    ookla-speedtest

    # Text & Code Editors
    micro
    vscodium
    geany
    emacs
    helix
    neovim

    # Music
    reaper
    reaper-reapack-extension
    reaper-sws-extension
  ];
}
