{ pkgs, lib }:
let
  flakeHosts = [
    "desktop"
    "laptop"
  ];
  actions = [
    {
      key = "switch";
      desc = "Rebuild & switch";
      cmd = host: "sudo nixos-rebuild switch --flake $FLAKE_DIR#${host}";
    }
    {
      key = "upgrade";
      desc = "Rebuild & switch (update inputs)";
      cmd = host: "sudo nixos-rebuild switch --flake $FLAKE_DIR#${host} --upgrade";
    }
    {
      key = "build";
      desc = "Build only, no switch";
      cmd = host: "sudo nixos-rebuild build --flake $FLAKE_DIR#${host}";
    }
    {
      key = "boot";
      desc = "Build & add to boot menu";
      cmd = host: "sudo nixos-rebuild boot --flake $FLAKE_DIR#${host}";
    }
    {
      key = "test";
      desc = "Build & test (no boot entry)";
      cmd = host: "sudo nixos-rebuild test --flake $FLAKE_DIR#${host}";
    }
  ];

  capitalize =
    s: lib.toUpper (builtins.substring 0 1 s) + builtins.substring 1 (builtins.stringLength s - 1) s;

  hostEntries = lib.concatMapStringsSep "\n" (
    host:
    lib.concatMapStringsSep "\n" (
      action: "${capitalize host} (${action.key})        ❯  ${action.desc} to ${host} flake"
    ) actions
  ) flakeHosts;

  extraEntries = ''
    Current host (switch)   ❯  Rebuild current system via flake
    Live ISO (build)        ❯  Build live installer ISO
    GC (cleanup)            ❯  Collect garbage & optimise'';

  caseBranches = lib.concatMapStringsSep "\n" (
    host:
    lib.concatMapStringsSep "\n" (
      action: ''
        *"${capitalize host} (${action.key})")
          cmd="${action.cmd host}"
          ;;''
    ) actions
  ) flakeHosts;
in
pkgs.writeShellScriptBin "rofi-nixosrebuild" ''
  FLAKE_DIR="$HOME/.dotfiles"
  TERMINAL="ghostty"

  entries="\
  ${hostEntries}
  ${extraEntries}"

  choice=$(echo "$entries" | rofi -dmenu -i -p "Rebuild" || exit 1)

  case "$choice" in
  ${caseBranches}
    *"Current host (switch)")
      cmd="sudo nixos-rebuild switch --flake $FLAKE_DIR"
      ;;
    *"Live ISO (build)")
      cmd="sudo nixos-rebuild build --flake $FLAKE_DIR#live"
      ;;
    *"GC (cleanup)")
      cmd="sudo nix-collect-garbage -d && sudo nix-store --optimise"
      ;;
    *)
      exit 1
      ;;
  esac

  $TERMINAL -e bash -c "$cmd; echo; echo 'Done. Press Enter to close.'; read"
''
