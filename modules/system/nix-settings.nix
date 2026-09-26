{ config, pkgs, ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.trusted-users = [ "root" "rowan" ];

  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-3.18.0-unstable-2024-04-18"
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

  users.users.rowan.extraGroups = [ "adbusers" "video" ];

  environment.sessionVariables = {
    XCOMPOSEFILE = "${pkgs.keyd}/share/keyd/keyd.compose";
  };

  # Experimental
  nix.extraOptions = "experimental-features = nix-command flakes";

  # system.stateVersion is intentionally NOT set here — it must stay
  # pinned to whatever release each machine was originally installed
  # with, never bumped to match another host or the current channel.
  # Set it per-host in hosts/<host>/configuration.nix.
}