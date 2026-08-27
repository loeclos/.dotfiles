# lib/mkHost.nix — helper to deduplicate nixosSystem declarations
{ inputs }:
{
  hostname,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules =
    [
      ../hosts/common.nix
      ../hosts/${hostname}/default.nix
      inputs.home-manager.nixosModules.home-manager
      (
        { config, ... }:
        {
          nixpkgs.config.allowUnfree = true;

          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
              osConfig = config;
              theme = import ../lib/theme.nix;
            };
            backupFileExtension = "backup";
            users.loeclos = {
              imports = [ ../users/loeclos/home.nix ];
            };
          };

          nixpkgs.overlays = [
            inputs.apple-fonts.overlays.default
            (_final: prev: {
              hyprsaver = prev.callPackage ../derivations/hyprsaver.nix {
                src = inputs.hyprsaver;
              };
            })
            (_final: prev: {
              sf-pro-nerd = prev.callPackage ../derivations/sf-pro-nerd.nix {
                src = inputs.sf-pro-dmg;
              };
            })
          ];
        }
      )
    ]
    ++ extraModules;
}
