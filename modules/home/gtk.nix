{ pkgs, ... }:
{
  gtk = {
    enable = true;
    iconTheme.name = "WhiteSur-icon-theme";

    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk4.colorScheme = "dark";
    gtk3.colorScheme = "dark";

    gtk3.extraConfig = {
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-decoration-layout = ":";
    };
  };

}
