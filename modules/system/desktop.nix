{ config, pkgs, lib, ... }:

{
  # Generic X11 stack — the actual desktop environment (Plasma, GNOME,
  # etc.), display manager, and autologin choice are host-specific and
  # live in hosts/<host>/desktop.nix, since they differ between machines.
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
}
