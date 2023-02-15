{
  description = "test flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, hyprland } @ inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
	config.allowUnfree = true;
      };
      lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
	  inherit system;
	  specialArgs = { inherit inputs; };

	  modules = [
	    ./configuration.nix
	    hyprland.nixosModules.default
	    # {
	    #   programs.hyprland = {
	    #     enable = true;
	    #   nvidiaPatches = true;
	    #   };
	    # }
	  ];
	};
      };
    };
}
