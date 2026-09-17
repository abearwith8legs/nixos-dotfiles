{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with `passwd`.
  users.users.rowan = {
    isNormalUser = true;
    description = "rowan";
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    uid = 1000;
    shell = pkgs.fish;
  };
}
