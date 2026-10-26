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

    orbitty = {
      url = "github:aywski/orbitty";
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

    spun = {
      url = "github:yappologistic/Spun";
      flake = false;
    };

    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent/v0.2.0";
      flake = false;
    };

    hyprtoolkit = {
      url = "github:hyprwm/hyprtoolkit/be487c470a1a10011fb8dccf9fc0f12f1e006cac";
      flake = false;
    };

    plymouth-theme = {
      url = "github:loeclos/plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
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

      # hosts — one file per machine (hosts/<name>.nix), see lib/mkHost.nix and hosts/common.nix
      nixosConfigurations = {
        desktop = mkHost { hostname = "desktop"; };
        laptop = mkHost { hostname = "laptop"; };
        # Installer ISOs: minimal GNOME + Calamares + recovery tools (see
        # hosts/live.nix). withHome = false keeps the Hyprland home env out
        # of the squashfs. Each ISO embeds this flake at /iso/dotfiles and
        # ships install-nix, so it installs its matching system
        # (sudo install-nix, or manually nixos-install --flake /iso/dotfiles#<host>).
        live-desktop = mkHost {
          hostname = "live-desktop";
          withHome = false;
          extraModules = [ (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix") ];
        };
        live-laptop = mkHost {
          hostname = "live-laptop";
          withHome = false;
          extraModules = [ (nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix") ];
        };
      };
    };
}
