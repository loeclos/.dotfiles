{ pkgs, ... }:
{
  gtk = {
    enable = true;
    # iconTheme.name = "WhiteSur-icon-theme";

    # H1 fix: gruvbox-dark-gtk has no gtk-4.0/assets -> GTK4 file chooser (xdg-desktop-portal-gtk 1.15 + gtk4 4.22 + libadwaita 1.9)
    # fell back to unthemed Adwaita and looked ugly/full-height without rounding.
    # adw-gtk3-dark ships both gtk-3.0 and gtk-4.0 with libadwaita/Nautilus rounded styling.
    # To keep gruvbox colors, you can switch back to "gruvbox-dark" but you must provide a gtk-4.0 theme
    # (e.g., colloid or custom libadwaita recolor). For now use adw-gtk3-dark to restore Nautilus look.
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.symlinkJoin {
        name = "gruvbox-plus-adwaita-icons";
        paths = [
          (pkgs.gruvbox-plus-icons.overrideAttrs (old: {
            postInstall =
              (old.postInstall or "")
              + ''
                sed -i 's/^Inherits=.*/Inherits=Adwaita,hicolor/' $out/share/icons/Gruvbox-Plus-Dark/index.theme
                ${pkgs.gtk3}/bin/gtk-update-icon-cache $out/share/icons/Gruvbox-Plus-Dark || true
              '';
          }))
          pkgs.adwaita-icon-theme
          pkgs.hicolor-icon-theme
        ];
      };
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = ":";
    };

    gtk4.extraConfig = {
      gtk-theme-name = "adw-gtk3-dark";
      gtk-application-prefer-dark-theme = 1;
      gtk-decoration-layout = ":";
    };
  };

}
