# lib/autoimport.nix — one helper behind both module manifests.
# Usage (in modules/system/default.nix or modules/home/default.nix):
#   { imports = import ../../lib/autoimport.nix { inherit lib; } ./.; }
# Returns every loose .nix file under the manifest's directory. Two rules:
# - the manifest itself (dir/default.nix) is skipped — it does the importing;
# - a folder with its own default.nix is self-contained: the folder's
#   default.nix is imported, its other .nix files are its private helpers
#   (e.g. desktop/hyprland/: settings/keybinds/window-rules/autostart are
#   imported with args by its default.nix, they are not modules).
# So: drop a .nix file in the right folder and it's live; the folder you
# choose IS the config. Only create a subfolder with default.nix when one
# feature genuinely spans several files.
{ lib }:
dir:
let
  dirStr = toString dir;
  files = lib.filesystem.listFilesRecursive dir;
  # Ancestor dirs of p relative to dir, e.g. "desktop/hyprland" — excluding
  # dir itself. A file directly under dir has none.
  ancestorDirs =
    p:
    let
      rel = lib.removePrefix (dirStr + "/") (toString p);
      parts = lib.splitString "/" rel;
      idxs = builtins.genList (i: i) (builtins.length parts - 1);
      join = n: builtins.concatStringsSep "/" (lib.take (n + 1) parts);
    in
    map join idxs;
  # True when p lives inside a self-contained folder (but is not its default.nix).
  isHelper =
    p:
    p != dir + "/default.nix"
    && baseNameOf p != "default.nix"
    && builtins.any (d: builtins.pathExists (dir + "/${d}/default.nix")) (ancestorDirs p);
in
builtins.filter (p: lib.hasSuffix ".nix" p && p != dir + "/default.nix" && !isHelper p) files
