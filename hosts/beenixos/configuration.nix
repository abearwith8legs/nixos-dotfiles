# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system/audio.nix
    ../../modules/system/boot.nix
    ../../modules/system/desktop.nix
    ../../modules/system/gaming.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nix-settings.nix
    ../../modules/system/packages.nix
    ../../modules/system/programs.nix
    ../../modules/system/services.nix
    ../../modules/system/users.nix
    ../../modules/system/reaper.nix
    ../../modules/system/vr.nix

    ./desktop.nix
    ./filesystems.nix
  ];

  # --- HOST IDENTITY ---
  networking.hostName = "beenixos";

  # Pinned to this machine's original install release — do not bump to
  # match another host or the current channel version.
  system.stateVersion = "26.05";

  # --- GPU (hybrid-graphics desktop: force the discrete card) ---
  environment.sessionVariables = {
    DRI_PRIME = "0000:03:00.0";
  };

  # --- POWER (always on mains, so optimize for performance) ---
  powerManagement.cpuFreqGovernor = "performance";

  # --- SWAP ---
  swapDevices = [ {
    device = "/var/lib/swapfile";
    size = 16 * 1024; # 16GB
  } ];

  # --- FILE SYSTEMS ---
  # Root/home/nix/boot filesystems are declared in hardware-configuration.nix
  # (imported directly by flake.nix). Extra disk mounts (Games drive, backup
  # drives, etc.) live in ./filesystems.nix — host-local since these drives
  # are physically only in this machine.
}
