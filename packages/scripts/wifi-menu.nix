{ pkgs, apps }:
pkgs.writeShellScriptBin "wifi-menu" ''
  #!/usr/bin/env bash
  exec hypr-float-toggle ${apps.terminal.command}.wifi wlctl
''
