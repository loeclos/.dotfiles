# modules/home/theme/gtk.nix — merged theme: qt + gtk + dconf (all use theme)
{ config, pkgs, theme, ... }:
{
  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  systemd.user.sessionVariables = {
    GTK_THEME = "adw-gtk3-dark";
  };

  gtk = {
    enable = true;
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

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Gruvbox-Plus-Dark";
      font-name = "${theme.fonts.sans} ${toString theme.fonts.size}";
    };
  };
}
