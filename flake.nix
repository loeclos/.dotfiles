{
  description = "my nixos+home manager+flakes config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    pinned-nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

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

    wlctl = {
      url = "github:aashish-thapa/wlctl";
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

    hypr-quick-frame = {
      url = "github:Ronin-CK/HyprQuickFrame";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprsaver = {
      url = "github:maravexa/hyprsaver";
      flake = false;
    };

    apple-fonts = {
      url = "github:Lyndeno/apple-fonts.nix";
      inputs.nixpkgs.follows = "pinned-nixpkgs";
    };

    sf-pro-dmg = {
      url = "https://devimages-cdn.apple.com/design/resources/download/SF-Pro.dmg";
      flake = false;
    };

    ollama = {
      url = "github:ollama/ollama/v0.32.7";
      flake = false;
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
      wlctl,
      eza,
      spicetify-nix,
      hypr-quick-frame,
      apple-fonts,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pinnedPkgs = inputs.pinned-nixpkgs.legacyPackages.${system};

      sf-pro-nerd = pinnedPkgs.callPackage ./derivations/sf-pro-nerd.nix {
        src = inputs.sf-pro-dmg;
      };

      sfProNerdOverlay = _final: _prev: {
        inherit sf-pro-nerd;
      };

      hyprsaverOverlay = _final: _prev: {
        hyprsaver = _final.callPackage ./derivations/hyprsaver.nix {
          src = inputs.hyprsaver;
        };
      };
    in
    {
      packages.${system} = {
        inherit sf-pro-nerd;
      };

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
                  inputs.apple-fonts.overlays.default
                  hyprsaverOverlay
                  sfProNerdOverlay
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
                  inputs.apple-fonts.overlays.default
                  hyprsaverOverlay
                  sfProNerdOverlay
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
                  inputs.apple-fonts.overlays.default
                  hyprsaverOverlay
                  sfProNerdOverlay
                ];
              }
            )
          ];
        };

      };
    };
}
