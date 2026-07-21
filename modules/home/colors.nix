{ config, pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "gtk2";
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "Gruvbox-Dark";
  };
}
