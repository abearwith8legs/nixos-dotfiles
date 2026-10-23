{ config, pkgs, ... }:

{
  # Disable legacy channel-based command lookup
  programs.command-not-found.enable = false;

  # Enable network manager applet
  programs.nm-applet.enable = true;

  # Registers fish in /etc/shells so it's valid as a login shell (set in
  # modules/system/users.nix). Aliases and prompt config live in
  # modules/home/shell.nix via home-manager, since those are per-user
  # preferences, not system state.
  programs.fish.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libusb1
    systemd  # provides libudev
    fontconfig

    # GTK/Electron runtime stack
    glib
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
    cups
    dbus
    expat
    gtk3
    pango
    cairo
    alsa-lib
    libdrm
    mesa
    libxkbcommon

    # X11 libs commonly needed even under Wayland (XWayland compat)
    libX11
    libxcb
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libgbm
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        desiredgov = "powersave";
      };
    };
  };

  # Steam configuration
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  programs.steam.protontricks.enable = true;

  # programs.droidcam.enable = true;

  programs.dconf.enable = true;
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-enable-primary-paste = true;
        };
      };
    }
  ];

  programs.fuse.userAllowOther = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = false;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };

  boot.extraModulePackages = [
    (config.boot.kernelPackages.v4l2loopback.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        rm -f $out/lib/modules/*/modules.*
      '';
    }))
  ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Virtual Camera" exclusive_caps=1
  '';
}
