{ ... }:
{
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;

    enableZshIntegration = true;

    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "MartionMono Nerd Font";

      window-padding-x = 3;
      window-padding-y = 3;

      custom-shader = "assets/ghostty/shaders/cursor_warp.gisl";
    };
  };
}
