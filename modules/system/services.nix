{ config, pkgs, inputs, lib, ... }:

{
  # Enable udisks2 and gvfs for GUI auto-mounting in file managers
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.flatpak.enable = true;

  services.pipewire.extraConfig.pipewire-pulse."92-low-latency" = {
    "context.properties" = [
      {
        name = "libpipewire-module-protocol-pulse";
        args = { };
      }
    ];
    "pulse.properties" = {
      "pulse.min.req" = "1024/48000";
      "pulse.default.req" = "1024/48000";
      "pulse.max.req" = "1024/48000";
      "pulse.min.quantum" = "1024/48000";
      "pulse.max.quantum" = "1024/48000";
    };
    "stream.properties" = {
      "node.latency" = "1024/48000";
      "resample.quality" = 1;
    };
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          alt = {
            "a" = "macro(C-S-u 2 2 7 enter)";     # ȧ
            "x" = "macro(C-S-u 2 1 d enter)";     # ȝ
            "u" = "macro(u C-S-u 3 0 7 enter)";   # u̇
            "y" = "macro(C-S-u 1 e 8 f enter)";   # ẏ
            "t" = "macro(C-S-u 0 0 f e enter)";   # þ
          };
          "alt+shift" = {
            "a" = "macro(C-S-u 2 2 6 enter)";     # Ȧ
            "x" = "macro(C-S-u 2 1 c enter)";     # Ȝ
            "u" = "macro(U C-S-u 3 0 7 enter)";   # U̇
            "y" = "macro(C-S-u 1 e 8 e enter)";   # Ẏ
            "t" = "macro(C-S-u 0 0 d e enter)";   # Þ
          };
        };
      };
    };
  };

  # Enable CUPS and add the Epson ESC/P-R driver
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson-escpr
    ];
  };

  # Network printer autodiscovery (essential for Wi-Fi printing)
  services.avahi = {
    enable = true;
    nssmdns4 = true; # Needed for resolving .local printer hostnames over IPv4
    publish = {
      enable = lib.mkForce null;
      userServices = lib.mkForce null;
    };
    settings.publish = {
      "disable-publishing" = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };

  # Enable SANE scanner support (XP-4200 is an all-in-one)
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      epkowa
      sane-airscan
    ];
  };

  # Ensure user is in lp and scanner groups
  users.users.rowan.extraGroups = [ "lp" "scanner" ];

  services.gnome.gnome-keyring.enable = true;
}
