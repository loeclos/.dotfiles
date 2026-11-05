{ pkgs }:
pkgs.writeShellScriptBin "screenshot" ''
  # screenshot — select a region, save it to ~/Pictures/Screenshots and
  # copy it to the clipboard. watershot's own -c flag forks to serve the
  # copy, which is unreliable from a Hyprland bind, so belt-and-suspenders:
  # also stream the PNG (-s) through wl-copy explicitly. Cancel (empty
  # stdout) leaves the clipboard untouched.
  dir="$HOME/Pictures/Screenshots"
  ${pkgs.coreutils}/bin/mkdir -p "$dir"
  tmp=$(${pkgs.coreutils}/bin/mktemp --suffix=.png)
  trap '${pkgs.coreutils}/bin/rm -f "$tmp"' EXIT
  if ${pkgs.watershot}/bin/watershot -c -s directory "$dir" > "$tmp" && [ -s "$tmp" ]; then
    ${pkgs.wl-clipboard}/bin/wl-copy --type image/png < "$tmp"
  fi
''
