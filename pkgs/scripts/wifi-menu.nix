{ pkgs }:
pkgs.writeShellScriptBin "wifi-menu" ''
  #!/usr/bin/env bash
  exec hypr-float-toggle ghostty.wifi wlctl
''
