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

    walt = {
      url = "github:gitfudge0/walt";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eza = {
      url = "github:eza-community/eza";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      mac-style-plymouth,
      nixvim,
      hyprland,
      walt,
      eza,
      spicetify-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    in
    {

      # hosts configuration
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/desktop/configuration.nix
            home-manager.nixosModules.home-manager
            (
              { config, pkgs, ... }:
              {
                nixpkgs.config.allowUnfree = true;

                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                    osConfig = config;
                  };

                  backupFileExtension = "backup";

                  users.loeclos = {
                    imports = [
                      ./users/loeclos/home.nix
                    ];
                  };
                };

                nixpkgs.overlays = [
                  inputs.mac-style-plymouth.overlays.default
                ];
              }
            )
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            (
              { config, pkgs, ... }:
              {
                nixpkgs.config.allowUnfree = true;
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                    osConfig = config;
                  };

                  backupFileExtension = "backup";

                  users.loeclos = {
                    imports = [
                      ./users/loeclos/home.nix
                    ];
                  };
                };

                nixpkgs.overlays = [
                  inputs.mac-style-plymouth.overlays.default
                ];
              }
            )
          ];
        };

        live = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [
            (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
            ./hosts/laptop/configuration.nix
            home-manager.nixosModules.home-manager
            (
              { config, pkgs, ... }:
              {
                nixpkgs.config.allowUnfree = true;
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = {
                    inherit inputs;
                    osConfig = config;
                  };

                  backupFileExtension = "backup";

                  users.loeclos = {
                    imports = [
                      ./users/loeclos/home.nix
                    ];
                  };
                };

                nixpkgs.overlays = [
                  inputs.mac-style-plymouth.overlays.default
                ];
              }
            )
          ];
        };

      };
    };
}
