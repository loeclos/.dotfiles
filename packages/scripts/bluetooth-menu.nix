{ pkgs }:
pkgs.writeShellScriptBin "bluetooth-menu" ''
  #!/usr/bin/env bash
  exec hypr-float-toggle ghostty.bt bluetuith
''
