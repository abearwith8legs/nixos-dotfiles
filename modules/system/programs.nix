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

  programs.droidcam.enable = true;

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enableSSHSupport = true;
  # };
}
