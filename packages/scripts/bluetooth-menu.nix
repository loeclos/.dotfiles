{ pkgs, apps }:
pkgs.writeShellScriptBin "bluetooth-menu" ''
  #!/usr/bin/env bash
  exec hypr-float-toggle ${apps.terminal.command}.bt bluetuith
''
