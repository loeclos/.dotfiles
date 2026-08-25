{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/x-bzpdf" = "org.gnome.Papers.desktop";
      "application/x-gzpdf" = "org.gnome.Papers.desktop";
      "application/x-xzpdf" = "org.gnome.Papers.desktop";
      "application/x-ext-pdf" = "org.gnome.Papers.desktop";
    };
  };
}
