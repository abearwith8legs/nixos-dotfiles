{ config, pkgs, ... }:

{
  imports = [
    ../../modules/system/audio.nix
    ../../modules/system/boot.nix
    ../../modules/system/desktop.nix
    ../../modules/system/locale.nix
    ../../modules/system/networking.nix
    ../../modules/system/nix-settings.nix
    ../../modules/system/packages.nix
    ../../modules/system/programs.nix
    ../../modules/system/services.nix
    ../../modules/system/users.nix

    ./desktop.nix
    ./graphics.nix
    ./security.nix
    ./storage.nix
    ./packages.nix

    # No ./filesystems.nix — beenixos's extra drives (Games, huge-boi,
    # big-boi, external-backup, win-ssd, local-disk) don't exist here.
    # This host has its own extra mount in ./storage.nix instead.
  ];

  # --- HOST IDENTITY ---
  # Matches the machine's current hostname — the rebuild/full-rebuild
  # fish aliases build the flake target from `hostname`, so this needs
  # to stay in sync with the nixosConfigurations attr name in flake.nix.
  networking.hostName = "beepd";

  # Pinned to this machine's original install release (24.05) — do not
  # bump to match beenixos or the current channel.
  system.stateVersion = "24.05";

  # --- POWER (battery-backed, unlike beenixos) ---
  powerManagement.cpuFreqGovernor = "schedutil";
  services.power-profiles-daemon.enable = true;

  # No swapDevices block here — hardware-configuration.nix already
  # declares a real swap partition (by UUID) from the original install.

  # modules/system/gaming.nix (DRI_PRIME env var) is beenixos-only —
  # this machine's GPU switching is handled by ./graphics.nix's NVIDIA
  # prime offload config instead, so it's intentionally not imported.
}
