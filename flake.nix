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
      nixvim,
      hyprland,
      walt,
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

      mkHost = import ./lib/mkHost.nix { inherit inputs; };
    in
    {
      packages.${system} = {
        inherit sf-pro-nerd;
      };

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      # hosts — see lib/mkHost.nix and hosts/common.nix
      nixosConfigurations = {
        desktop = mkHost { hostname = "desktop"; };
        laptop = mkHost { hostname = "laptop"; };
        live = mkHost {
          hostname = "live";
          extraModules = [ (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix") ];
        };
      };
    };
}
