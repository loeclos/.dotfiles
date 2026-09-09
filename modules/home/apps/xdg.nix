{ ... }:
{
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # documents
      "application/pdf" = "org.gnome.Papers.desktop";
      "application/x-bzpdf" = "org.gnome.Papers.desktop";
      "application/x-gzpdf" = "org.gnome.Papers.desktop";
      "application/x-xzpdf" = "org.gnome.Papers.desktop";
      "application/x-ext-pdf" = "org.gnome.Papers.desktop";

      # images — all common types → feh
      "image/jpeg" = "feh.desktop";
      "image/png" = "feh.desktop";
      "image/gif" = "feh.desktop";
      "image/webp" = "feh.desktop";
      "image/bmp" = "feh.desktop";
      "image/x-bmp" = "feh.desktop";
      "image/svg+xml" = "feh.desktop";
      "image/tiff" = "feh.desktop";
      "image/avif" = "feh.desktop";
      "image/heif" = "feh.desktop";
      "image/heic" = "feh.desktop";
      "image/jxl" = "feh.desktop";
      "image/x-icon" = "feh.desktop";
      "image/vnd.microsoft.icon" = "feh.desktop";
      "image/x-tga" = "feh.desktop";
      "image/x-exr" = "feh.desktop";
      "image/x-portable-pixmap" = "feh.desktop";
      "image/x-xpixmap" = "feh.desktop";
      "image/x-xbitmap" = "feh.desktop";
      "image/apng" = "feh.desktop";
    };
  };
}
