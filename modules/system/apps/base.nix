{
  pkgs,
  inputs,
  apps,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  # Editor package: nixpkgs attr (packageAttr) or flake build (flakeInput,
  # e.g. the nixvim-built neovim). Only consumer — no shared helper needed.
  editorPkg =
    if apps.editor ? flakeInput then
      inputs.${apps.editor.flakeInput}.packages.${system}.default
    else
      builtins.getAttr apps.editor.packageAttr pkgs;
in
{
  environment.systemPackages = with pkgs; [
    # apps
    editorPkg
    (builtins.getAttr apps.terminal.packageAttr pkgs)
    vifm
    wlogout

    # hypr ecosystem
    inputs.hypr-quick-frame.packages.${system}.default

    # network / hardware
    brightnessctl
    iwd
    bluetuith
    inputs.wlctl.packages.${system}.default
    ntfsprogs
    pamixer

    # tools
    eza
    imagemagick
    qemu
    quickemu
    unzip
    wl-clipboard

    # ui / theming
    inputs.walt.packages.${system}.default
    moka-icon-theme
    quickshell
  ];
}
