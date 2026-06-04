{ config, pkgs, ... }:

{
  dconf.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "Adwaita-dark";
  };
}
