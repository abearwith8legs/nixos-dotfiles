{ config, pkgs, inputs, lib, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in
{
  imports = [
    ./shell.nix
    ./ship-theme
  ];

  home.username = "rowan";
  home.homeDirectory = "/home/rowan";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.spicetify = {
    enable = true;

    enabledExtensions = with spicePkgs.extensions; [
      shuffle
      seekSong
      spotifyGenres
      wikify
      romajiConvert
    ];

    enabledCustomApps = [
      spicePkgs.apps.marketplace
    ];
  };
}
