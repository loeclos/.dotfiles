{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "rofi-nixosrebuild" ''
      FLAKE_DIR="$HOME/.dotfiles"
      TERMINAL="ghostty"

      entries="\
Desktop (switch)        ❯  Rebuild & switch to desktop flake
Desktop (upgrade)       ❯  Rebuild & switch (update inputs)
Desktop (build)         ❯  Build only, no switch
Desktop (boot)          ❯  Build & add to boot menu
Desktop (test)          ❯  Build & test (no boot entry)
Laptop (switch)         ❯  Rebuild & switch to laptop flake
Laptop (upgrade)        ❯  Rebuild & switch (update inputs)
Laptop (build)          ❯  Build only, no switch
Laptop (boot)           ❯  Build & add to boot menu
Laptop (test)           ❯  Build & test (no boot entry)
Current host (switch)   ❯  Rebuild current system via flake
Live ISO (build)        ❯  Build live installer ISO
GC (cleanup)            ❯  Collect garbage & optimise"

      choice=$(echo "$entries" | rofi -dmenu -i -p "Rebuild" || exit 1)

      case "$choice" in
        *"Desktop (switch)")
          cmd="sudo nixos-rebuild switch --flake $FLAKE_DIR#desktop"
          ;;
        *"Desktop (upgrade)")
          cmd="sudo nixos-rebuild switch --flake $FLAKE_DIR#desktop --upgrade"
          ;;
        *"Desktop (build)")
          cmd="sudo nixos-rebuild build --flake $FLAKE_DIR#desktop"
          ;;
        *"Desktop (boot)")
          cmd="sudo nixos-rebuild boot --flake $FLAKE_DIR#desktop"
          ;;
        *"Desktop (test)")
          cmd="sudo nixos-rebuild test --flake $FLAKE_DIR#desktop"
          ;;
        *"Laptop (switch)")
          cmd="sudo nixos-rebuild switch --flake $FLAKE_DIR#laptop"
          ;;
        *"Laptop (upgrade)")
          cmd="sudo nixos-rebuild switch --flake $FLAKE_DIR#laptop --upgrade"
          ;;
        *"Laptop (build)")
          cmd="sudo nixos-rebuild build --flake $FLAKE_DIR#laptop"
          ;;
        *"Laptop (boot)")
          cmd="sudo nixos-rebuild boot --flake $FLAKE_DIR#laptop"
          ;;
        *"Laptop (test)")
          cmd="sudo nixos-rebuild test --flake $FLAKE_DIR#laptop"
          ;;
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
    '')
  ];
}
