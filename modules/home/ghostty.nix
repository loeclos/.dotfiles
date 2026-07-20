{ ... }:
{
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;

    enableZshIntegration = true;

    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "MartianMono Nerd Font";
      font-size = 12;

      window-padding-x = 3;
      window-padding-y = 3;

      custom-shader = "../../assets/ghostty/shaders/cursor_warp.glsl";
      custom-shader-animation = "always";

      confirm-close-surface = false;
    };
  };
}
