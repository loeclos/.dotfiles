{ ... }:
{
  programs.ghostty = {
    enable = true;

    installVimSyntax = true;

    enableZshIntegration = true;

    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "SFMono Nerd Font 12";
      font-size = 12;

      window-padding-x = 3;
      window-padding-y = 3;

      confirm-close-surface = false;
    };
  };
}
