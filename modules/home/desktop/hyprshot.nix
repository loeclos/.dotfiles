{ pkgs, inputs, ... }: {
  programs.hyprshot = {
    enable = true;
    package = pkgs.hyprshot.override {
      hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    };
  };
}
