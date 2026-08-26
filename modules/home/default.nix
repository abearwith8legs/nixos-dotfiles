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

    # Create a dummy theme package named "marketplace" so Spicetify's config sets current_theme = marketplace
    theme = pkgs.runCommand "marketplace" {} ''
      mkdir -p $out
      touch $out/color.ini
      touch $out/user.css
    '';

    enabledCustomApps = with spicePkgs.apps; [
      marketplace
    ];

    enabledExtensions = with spicePkgs.extensions; [
      # your extensions here
    ];
  };
}
