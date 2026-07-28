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

      confirm-close-surface = false;
    };
  };
}
