{
    description = "test flake";

    inputs = {

    };

    outputs = { self, nixpkgs } @ inputs:
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
	            ];
	        };
        };
    };
}
