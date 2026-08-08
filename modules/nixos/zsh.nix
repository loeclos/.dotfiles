{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -a --icons";
      edit = "sudo -e";
      update = "sudo nixos-rebuild switch";
      dots = "cd ~/.dotfiles";
      rbld = "dots && sudo nixos-rebuild switch --flake";
      projects = "cd /mnt/ssd/projects/";
    };

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];

    ohMyZsh = {
      enable = true;

      theme = "bira";
    };
  };
}
