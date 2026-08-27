{ theme, ... }:
{
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;

    enableZshIntegration = true;

    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "${theme.fonts.mono} ${toString theme.fonts.size}";
      font-size = theme.fonts.size;

      window-padding-x = 3;
      window-padding-y = 3;

      confirm-close-surface = false;
    };
  };
}
