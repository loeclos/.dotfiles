.dotfiles — NixOS configuration
===============================

A declarative, reproducible NixOS flake + home-manager setup for multiple machines. One repo builds `desktop` (NVIDIA RTX 5060 Ti), `laptop`, and `live` ISO with identical UX: Hyprland (Lua), Waybar, Ghostty, Rofi, and Gruvbox theming from a single source of truth.

- Full docs: https://deepwiki.com/loeclos/.dotfiles
- Last updated: 2026-10-10 04:14 UTC

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
- **Flake** (`flake.nix`) — pins `nixpkgs` (unstable + `pinned-nixpkgs` for Apple fonts), `home-manager`, `hyprland`, `nixvim`, `notesy`, `qs-wallpaper-picker`, `wlctl`, `plymouth-theme` (`mac-style` boot splash via its overlay), etc. Outputs `nixosConfigurations.{desktop,laptop,live}` and `formatter`.
- **lib/** — shared code, not config: `lib/theme.nix` (Gruvbox palette, fonts, cursor, display 1920x1080), `lib/mkHost.nix` (thin hostname → nixosSystem wiring), `lib/overlays.nix` (every overlay in one place), `lib/autoimport.nix` (manifest helper: drop a file in the right folder and it's live).
- **hosts/** — one file per machine + shared `hosts/common.nix` (timezone, locale, NetworkManager, user). `hosts/desktop.nix` holds the early-KMS RTX logic inline; `hosts/hardware/` holds the generated hardware scans; `hosts/live.nix` is hardware-agnostic (`not-detected.nix`, kvm-intel/amd).
- **modules/** — every feature as a module, auto-imported by folder: `modules/system/` (boot, hardware, security, desktop, apps) and `modules/home/` (theme, desktop, GUI apps, CLI tools, OS integration).
- **packages/** — everything built in-repo behind one overlay (`packages/default.nix`, used as `pkgs.<name>`): `builds/` (compiled: `sf-pro-nerd`, `spun`, `ollama-cuda`, `quickshell-multimedia`, `hyprsaver`, `hyprpolkitagent`) + `scripts/` (shell helpers: `hypr-float-toggle`, `wifi-menu`, `bluetooth-menu`, `rofi-keybinds`, `rofi-nixosrebuild` generated via `lib.genAttrs`, `wallpaper-picker`).
- **assets/** — wallpapers (one-word names) + Ghostty cursor-warp shader (`assets/ghostty/shaders/cursor_warp.glsl`, wired in `apps/terminal.nix`). `spun` (PolyForm Noncommercial CD-shaped player, local playback + 3D players, vinyl default patched in `postPatch`).

Repository structure
-------------------
```
flake.nix + flake.lock          # inputs, mkHost wiring, formatter
home.nix                        # single home-manager entrypoint (imports modules/home)
lib/
  theme.nix                     # palette, fonts, cursor, display — ONLY place for #1d2021, a99f8f, Martian Mono (terminal), Bibata-Modern-Ice 24, 1920x1080
  mkHost.nix                    # thin wiring: common + hosts/<name>.nix + home-manager + overlays
  overlays.nix                  # every overlay: upstream (apple-fonts, plymouth, notesy) + packages/ + hyprtoolkit pin
  autoimport.nix                # manifest helper — drop a .nix in the right folder and it's live
hosts/
  common.nix                    # shared: timeZone, locale, NM, user groups
  desktop.nix                   # identity + NVIDIA early-KMS + Windows os-prober + /mnt/ssd
  laptop.nix
  live.nix                      # hardware-agnostic (not-detected.nix, kvm-intel/amd)
  hardware/{desktop,laptop}.nix # generated scans (nixos-generate-config output, don't hand-edit)
modules/
  system/                       # system-level, auto-imported (default.nix is 3 lines, never hand-edited)
    {boot,nix,shell}.nix        # grub text-mode (splashImage=null, no NixOS logo) 1920x1080, plymouth mac-style splash (quiet splash), nix/cachix, zsh aliases
    hardware/{audio,bluetooth,printing,storage}.nix  # rtkit, bluetooth, avahi/printing, udisks2
    security/{polkit,keyring}.nix                    # security.polkit (daemon + pkexec setuid wrapper), gnome-keyring
    virtualisation.nix          # docker + libvirt/QEMU-KVM (qemu_kvm, swtpm, spiceUSBRedirection) + virt-manager, groups docker/libvirtd/kvm
    desktop/{hyprland,fonts,login}.nix  # Hyprland+UWSM+portals, fonts, login.nix = greetd/tuigreet TTY greeter + hyprlock PAM
    apps/{base,ollama}.nix      # base = environment.systemPackages; ollama = pinned CUDA build (pkgs.ollama-cuda)
  home/                         # user-level (home-manager), auto-imported
    theme/{gtk,cursor}.nix      # gtk+qt+dconf merged, cursor — theme via extraSpecialArgs
    desktop/                    # everything graphical: hyprland/ (only multi-file feature: default+settings+keybinds+window-rules+autostart, Lua, systemd.enable=false — UWSM owns session), waybar.{nix,css}, wallpaper.nix, dunst/hypridle/hyprlock/hyprshot/hyprsaver/hyprpolkitagent/rofi.nix
    apps/{terminal,notesy,opencode,spicetify,spun,typora}.nix  # GUI programs; terminal = ghostty + cursor-warp shader (absolute custom-shader path, animation=always)
    cli/{eza,git,github}.nix    # terminal tools (not GUI apps)
    system/{packages,xdg}.nix   # packages = home.packages set (nixpkgs list + pkgs.<script>); xdg = mimeApps (PDF → Papers, images → feh)
packages/                       # everything built in-repo, one overlay (packages/default.nix → pkgs.<name>)
  builds/{hyprsaver,hyprpolkitagent,ollama,quickshell-multimedia,sf-pro-nerd,spun}.nix  # hyprpolkitagent: v0.2.0 (nixpkgs ships themeless 0.1.3) + pinned hyprtoolkit (needs abseil-cpp)
  scripts/{hypr-float-toggle,wifi-menu,bluetooth-menu,rofi-keybinds,rofi-nixosrebuild,wallpaper-picker}.nix
assets/wallpaper/               # one-word names only
assets/ghostty/shaders/cursor_warp.glsl  # Neovide-like cursor trail (see apps/terminal.nix)
```

How it fits together
-------------------
1. `flake.nix` declares `desktop`, `laptop`, `live` via `lib/mkHost.nix`.
2. `mkHost` injects `hosts/common.nix`, `hosts/<name>.nix`, `home-manager` (user env from `home.nix`, with `extraSpecialArgs`: `inputs`, `osConfig`, `theme`, `repoRoot`), and `lib/overlays.nix` (upstream + `packages/` + `hyprtoolkit` pin).
3. `home.nix` pulls in `modules/home` (auto-imported — every `.nix` in the right folder is live, see `lib/autoimport.nix`).
4. `modules/system/default.nix` and `modules/home/default.nix` are 3-line manifests (auto-import, never hand-edited). The one exception: a folder with its own `default.nix` is self-contained — only `desktop/hyprland/` earns this (5-file Lua config), its helpers are private. See `AGENTS.md:3.3`.
5. Boot splash: `plymouth-theme` input exposes `mac-style-plymouth` via its overlay (wired in `lib/overlays.nix`); `modules/system/boot.nix` enables `boot.plymouth` with `theme = "mac-style"` (pairs with existing `quiet splash` kernelParams).

See `AGENTS.md` for the full contributor guide: least-change, clean-code, structure rules, wallpaper naming, and verification.

Key design choices
-----------------
- **Theme as data**: `lib/theme.nix:3` is the only place for `#1d2021`, `a99f8f`, `Martian Mono` (terminal default; `SFMono Nerd Font` kept as fallback), `Bibata-Modern-Ice 24`, `1920x1080`. Change once, rebuild everywhere.
- **Generate > copy-paste**: `desktop/waybar.nix` `"*" = lib.range 1 9` (monitor-keyed persistent workspaces), `desktop/hyprland/window-rules.nix` `mkFloatRule`, `packages/scripts/rofi-nixosrebuild.nix` `genAttrs` for hosts×actions.
- **Packages are referenced, not wired**: consumers use `pkgs.<name>` (one overlay in `packages/default.nix`); asset dirs use `repoRoot + "/assets/..."` (flake root via `extraSpecialArgs`). No `callPackage ../../../` chains.
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

Agents (e.g. opencode) prefix privileged commands with `pkexec` — it prompts via GUI (`hyprpolkitagent`), no TTY needed:
```bash
pkexec nixos-rebuild switch --flake .#desktop
pkexec nix-collect-garbage -d
```
pkexec re-prompts every time by design (no sudo-style credential caching).

Notes
-----
- `result` and `*.save` are gitignored; see `.gitignore`.
- `boot.loader.grub.gfxmodeEfi` and Hyprland `gaps/borders` derive from `lib/theme.nix`.
- Hyprland uses `configType = "lua"` (required for newer Hyprland). Keep Lua helpers `mkLuaInline`/`mkBind` in `desktop/hyprland/keybinds.nix`.
- `hardware.bluetooth` lives only in `system/hardware/bluetooth.nix` (`AGENTS.md:7`).
- Wallpapers are one-word (`road.png`, `dock.jpg`), deployed from `assets/wallpaper/` to `~/.config/wallpapers/`; `Super+Shift+W` opens the Quickshell picker (`awww` images, `mpvpaper` video, no online search), boot restores last wallpaper else `road.png`; Ghostty cursor-warp shader lives in `assets/ghostty/shaders/cursor_warp.glsl` (deployed to `~/.config/ghostty/shaders/`, `custom-shader-animation = always`); `satoshi.zip` stays deleted as unused — don't re-add without wiring.

Agent guide: `AGENTS.md` — must be updated alongside `README.md` after every structural change; bump `Last updated: YYYY-MM-DD HH:MM UTC` to today.

License: MIT
