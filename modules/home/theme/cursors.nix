{ pkgs, theme, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.bibata-cursors;
    name = theme.cursor.name;
    size = theme.cursor.size;
    gtk.enable = true;
  };
}
