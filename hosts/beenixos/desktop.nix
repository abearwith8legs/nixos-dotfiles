{ config, pkgs, lib, ... }:

{
  # Plasma — desktop-specific; the laptop runs GNOME instead
  # (hosts/beepd/desktop.nix). Generic X11/printing bits shared by
  # both live in modules/system/desktop.nix.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rowan";
}
