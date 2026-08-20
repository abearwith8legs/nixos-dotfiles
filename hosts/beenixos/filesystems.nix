{ config, pkgs, ... }:

# Extra disk mounts specific to the beenixos desktop — don't copy this
# file to another host; generate a fresh one per machine if it also
# has extra drives.
{
  fileSystems."/home/rowan/Games" = {
    device = "/dev/disk/by-uuid/32ef89ea-f55b-4d69-a5b1-651d98298999";
    fsType = "btrfs";
    options = [ "subvol=/@games" "compress=zstd" "noatime" ];
  };

  fileSystems."/mnt/huge-boi" = {
    device = "/dev/disk/by-uuid/e1623e41-43b2-4dda-bbd1-7db8ae666c5e";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/mnt/big-boi" = {
    device = "/dev/disk/by-uuid/9e831b5c-9020-4735-9eb8-84d4fed43fab";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };

  fileSystems."/mnt/external-backup" = {
    device = "/dev/disk/by-uuid/8C705FD5705FC51C";
    fsType = "ntfs3";
    options = [ "defaults" "nofail" "uid=1000" "gid=100" ];
  };

  fileSystems."/mnt/win-ssd" = {
    device = "/dev/disk/by-uuid/80CA2076CA206A9C";
    fsType = "ntfs3";
    options = [ "defaults" "nofail" "uid=1000" "gid=100" ];
  };

  fileSystems."/mnt/local-disk" = {
    device = "/dev/disk/by-uuid/27293EE97C8C2FF6";
    fsType = "ntfs3";
    options = [ "force" "nofail" ];
  };
}
