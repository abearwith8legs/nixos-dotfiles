{ config, pkgs, lib, ... }:

{
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.systemPackages = with pkgs; [
    polonium # Tiling plugin for Plasma 6
  ];

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rowan";
}
