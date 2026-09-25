{ config, pkgs, lib, ... }:

let
  # Dedicated directory for plugin scan paths and Wine bridge prefixes
  audioPluginPaths = [
    "$HOME/.vst"
    "$HOME/.vst3"
    "$HOME/.clap"
    "$HOME/.lxvst"
    "/run/current-system/sw/lib/vst"
    "/run/current-system/sw/lib/vst3"
    "/run/current-system/sw/lib/clap"
  ];
in
{
  # ---------------------------------------------------------------------------
  # 1. Real-time Audio & Limits
  # ---------------------------------------------------------------------------
  security.rtkit.enable = true;

  security.pam.loginLimits = [
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "95"; }
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "nofile";  type = "-"; value = "524288"; }
  ];

  # ---------------------------------------------------------------------------
  # 2. PipeWire / JACK Low-Latency Configuration
  # ---------------------------------------------------------------------------
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Low-latency buffer tuning for real-time monitoring
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 128;
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 1024;
      };
    };
  };

  # ---------------------------------------------------------------------------
  # 3. Packages: Host DAW, Bridging, Utilities & Native Plugins
  # ---------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # DAW
    reaper
    reaper-reapack-extension
    reaper-sws-extension

    # Bridging tools for Windows VST2 / VST3 / CLAP
    yabridge
    yabridgectl
    wineWow64Packages.staging

    # Graph routing, diagnostics & monitoring
    qpwgraph
    pavucontrol

    # Native Linux audio plugins
    lsp-plugins
    calf
    airwindows
  ];

  # ---------------------------------------------------------------------------
  # 4. Standard Audio Environment Variables
  # ---------------------------------------------------------------------------
  # Exposes standardized plugin environment paths across shells and REAPER
  environment.sessionVariables = {
    VST_PATH = lib.concatStringsSep ":" [
      "$HOME/.vst"
      "/run/current-system/sw/lib/vst"
    ];
    VST3_PATH = lib.concatStringsSep ":" [
      "$HOME/.vst3"
      "/run/current-system/sw/lib/vst3"
    ];
    CLAP_PATH = lib.concatStringsSep ":" [
      "$HOME/.clap"
      "/run/current-system/sw/lib/clap"
    ];
    # Force yabridge notifications to quiet mode if preferred, or leave default
    YABRIDGE_DEBUG_LEVEL = "0";
  };

  # ---------------------------------------------------------------------------
  # 5. Helper Script: Initialize Directories & yabridge Paths
  # ---------------------------------------------------------------------------
  # Run `init-reaper-audio` once to set up directory structures and bridge paths
  environment.shellAliases = {
    reaper-resync = "yabridgectl sync";
  };

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
      '';
    };
  };
}
