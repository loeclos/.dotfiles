{ ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -a --icons";
      edit = "sudo -e";
      dots = "cd ~/.dotfiles";
    };

    # rbld [target] — rebuild + switch, with desktop notification.
    # Target accepts: laptop, .#laptop, #laptop. Defaults to current hostname.
    # notify-send runs as the user (not under sudo) so it keeps the DBUS
    # session dunst needs; failures never mask the rebuild exit code.
    interactiveShellInit = ''
            rbld() {
              local target="''${1:-$(hostname)}"
              target="''${target#.}"
              target="''${target#\#}"
              local flake="$HOME/.dotfiles#$target"
              local start=$SECONDS
              if sudo nixos-rebuild switch --flake "$flake"; then
                notify-send -u normal "NixOS Rebuild" "$target switched in $((SECONDS - start))s" || true
              else
                local rc=$?
                notify-send -u critical "NixOS Rebuild" "$target failed (exit $rc)" || true
                return $rc
              fi
            }


      update() {
        local flake="$HOME/.dotfiles"
        local start=$SECONDS

        if (( $# == 0 )); then
          nix flake update
        else
          local target="$1"
          if sudo nix flake update "$target" --flake "$flake"; then
            notify-send -u normal "NixOS Update" "$target updated in $((SECONDS - start))s" || true
          else
            local rc=$?
            notify-send -u critical "NixOS Update" "Updating $target failed (exit $rc)" || true
            return $rc
          fi
        fi
      }
    '';

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
    ];

    ohMyZsh = {
      enable = true;

      theme = "bira";
    };
  };
}
