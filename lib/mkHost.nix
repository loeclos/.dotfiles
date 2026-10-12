# lib/mkHost.nix — hostname → nixosSystem. Thin wiring only.
# Each host = hosts/common.nix + hosts/<hostname>.nix + home-manager
# (user env from home.nix) + overlays from ./overlays.nix.
# Feature config lives in modules/system and modules/home (both
# auto-imported, see lib/autoimport.nix) — never duplicate that block here.
{ inputs }:
{
  hostname,
  system ? "x86_64-linux",
  extraModules ? [ ],
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ../hosts/common.nix
    ../hosts/${hostname}.nix
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
            theme = import ./theme.nix;
            # Flake root, so modules can reference assets/ without
            # fragile ../../../ chains (e.g. repoRoot + "/assets/wallpaper").
            repoRoot = inputs.self;
          };
          backupFileExtension = "backup";
          users.loeclos = {
            imports = [ ../home.nix ];
          };
        };

        nixpkgs.overlays = import ./overlays.nix { inherit inputs; };
      }
    )
  ]
  ++ extraModules;
}
