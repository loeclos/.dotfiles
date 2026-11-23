{
  description = "comfortable minimalism";

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

    hyprland = {
      url = "github:hyprwm/Hyprland";
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

    watershot = {
      url = "github:Kirottu/watershot";
      flake = false;
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

    hyprtoolkit = {
      url = "github:hyprwm/hyprtoolkit/be487c470a1a10011fb8dccf9fc0f12f1e006cac";
      flake = false;
    };

    install-nix = {
      url = "github:loeclos/install-nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      spicetify-nix,
      hypr-quick-frame,
      apple-fonts,
      ...
    }@inputs:

    let
      system = "x86_64-linux";

      pinnedPkgs = inputs.pinned-nixpkgs.legacyPackages.${system};

      sf-pro-nerd = pinnedPkgs.callPackage ./packages/builds/sf-pro-nerd.nix {
        src = inputs.sf-pro-dmg;
      };

      mkHost = import ./lib/mkHost.nix { inherit inputs; };
    in
    {

      packages.${system} = {
        inherit sf-pro-nerd;
      };

      formatter.${system} = inputs.nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;

      nixosConfigurations = {
        desktop = mkHost { hostname = "desktop"; };
        laptop = mkHost { hostname = "laptop"; };
      };

    };

}
