{ config, pkgs, lib, ... }:

let
  # 1. Define a stable package set for REAPER fallback
  stablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };

  vst2Paths = [
    "$HOME/.vst"
    "/run/current-system/sw/lib/vst"
    "/mnt/huge-boi/Reaper Stuff/Linux_Plugins/vst2"
  ];

  vst3Paths = [
    "$HOME/.vst3"
    "/run/current-system/sw/lib/vst3"
    "/mnt/huge-boi/Reaper Stuff/Linux_Plugins/vst3"
  ];

  clapPaths = [
    "$HOME/.clap"
    "/run/current-system/sw/lib/clap"
    "/mnt/huge-boi/Reaper Stuff/Linux_Plugins/clap"
  ];
in
{
  # ---------------------------------------------------------------------------
  # 1. Packages: REAPER, Bridging Tools & Native Synths
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # Host DAW (Pulled from stable)
    stablePkgs.reaper

    # Bridging tools for Windows VSTs (Valhalla, etc.)
    yabridge
    yabridgectl
    wineWow64Packages.staging

    # Diagnostics & Monitoring
    qpwgraph
    pavucontrol

    # Native plugins
    lsp-plugins
    calf
    airwindows
    dexed
    chow-centaur
    vital
    decent-sampler
  ];

  # ---------------------------------------------------------------------------
  # 2. Plugin Search Paths & yabridge Environment
  # ---------------------------------------------------------------------------
  environment.sessionVariables = {
    VST_PATH  = lib.concatStringsSep ":" vst2Paths;
    VST3_PATH = lib.concatStringsSep ":" vst3Paths;
    CLAP_PATH = lib.concatStringsSep ":" clapPaths;
    YABRIDGE_DEBUG_LEVEL = "0";
  };

  # ---------------------------------------------------------------------------
  # 3. Shell Aliases
  # ---------------------------------------------------------------------------
  environment.shellAliases = {
    reaper-resync = "yabridgectl sync";
  };

  # ---------------------------------------------------------------------------
  # 4. User Directory Initialization
  # ---------------------------------------------------------------------------
  systemd.user.services.reaper-plugin-dirs = {
    description = "Ensure standard user plugin and REAPER directories exist";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "create-plugin-dirs" ''
        mkdir -p $HOME/.vst $HOME/.vst3 $HOME/.clap
        mkdir -p $HOME/.config/REAPER/ColorThemes
        mkdir -p $HOME/.config/REAPER/UserPlugins
        mkdir -p $HOME/.config/REAPER/Effects
        mkdir -p "$HOME/.wine/drive_c/Program Files/Vstplugins"
        mkdir -p "$HOME/.wine/drive_c/Program Files/Common Files/VST3"
        mkdir -p "/mnt/huge-boi/Reaper Stuff/Linux_Plugins/vst2"
        mkdir -p "/mnt/huge-boi/Reaper Stuff/Linux_Plugins/vst3"
        mkdir -p "/mnt/huge-boi/Reaper Stuff/Linux_Plugins/clap"
      '';
    };
  };
}
