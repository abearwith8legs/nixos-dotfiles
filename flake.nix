{
  description = "Rowan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-citizen.url = "github:LovingMelody/nix-citizen";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-citizen.inputs.nix-gaming.follows = "nix-gaming";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    nix-software-center.url = "github:snowfallorg/nix-software-center";
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Make sure nix-citizen is explicitly destructured here:
  outputs = { self, nixpkgs, home-manager, plasma-manager, nix-software-center, spicetify-nix, nix-citizen, ... }@inputs:
  let
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/${hostname}/hardware-configuration.nix
        ./hosts/${hostname}/configuration.nix

        # Now nix-citizen is recognized in scope:
        nix-citizen.nixosModules.default

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };

          home-manager.sharedModules = [
            plasma-manager.homeModules.plasma-manager
            spicetify-nix.homeManagerModules.default
          ];

          home-manager.users.rowan = import ./modules/home;
          home-manager.backupFileExtension = "hm-backup";
        }
      ];
    };
  in {
    nixosConfigurations = {
      beenixos = mkHost "beenixos";
      beepd = mkHost "beepd";
    };
  };
}