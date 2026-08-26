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

  # Choose any bundled theme directly:
  theme = spicePkgs.themes.catppuccin;
  colorScheme = "mocha";

  enabledCustomApps = with spicePkgs.apps; [
    marketplace
  ];

  enabledExtensions = with spicePkgs.extensions; [
    # your extensions
  ];
};
}
