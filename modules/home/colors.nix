{ config, pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "gtk2";
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
  };
}
