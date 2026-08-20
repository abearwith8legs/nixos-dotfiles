{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with `passwd`.
  users.users.rowan = {
    isNormalUser = true;
    description = "rowan";
    extraGroups = [ "networkmanager" "wheel" ];
    uid = 1000;
    shell = pkgs.fish;
  };
}
