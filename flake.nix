{
  description = "BimOS from scratch";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; 
			# All inputs that don't have a nixpkgs of their own will use ours,
  		# preventing duplicate nixpkgs versions in the store.
			inputs.nixpkgs.follows = "nixpkgs";
    };
		nix-index-database = {
			url = "github:nix-community/nix-index-database";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    stylix = {
      url = "github:nix-community/stylix/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-26.05";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak = {
			url = "github:gmodena/nix-flatpak/?ref=latest";
		};
		bettery = {
      url = "github:gopal-lohar/bettery";
      flake = false;
    };
    oryx = {
      url = "github:pythops/oryx";
      flake = false;
    };
    v4l-tui = {
      url = "github:sermuns/v4l-tui";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, stylix, nixvim, nix-index-database, nix-flatpak, home-manager, agenix,... }@inputs:
  let
    lib = nixpkgs.lib;

    mkHost =
      { hostname
      , system ? "x86_64-linux"
      , flakePath ? "/home/${homeuser}/nixos-dotfiles"  #define flake path before building
      , homeuser ? "amdelt42"
      , extraModules ? [ ]
      , extraSpecialArgs ? { }
      }:
      lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs homeuser hostname flakePath; };

        modules = [
          ./hosts/${hostname}/configuration.nix
          stylix.nixosModules.stylix
          nixvim.nixosModules.nixvim
          agenix.nixosModules.default
        ]
        ++ lib.optional (builtins.pathExists ./hosts/${hostname}/home.nix) home-manager.nixosModules.home-manager
        ++ lib.optional (builtins.pathExists ./hosts/${hostname}/home.nix) {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${homeuser} = import ./hosts/${hostname}/home.nix;
            backupFileExtension = "backup";
            extraSpecialArgs = { inherit inputs homeuser flakePath self; } // extraSpecialArgs;
            sharedModules = [
              nix-flatpak.homeManagerModules.nix-flatpak
              nix-index-database.homeModules.nix-index
            ];
          };
        }
        ++ extraModules;
      };
  in
  {
    nixosConfigurations = {
      bimtop = mkHost {
        hostname = "bimtop";
        # extraSpecialArgs = {
        # };
      };

      bimserver = mkHost {
        hostname = "bimserver";
      };
    };
  };
}