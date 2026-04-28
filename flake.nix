{
	description = "my nixos+home manager+flakes config";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		nixos-hardware.url = "github:NixOS/nixos-hardware/master";

		mac-style-plymouth = {
			url = "github:loeclos/plymouth-theme";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		
                nixvim = {
                        url = "github:loeclos/nixvim";
                        inputs.nixpkgs.follows = "nixpkgs";
                };
	};

	outputs = { 
		self, 
		nixpkgs, 
		home-manager, 
		nixos-hardware,
		mac-style-plymouth,
		nvf,
		... 
	} @ inputs: 
	let 
		system = "x86_64-linux";
	in
	{
		nixosConfigurations = {
			desktop = nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					./host/desktop/configuration.nix
					home-manager.nixosModules.home-manager
					({ config, pkgs, ... }:{
						home-manager = {
							useGlobalPkgs = true;
							useUserPackages = true;
							extraSpecialArgs = {
								inherit inputs;
								osConfig = config;
							};
              						backupFileExtension = "backup";
							users.loeclos.imports = [ 
								inputs.nvf.homeManagerModules.default
								./users/loeclos/home.nix 
							];
						};

						nixpkgs.overlays = [
							inputs.mac-style-plymouth.overlays.default
						];
					})
				];
			};

			laptop = nixpkgs.lib.nixosSystem {
				inherit system;
				specialArgs = { inherit inputs; };
				modules = [
					./hosts/laptop/configuration.nix
					home-manager.nixosModules.home-manager
					({ config, pkgs, ... }: {
						home-manager = {
							useGlobalPkgs = true;
							useUserPackages = true;
							extraSpecialArgs = {
								inherit inputs;
								osConfig = config;
							};
              						backupFileExtension = "backup";
							users.loeclos.imports = [
        							inputs.nixvim.packages.x86_64-linux.default	
                                                                ./users/loeclos/home.nix
							];
						};

						nixpkgs.overlays = [
							inputs.mac-style-plymouth.overlays.default
						];
					})
				];
			};
		};
	};
}
