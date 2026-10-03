{ config, pkgs, ... }:

{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    steam.importOXRRuntimes = true;
  };
}