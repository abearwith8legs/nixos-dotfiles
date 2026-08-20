{ config, pkgs, ... }:

{
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-uuid/20a2e54c-c100-4aae-a5e4-805ed3750453";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  # Force the drive to be seen as internal
  # NOTE: this UUID (4EA2113DA2112ACB) does NOT match the /mnt/storage UUID
  # above (20a2e54c-...). This rule is either targeting a different drive
  # entirely, or it's stale from before /mnt/storage was reformatted.
  # Run `lsblk -f` and confirm which UUID actually belongs to the drive you
  # want treated as internal, then fix one side or the other.
  services.udev.extraRules = ''
    ENV{ID_FS_UUID}=="4EA2113DA2112ACB", ENV{UDISKS_SYSTEM_INTERNAL}="1"
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", TAG+="mutter-device-preferred-primary"
  '';
}
