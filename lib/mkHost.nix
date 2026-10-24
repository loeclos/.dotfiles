# lib/mkHost.nix — hostname → nixosSystem. Thin wiring only.
# Each host = hosts/common.nix + hosts/<hostname>.nix + home-manager
# (user env from home.nix) + overlays from ./overlays.nix.
# Feature config lives in modules/system and modules/home (both
# auto-imported, see lib/autoimport.nix) — never duplicate that block here.
# Live ISOs (hosts/live-*.nix) pass withHome = false: they boot the
# installer-cd GNOME stack as user nixos, so the full Hyprland home env
# is skipped to keep the squashfs minimal.
{ inputs }:
{
  hostname,
  system ? "x86_64-linux",
  extraModules ? [ ],
  withHome ? true,
}:
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = [
    ../hosts/common.nix
    ../hosts/${hostname}.nix
    (
      { ... }:
      {
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = import ./overlays.nix { inherit inputs; };
      }
    )
  ]
  ++ inputs.nixpkgs.lib.optionals withHome [
    inputs.home-manager.nixosModules.home-manager
    (
      { config, ... }:
      {
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
      }
    )
  ]
  ++ extraModules;
}
