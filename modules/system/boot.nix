{ config, pkgs, ... }:

{
  # Ensure systemd-boot is DISABLED
  boot.loader.systemd-boot.enable = false;

  # Ensure GRUB is ENABLED and correctly configured
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
    configurationLimit = 5;
    efiInstallAsRemovable = true;
    fontSize = 36;
  };
}
