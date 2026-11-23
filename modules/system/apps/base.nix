{
  pkgs,
  inputs,
  apps,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
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
    wlogout

    # hypr ecosystem
    inputs.hypr-quick-frame.packages.${system}.default

    # network / hardware
    brightnessctl
    iwd
    bluetuith
    ntfsprogs
    pamixer

    # tools
    imagemagick
    qemu
    quickemu
    unzip
    wl-clipboard

    # ui / theming
    inputs.walt.packages.${system}.default
    moka-icon-theme
  ];

}
