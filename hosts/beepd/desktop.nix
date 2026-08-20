{ config, pkgs, lib, ... }:

{
  # GNOME — laptop-specific; the desktop runs Plasma instead
  # (hosts/beenixos/desktop.nix). Generic X11/printing bits shared by
  # both live in modules/system/desktop.nix.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rowan";
}
