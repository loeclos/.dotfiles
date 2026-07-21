{ pkgs, ... }:
{
  gtk = {
    enable = true;
    # iconTheme.name = "WhiteSur-icon-theme";

    theme = {
      name = "Gruvbox-Dark";
      package = pkgs.gruvbox-gtk-theme;
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
      gtk-theme-name = "Gruvbox-Dark";
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = ":";
    };
  };

}
