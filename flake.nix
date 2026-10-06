{
  description = "Rowan's NixOS configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, plasma-manager, nix-software-center, spicetify-nix, ... }@inputs:
  let
    # Builds one nixosConfigurations entry from a hostname. Every host
    # gets the same home-manager wiring (plasma-manager, spicetify) —
    # what differs per host lives in hosts/<hostname>/.
    mkHost = hostname: nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/${hostname}/hardware-configuration.nix
        ./hosts/${hostname}/configuration.nix

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
      beepd = mkHost "beepd"; # the laptop
    };
  };
}
