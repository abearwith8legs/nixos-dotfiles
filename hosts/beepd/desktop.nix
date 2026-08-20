{ config, pkgs, lib, ... }:

{
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "rowan";
}
