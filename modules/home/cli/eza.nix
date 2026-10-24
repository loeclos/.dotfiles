{ ... }:
{
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    icons = "auto";
  };

  # nix-shell starts bash with its own /tmp rc (skips /etc/bashrc) but sources
  # ~/.bashrc when interactive — so the eza aliases must exist here too.
  # Without this, ls/ll/la fall back to coreutils inside nix-shell even though
  # the eza binary is on PATH (system package + user profile are preserved).
  programs.bash = {
    enable = true;
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -a --icons";
    };
  };
}
