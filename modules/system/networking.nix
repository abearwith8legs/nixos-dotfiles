{ config, pkgs, ... }:

{
  # networking.hostName is host-specific — set in hosts/<host>/configuration.nix
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Connectivity
  services.openssh.enable = true;
  services.blueman.enable = true;

  # Syncthing
  services.syncthing = {
    enable = true;
    user = "rowan";
    group = "users";
    configDir = "/home/rowan/.config/syncthing";
    dataDir = "/home/rowan/Documents";
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 60723 ]; # Replace with your qBittorrent listening port
    allowedUDPPorts = [ 60723 ];
  };

  # Network proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
}
