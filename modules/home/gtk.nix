{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme.name = "Whitesur-icon-theme";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk4.colorScheme = "dark";
    gtk3.colorScheme = "dark";
  };

}
