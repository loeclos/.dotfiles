.dotfiles — NixOS configuration
===============================

A declarative, reproducible NixOS flake + home-manager setup for multiple machines. One repo builds `desktop` (NVIDIA RTX 5060 Ti), `laptop`, and `live` ISO with identical UX: Hyprland (Lua), Waybar, Ghostty, Rofi, and Gruvbox theming from a single source of truth.

- Full docs: https://deepwiki.com/loeclos/.dotfiles
- Last updated: 2026-09-10 23:45 UTC

Overview
--------
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/80d30157-0acf-417c-bf24-e03aa1254a7b" />

This repository is a Nix flake that contains:
- a flake-based NixOS configuration and home-manager setups,
- assets and derivations used by those configurations (fonts, shaders, wallpapers),
- per-host configuration under hosts/, and
- reusable modules under modules/ for both NixOS and home-manager.

The flake builds and composes machine configurations; home-manager modules expose per-user configuration. The repository keeps a small number of derivations (e.g., packaging a font) and local assets required by the configuration.

What this repo contains
-----------------------
- **Flake** (`flake.nix`) — pins `nixpkgs` (unstable + `pinned-nixpkgs` for Apple fonts), `home-manager`, `hyprland`, `nixvim`, `qs-wallpaper-picker`, `wlctl`, etc. Outputs `nixosConfigurations.{desktop,laptop,live}` and `formatter`.
- **lib/** — shared helpers: `lib/theme.nix` (Gruvbox palette, fonts, cursor, display 1920x1080) and `lib/mkHost.nix` (deduplicates host boilerplate + overlays).
- **hosts/** — per-host + shared `hosts/common.nix` (timezone, locale, NetworkManager, user). `hosts/desktop/nvidia.nix` isolates early-KMS RTX logic. `hosts/live/default.nix` is hardware-agnostic (`not-detected.nix`, kvm-intel/amd).
- **modules/** — reusable NixOS and home-manager modules (grouped: `core`, `hardware`, `services`, `desktop`, `apps`).
- **pkgs/scripts/** — extracted shell helpers (`hypr-float-toggle`, `wifi-menu`, `bluetooth-menu`, `rofi-keybinds`, `rofi-nixosrebuild` generated via `lib.genAttrs`).
- **derivations/** + **assets/** — custom font packaging (`sf-pro-nerd`), `hyprsaver` build, wallpapers (one-word names, `image.png` removed, `satoshi.zip`/`ghostty/shaders` deleted as unused ~6.2MB).

Repository structure
-------------------
```
flake.nix + flake.lock          # inputs, mkHost wiring, formatter
lib/
  theme.nix                     # palette, fonts, cursor, display — ONLY place for #1d2021, a99f8f, SFMono, Bibata-Modern-Ice 24, 1920x1080
  mkHost.nix                    # hostname → nixosSystem + home-manager + overlays (apple-fonts, sf-pro-nerd, hyprsaver)
hosts/
  common.nix                    # shared: timeZone, locale, NM, user groups
  desktop/{default.nix,nvidia.nix,hardware-configuration.nix}
  laptop/default.nix
  live/default.nix              # hardware-agnostic (not-detected.nix, kvm-intel/amd)
modules/
  nixos/                        # system-level
    core/{nix.nix,bootloader.nix,shell.nix}    # nix/cachix, limine 1920x1080, zsh aliases
    hardware/{audio.nix,bluetooth.nix}
    services/{printing.nix,disk.nix,virtualisation.nix,keyring.nix}
    desktop/{hyprland.nix,greetd.nix,fonts.nix,login/sddm.nix}
    apps/{system.nix,ollama.nix}
  home/                         # user-level (home-manager)
    theme/{gtk.nix,cursors.nix}              # gtk+qt+dconf merged, cursors — imports theme via extraSpecialArgs
    desktop/{dunst.nix,flameshot.nix,hyprlock.nix,hypridle.nix,hyprshot.nix,hyprsaver.nix,quickshell/wallpaper-picker.nix,rofi.nix,waybar/}
    hyprland/{default.nix,settings.nix,keybinds.nix,window-rules.nix,autostart.nix} # Lua, mkBind/mkFloatRule helpers
    apps/{ghostty.nix,shell-eza.nix,spicetify.nix,user.nix,vcs-git.nix,vcs-github.nix,xdg.nix} # xdg.nix: mimeApps (PDF → Papers, images → feh)
derivations/{hyprsaver.nix,ollama.nix,quickshell-multimedia.nix,sf-pro-nerd.nix}
pkgs/scripts/{hypr-float-toggle.nix,wifi-menu.nix,bluetooth-menu.nix,rofi-keybinds.nix,rofi-nixosrebuild.nix,wallpaper-picker.nix}
assets/wallpaper/               # one-word names only
users/loeclos/home.nix
```

How it fits together
-------------------
1. `flake.nix:112` imports `lib/mkHost.nix` and declares `desktop`, `laptop`, `live`.
2. `mkHost` (`lib/mkHost.nix:1`) injects `hosts/common.nix`, `hosts/<host>/default.nix`, `home-manager` (with `extraSpecialArgs.theme`), and overlays (`apple-fonts`, `sf-pro-nerd`, `hyprsaver`).
3. `users/loeclos/home.nix` imports `modules/home/default.nix` (alphabetically sorted manifest).
4. `modules/nixos/default.nix` and `modules/home/default.nix` compose system/user environments. New files must be added to the manifest in sorted order — see `AGENTS.md:3.3`.

See `AGENTS.md` for the full contributor guide: least-change, clean-code, structure rules, wallpaper naming, and verification.

Key design choices
-----------------
- **Theme as data**: `lib/theme.nix:3` is the only place for `#1d2021`, `a99f8f`, `SFMono Nerd Font`, `Bibata-Modern-Ice 24`, `1920x1080`. Change once, rebuild everywhere.
- **Generate > copy-paste**: `waybar.nix:48 lib.genAttrs (map toString (lib.range 1 9))`, `hyprland/window-rules.nix:4 mkFloatRule`, `pkgs/scripts/rofi-nixosrebuild.nix:6 genAttrs` for hosts×actions.
- **Host = common + overlay**: No duplication of `networkmanager`, `timeZone`, or `home-manager` blocks.
- **Breaking polish**: `custom/seperator` → `custom/separator` (waybar + CSS) intentionally breaking to fix typo consistently.

Build & deploy
--------------
```bash
# format (opt-in, preserves 2-space style)
nix fmt

# build without switching
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild build --flake .#laptop
sudo nixos-rebuild build --flake .#live

# switch via Rofi (Super+Shift+R) or CLI
sudo nixos-rebuild switch --flake .#desktop
```

Notes
-----
- `result` and `*.save` are gitignored; see `.gitignore`.
- `boot.loader.limine.resolution` and Hyprland `gaps/borders` derive from `lib/theme.nix`.
- Hyprland uses `configType = "lua"` (required for newer Hyprland). Keep Lua helpers `mkLuaInline`/`mkBind` in `hyprland/keybinds.nix`.
- `hardware.bluetooth` lives only in `hardware/bluetooth.nix` (`AGENTS.md:7`).
- Wallpapers are one-word (`road.png`, `dock.jpg`), deployed from `assets/wallpaper/` to `~/.config/wallpapers/`; `Super+Shift+W` opens the Quickshell picker (`awww` images, `mpvpaper` video, no online search), boot restores last wallpaper else `road.png`; `assets/ghostty/shaders` and `satoshi.zip` were deleted as unused — don't re-add without wiring.

Agent guide: `AGENTS.md` — must be updated alongside `README.md` after every structural change; bump `Last updated: YYYY-MM-DD HH:MM UTC` to today.

License: MIT
