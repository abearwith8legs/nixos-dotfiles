{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    trusted-users = [ "root" "rowan" ];

    # Cachix binary caches to avoid compiling wine-astral from source
    substituters = [
      "https://cache.nixos.org"
      "https://nix-citizen.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-citizen.cachix.org-1:lPMkWc2X8XD4/7YPEEwXKKBg+SVbYTVrAaLA2wQTKCo="
    ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-3.18.0-unstable-2024-04-18"
    "googleearth-pro-7.3.7.1155"
  ];

  boot.supportedFilesystems = [ "ntfs" ];

  # AMD GPU / Hardware Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Needed for Steam and 32-bit Wine/Proton games
  };
  hardware.enableRedistributableFirmware = true;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # swapDevices and powerManagement.cpuFreqGovernor are host-specific —
  # swap size depends on disk headroom and governor depends on whether
  # the machine is on battery. Set both in hosts/<host>/configuration.nix.

  users.users.rowan.extraGroups = [ "adbusers" "video" "audio" "realtime" ];

  environment.sessionVariables = {
    XCOMPOSEFILE = "${pkgs.keyd}/share/keyd/keyd.compose";
  };

  virtualisation.waydroid.enable = true;
  

  # Experimental
  nix.extraOptions = "experimental-features = nix-command flakes";

  # system.stateVersion is intentionally NOT set here — it must stay
  # pinned to whatever release each machine was originally installed
  # with, never bumped to match another host or the current channel.
  # Set it per-host in hosts/<host>/configuration.nix.
}