<!--
last-updated: 2026-11-05 00:00 UTC
agent-guide: AGENTS.md — must be updated alongside README.md after every structural change
-->

# mononix — NixOS configuration (`~/.dotfiles`)

A declarative NixOS flake and Home Manager setup that drives my machines from a single source of truth. One repo builds `desktop` (NVIDIA RTX 5060 Ti) and `laptop` with the same environment—Hyprland (Lua), Waybar, Ghostty, Rofi, and Gruvbox theming—plus matching `live-desktop` and `live-laptop` installer ISOs with this flake embedded.

- Full docs: https://deepwiki.com/loeclos/.dotfiles

## Overview

<img width="1920" height="1080" alt="desktop screenshot" src="https://github.com/user-attachments/assets/80d30157-0acf-417c-bf24-e03aa1254a7b" />

Everything needed to build and theme the system lives in this flake:

- **Host configurations** under `hosts/` for installed machines and live installer ISOs.
- **System and user modules** under `modules/`, automatically imported by directory.
- **Shared theme and app definitions** under `lib/` so colors, fonts, and default apps are configured in one place.
- **Custom packages, scripts, and assets** under `packages/` and `assets/`.

## What this repo contains

- **Flake (`flake.nix`)** — Pins `nixpkgs` (unstable, plus `pinned-nixpkgs` for Apple fonts), `home-manager`, `hyprland`, `nixvim`, `install-nix` (guided ISO installer), `walt` (terminal wallpaper picker), `wlctl`, `watershot` (screenshot utility), `plymouth-theme` (`mac-style` boot splash), and supporting sources. Exports `nixosConfigurations.{desktop,laptop,live-desktop,live-laptop}` and the `nixfmt-rfc-style` formatter.
- **`lib/`** — Shared helpers and single-source-of-truth data:
  - `lib/theme.nix` defines the Gruvbox palette, fonts, cursor, and 1920x1080 display geometry.
  - `lib/apps.nix` defines the essential apps (browser, terminal, agent, file manager, editor, plus `extraBrowsers`). Switching a name here updates packages, XDG defaults, keybinds, float rules, and picker scripts automatically.
  - `lib/mkHost.nix` wires each host with `hosts/common.nix`, Home Manager (`withHome = false` on ISOs), and overlays.
  - `lib/overlays.nix` collects all upstream and local overlays in one file.
  - `lib/autoimport.nix` imports every `.nix` file in a module folder automatically.
- **`hosts/`** — Machine definitions and `hosts/common.nix` (timezone, locale, NetworkManager, user account). `hosts/desktop.nix` configures NVIDIA early KMS, GRUB OS prober for Windows, the `/mnt/ssd` NTFS mount, and CUDA `ollama`. `hosts/laptop.nix` enables `power-profiles-daemon`. `hosts/hardware/` holds generated `nixos-generate-config` scans. `hosts/live.nix` and `hosts/live-{desktop,laptop}.nix` define the minimal GNOME + recovery installer ISOs with `/iso/dotfiles` embedded.
- **`modules/`** — Feature modules split into `modules/system/` (boot, hardware, security, virtualisation, desktop, base packages) and `modules/home/` (GTK/Qt/cursor theme, Hyprland and desktop utilities, GUI apps, CLI tools, packages, and XDG associations).
- **`packages/`** — In-repo derivations and scripts exposed through a single overlay (`packages/default.nix`) as `pkgs.<name>`:
  - `builds/`: `sf-pro-nerd`, `spun`, `ollama-cuda`, `hyprsaver`, `hyprpolkitagent`, and `watershot`.
  - `scripts/`: `hypr-float-toggle`, `wifi-menu`, `bluetooth-menu`, `rofi-keybinds`, `power-profile-cycle`, `screenshot`, and `usb-sound`.
- **`assets/`** — Wallpapers (one-word filenames), USB plug/unplug audio cues (`usb-in.mp3`, `usb-out.mp3`), the Ghostty cursor-warp shader (`cursor_warp.glsl`), and the repo's OpenCode skill (`SKILL.md`).

## Repository structure

```text
flake.nix + flake.lock          # inputs, host definitions, formatter
home.nix                        # Home Manager entrypoint (imports modules/home)
lib/
  theme.nix                     # Gruvbox palette, fonts (Martian Mono), Bibata cursor, 1920x1080
  apps.nix                      # default browser/terminal/agent/file-manager/editor + catalogs
  mkHost.nix                    # host builder: common + host + home-manager + overlays
  overlays.nix                  # upstream overlays + local packages/ + hyprtoolkit pin
  autoimport.nix                # directory auto-import helper
hosts/
  common.nix                    # shared timezone, locale, NetworkManager, user groups
  desktop.nix                   # NVIDIA early-KMS, OS prober, /mnt/ssd, CUDA ollama
  laptop.nix                    # laptop host + power-profiles-daemon
  live.nix                      # shared ISO base (minimal GNOME, recovery tools, install-nix, /iso/dotfiles)
  live-{desktop,laptop}.nix     # per-host installer ISOs (desktop adds NVIDIA)
  hardware/{desktop,laptop}.nix # generated hardware scans (do not hand-edit)
modules/
  system/                       # NixOS modules (auto-imported via default.nix)
    {boot,nix,shell}.nix        # GRUB text mode, mac-style Plymouth, Nix/Cachix, zsh & shell aliases
    hardware/{audio,bluetooth,printing,storage,usb-sound}.nix  # PipeWire, Bluetooth, CUPS, udisks2, USB udev sound
    security/{polkit,keyring}.nix                    # polkit + pkexec wrapper, gnome-keyring
    virtualisation.nix          # Docker, libvirt/QEMU-KVM (swtpm, SPICE USB), virt-manager
    desktop/{hyprland,fonts,login}.nix  # Hyprland + UWSM, system fonts, greetd/tuigreet + hyprlock PAM
    apps/base.nix               # system packages (terminal + editor from lib/apps.nix)
  home/                         # Home Manager modules (auto-imported via default.nix)
    theme/{gtk,cursor}.nix      # GTK, Qt, dconf, and cursor theme
    desktop/                    # graphical environment:
                                #   hyprland/ (default, settings, keybinds, window-rules, autostart, gestures)
                                #   waybar.{nix,css}, wallpaper.nix (walt + hyprpaper)
                                #   dunst, hypridle, hyprlock, watershot, hyprsaver, hyprpolkitagent, rofi.nix
    apps/{terminal,opencode,spicetify,spun,typora}.nix  # Ghostty (+ shader), OpenCode (+ skill), Spotify, Spun, Typora
    cli/{eza,git,github}.nix    # CLI tools and Bash/Zsh eza aliases (including nix-shell)
    system/{packages,xdg}.nix   # home.packages and XDG MIME defaults
packages/                       # in-repo overlay (packages/default.nix -> pkgs.<name>)
  builds/{hyprsaver,hyprpolkitagent,ollama,sf-pro-nerd,spun,watershot}.nix
  scripts/{hypr-float-toggle,wifi-menu,bluetooth-menu,rofi-keybinds,power-profile-cycle,screenshot,usb-sound}.nix
assets/
  wallpaper/                    # one-word wallpaper filenames (road.png, dock.jpg, ...)
  sounds/{usb-in,usb-out}.mp3   # USB drive plug/unplug sounds
  ghostty/shaders/cursor_warp.glsl
  opencode/skills/nixos-dotfiles/SKILL.md
```

## How it fits together

1. `flake.nix` defines `desktop`, `laptop`, `live-desktop`, and `live-laptop` through `lib/mkHost.nix`. The live ISOs include `installation-cd-graphical-calamares-gnome.nix` and set `withHome = false` to keep the image lean.
2. `mkHost` wires `hosts/common.nix`, `hosts/<name>.nix`, `lib/overlays.nix`, and Home Manager (`home.nix`), passing `inputs`, `apps`, `osConfig`, `theme`, and `repoRoot` via `specialArgs` and `extraSpecialArgs`.
3. `modules/system/default.nix` and `modules/home/default.nix` are 3-line manifests using `lib/autoimport.nix`. Dropping a `.nix` file into the right category makes it active immediately. Multi-file features live in their own subfolder with a `default.nix` (currently only `modules/home/desktop/hyprland/`).
4. Boot uses text-mode GRUB paired with the `mac-style` Plymouth splash (`modules/system/boot.nix`), handing off to `greetd`/`tuigreet` to start Hyprland under UWSM.

## Key design choices

- **Theme as data** — `lib/theme.nix` is the single place for colors (`#1d2021`, `#a99f8f`), fonts (`Martian Mono` with `SFMono Nerd Font` fallback), cursor (`Bibata-Modern-Ice` 24), and resolution (`1920x1080`).
- **Apps as data** — `lib/apps.nix` holds the active choices for browser, terminal, coding agent, file manager, and editor (`chromium`, `ghostty`, `opencode`, `nautilus`, `nvim`, plus `brave` in `extraBrowsers`). Modules and scripts read `apps` from `specialArgs` instead of hardcoding binary names.
- **Overlay instead of relative `callPackage` chains** — Every local build or script is exposed as `pkgs.<name>` in `packages/default.nix`, and assets are referenced via `repoRoot + "/assets/..."`.
- **Clean host files** — Shared settings live in `hosts/common.nix`; host files only describe machine-specific hardware and services.
- **Desktop ergonomics**:
  - **Screenshots**: `Print` runs `pkgs.screenshot` (`watershot` region select saved to `~/Pictures/Screenshots` and copied to the clipboard via `wl-copy`).
  - **Wallpapers**: `Super+Shift+W` opens `walt` in a floating terminal window (`<terminal>.walt`), backed by `hyprpaper` (defaulting to `road.png`).
  - **Screensaver**: `hyprsaver` (pinned to the `tesla` shader) toggles with `Super+Ctrl+S` and starts automatically after 10 minutes of idle.
  - **Laptop power profiles**: `Super+Ctrl+P` (or clicking the Waybar indicator) cycles through hardware-supported `power-profiles-daemon` modes.
  - **Touchpad & media keys**: Mac-style touchpad settings and 3-finger gestures in Hyprland, plus F2/F3 and F5/F6 paired with XF86 volume and brightness keys.
  - **USB audio feedback**: udev rules trigger `pkgs.usb-sound` on whole-disk USB stick insertion/removal, playing `usb-in.mp3` / `usb-out.mp3` across active user PipeWire sessions.

## Build & deploy

```bash
# check evaluation (no build)
nix flake check --no-build

# format Nix files (2-space, nixfmt-rfc-style)
nix fmt

# build a host without switching
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild build --flake .#laptop

# switch the running system
sudo nixos-rebuild switch --flake .#desktop

# build live installer ISOs
nix build .#nixosConfigurations.live-desktop.config.system.build.isoImage
nix build .#nixosConfigurations.live-laptop.config.system.build.isoImage
```

### Installing from a live ISO

Boot the generated ISO and run the guided installer (requires an internet connection):

```bash
sudo install-nix
# or manually:
sudo nixos-install --flake /iso/dotfiles#desktop  # or #laptop
```

### Running privileged commands from an agent

GUI agents such as OpenCode run root commands with `pkexec`, which pops up a minimal `hyprpolkitagent` password dialog on screen without needing a TTY:

```bash
pkexec nixos-rebuild switch --flake /home/loeclos/.dotfiles#desktop
pkexec nix-collect-garbage -d
```

## Notes & troubleshooting

- **Hyprland Lua config**: Hyprland uses `configType = "lua"` and UWSM manages the session (`systemd.enable = false` in the Home Manager module). Shell-side dispatches use `hl.dsp.*`.
- **Waybar**: Workspaces use `{name}` with `persistent-only = true` for Hyprland 0.56 compatibility, and the network module stays icon-only.
- **Obsidian blank window after Electron updates**: If Obsidian 1.14.5 opens blank with `webFrame` / `defineProperty` errors after an Electron update, close Obsidian and delete `~/.config/obsidian/{Cache,Code Cache,GPUCache}`. Your vaults are unaffected.

## License

MIT
