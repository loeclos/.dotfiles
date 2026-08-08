{ pkgs, ... }:
{
  gtk = {
    enable = true;
    # iconTheme.name = "WhiteSur-icon-theme";

    theme = {
      name = "gruvbox-dark";
      package = pkgs.gruvbox-dark-gtk;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-theme-name = "gruvbox-dark";
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = ":";
    };
  };

}
