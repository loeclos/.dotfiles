.dotfiles — NixOS configuration
===============================

A declarative, reproducible NixOS flake + home-manager setup for multiple machines. One repo builds `desktop` (NVIDIA RTX 5060 Ti) and `laptop` with identical UX: Hyprland (Lua), Waybar, Ghostty, Rofi, and Gruvbox theming from a single source of truth — plus `live-desktop` / `live-laptop` installer ISOs (minimal GNOME + Calamares + recovery tools + `install-nix` guided installer, each embedding this flake so it installs its matching system).

- Full docs: https://deepwiki.com/loeclos/.dotfiles
- Last updated: 2026-10-26 14:21 UTC

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
- **Flake** (`flake.nix`) — pins `nixpkgs` (unstable + `pinned-nixpkgs` for Apple fonts), `home-manager`, `hyprland`, `nixvim`, `install-nix` (guided ISO installer, ships on the live images via its overlay), `walt` (fast terminal wallpaper picker, hyprpaper backend), `wlctl`, `plymouth-theme` (`mac-style` boot splash via its overlay), etc. Outputs `nixosConfigurations.{desktop,laptop,live-desktop,live-laptop}` and `formatter`.
- **lib/** — shared code, not config: `lib/theme.nix` (Gruvbox palette, fonts, cursor, display 1920x1080), `lib/mkHost.nix` (thin hostname → nixosSystem wiring, `withHome = false` for ISOs), `lib/overlays.nix` (every overlay in one place), `lib/autoimport.nix` (manifest helper: drop a file in the right folder and it's live).
- **hosts/** — one file per machine + shared `hosts/common.nix` (timezone, locale, NetworkManager, user). `hosts/desktop.nix` holds the early-KMS RTX logic inline (GRUB `useOSProber` for Windows + `/mnt/ssd` NTFS mount) + desktop-only `ollama` (pinned CUDA); `hosts/hardware/` holds the generated hardware scans (UUID filesystems — regenerate with `nixos-generate-config`, never hand-edit); `hosts/live.nix` is the shared installer-ISO base (minimal GNOME debloat + recovery tools + `install-nix` + embedded flake, never built directly), `hosts/live-{desktop,laptop}.nix` add per-host quirks (NVIDIA for desktop, `isoImage.edition`).
- **modules/** — every feature as a module, auto-imported by folder: `modules/system/` (boot, hardware, security, desktop, apps) and `modules/home/` (theme, desktop, GUI apps, CLI tools, OS integration).
- **packages/** — everything built in-repo behind one overlay (`packages/default.nix`, used as `pkgs.<name>`): `builds/` (compiled: `sf-pro-nerd`, `spun`, `ollama-cuda`, `hyprsaver`, `hyprpolkitagent`) + `scripts/` (shell helpers: `hypr-float-toggle`, `wifi-menu`, `bluetooth-menu`, `rofi-keybinds`, `rofi-nixosrebuild`, `usb-sound` — PipeWire fan-out player for USB plug/unplug effects, called from udev).
- **assets/** — wallpapers (one-word names) + sounds (`assets/sounds/usb-in.mp3`, `usb-out.mp3` — USB stick/drive plug/unplug effects, played via `modules/system/hardware/usb-sound.nix` udev rules) + Ghostty cursor-warp shader (`assets/ghostty/shaders/cursor_warp.glsl`, wired in `apps/terminal.nix`). `spun` (PolyForm Noncommercial CD-shaped player, local playback + 3D players, vinyl default patched in `postPatch`).

Repository structure
-------------------
```
flake.nix + flake.lock          # inputs, mkHost wiring, formatter
home.nix                        # single home-manager entrypoint (imports modules/home)
lib/
  theme.nix                     # palette, fonts, cursor, display — ONLY place for #1d2021, a99f8f, Martian Mono (terminal), Bibata-Modern-Ice 24, 1920x1080
  mkHost.nix                    # thin wiring: common + hosts/<name>.nix + home-manager (skipped with withHome=false for ISOs) + overlays
  overlays.nix                  # every overlay: upstream (apple-fonts, plymouth, install-nix) + packages/ + hyprtoolkit pin
  autoimport.nix                # manifest helper — drop a .nix in the right folder and it's live
hosts/
  common.nix                    # shared: timeZone, locale, NM, user groups
  desktop.nix                   # identity + NVIDIA early-KMS + useOSProber + /mnt/ssd + ollama desktop-only (GRUB base in modules/system/boot.nix)
  laptop.nix
  live.nix                      # installer-ISO shared base (minimal GNOME + recovery + install-nix + /iso/dotfiles, never built directly — no modules/system import)
  live-{desktop,laptop}.nix     # installer ISOs (import live.nix; desktop adds NVIDIA, each sets isoImage.edition)
  hardware/{desktop,laptop}.nix # generated scans — don't hand-edit, regenerate with nixos-generate-config
modules/
  system/                       # system-level, auto-imported (default.nix is 3 lines, never hand-edited)
    {boot,nix,shell}.nix        # grub text-mode (splashImage=null, no NixOS logo) 1920x1080, plymouth mac-style splash (quiet splash), nix/cachix, shell aliases (environment.shellAliases → bash+zsh) + zsh/ohMyZsh
    hardware/{audio,bluetooth,printing,storage,usb-sound}.nix  # rtkit, bluetooth, avahi/printing, udisks2, usb-sound = udev add/remove rules (sd*[!0-9] on usb) → pkgs.usb-sound (mpv fan-out to /run/user/*)
    security/{polkit,keyring}.nix                    # security.polkit (daemon + pkexec setuid wrapper), gnome-keyring
    virtualisation.nix          # docker + libvirt/QEMU-KVM (qemu_kvm, swtpm, spiceUSBRedirection) + virt-manager, groups docker/libvirtd/kvm
    desktop/{hyprland,fonts,login}.nix  # Hyprland+UWSM+portals, fonts, login.nix = greetd/tuigreet TTY greeter + hyprlock PAM
    apps/base.nix                 # base = environment.systemPackages (ollama lives in hosts/desktop.nix, pinned CUDA pkgs.ollama-cuda)
  home/                         # user-level (home-manager), auto-imported
    theme/{gtk,cursor}.nix      # gtk+qt+dconf merged, cursor — theme via extraSpecialArgs
    desktop/                    # everything graphical: hyprland/ (only multi-file feature: default+settings+keybinds+window-rules+autostart, Lua, systemd.enable=false — UWSM owns session), waybar.{nix,css}, wallpaper.nix (walt terminal picker + hyprpaper, ghostty.walt 900x650 float), dunst/hypridle/hyprlock/hyprshot/hyprsaver/hyprpolkitagent/rofi.nix (hyprpolkitagent = minimal Allow:+input prompt on translucent dark card, dimmed surroundings, no buttons — Enter/Escape)
    apps/{terminal,opencode,spicetify,spun,typora}.nix  # GUI programs; terminal = ghostty + cursor-warp shader (absolute custom-shader path, animation=always); opencode = tui.json theme + nixos-dotfiles skill (rbld/update/pkexec/hosts, deployed to ~/.config/opencode/skills/)
    cli/{eza,git,github}.nix    # terminal tools (not GUI apps); eza also owns HM programs.bash aliases so ls/ll/la work inside nix-shell (skips /etc/bashrc, sources ~/.bashrc)
    system/{packages,xdg}.nix   # packages = home.packages set (nixpkgs list + pkgs.<script>); xdg = mimeApps (PDF → Papers, images → feh)
packages/                       # everything built in-repo, one overlay (packages/default.nix → pkgs.<name>)
  builds/{hyprsaver,hyprpolkitagent,ollama,sf-pro-nerd,spun}.nix  # hyprpolkitagent: v0.2.0 (nixpkgs ships themeless 0.1.3) + pinned hyprtoolkit (needs abseil-cpp) + minimal Allow:-only Dialog.cpp patch (transparent, no buttons/details); sf-pro-nerd: custom 7-font Display subset, handles both Apple DMG layouts (Payload~ directly or via SFProFontsPackage.pkg) with 7z -tcpio
  scripts/{hypr-float-toggle,wifi-menu,bluetooth-menu,rofi-keybinds,rofi-nixosrebuild,usb-sound}.nix
assets/wallpaper/               # one-word names only
assets/sounds/{usb-in,usb-out}.mp3  # USB stick/drive plug/unplug effects (see system/hardware/usb-sound.nix)
assets/ghostty/shaders/cursor_warp.glsl  # Neovide-like cursor trail (see apps/terminal.nix)
assets/opencode/skills/nixos-dotfiles/SKILL.md  # agent skill for this system (rbld/update/pkexec/hosts/layout, see apps/opencode.nix)
```

How it fits together
-------------------
1. `flake.nix` declares `desktop`, `laptop`, `live-desktop`, `live-laptop` via `lib/mkHost.nix` (ISOs add `installation-cd-graphical-calamares-gnome.nix` + `withHome = false`).
2. `mkHost` injects `hosts/common.nix`, `hosts/<name>.nix`, `home-manager` (user env from `home.nix`, with `extraSpecialArgs`: `inputs`, `osConfig`, `theme`, `repoRoot` — skipped for ISOs so the squashfs stays minimal), and `lib/overlays.nix` (upstream + `packages/` + `hyprtoolkit` pin; the `install-nix` overlay puts the guided installer on the ISO).
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

# build installer ISOs (minimal GNOME + Calamares + recovery tools)
nix build .#nixosConfigurations.live-desktop.config.system.build.isoImage
nix build .#nixosConfigurations.live-laptop.config.system.build.isoImage

# switch via Rofi (Super+Shift+R) or CLI
sudo nixos-rebuild switch --flake .#desktop
```

Boot a live ISO, then install this system from the embedded flake:
```bash
sudo install-nix
# guided: pick drive + host, auto-partitions, refreshes hardware UUIDs, runs nixos-install
# manual fallback: sudo nixos-install --flake /iso/dotfiles#desktop  (or #laptop)
```
Fully online: the installer evaluates the embedded flake and fetches the target closure, so network is required.

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
- Waybar `network` is icon-only (`{icon}` wifi / `󰌗` ethernet in `desktop/waybar.nix`); `format-disconnected` stays icon-only, `bluetooth` sits right of `network`.
- Wallpapers are one-word (`road.png`, `dock.jpg`), deployed from `assets/wallpaper/` to `~/.config/wallpapers/`; `Super+Shift+W` opens `walt` (fast terminal picker, `ghostty --class=ghostty.walt -e walt`, hyprpaper backend), boot runs `walt random` else `road.png` via hyprpaper; Ghostty cursor-warp shader lives in `assets/ghostty/shaders/cursor_warp.glsl` (deployed to `~/.config/ghostty/shaders/`, `custom-shader-animation = always`); `satoshi.zip` stays deleted as unused — don't re-add without wiring.
- USB sounds are one-word too (`assets/sounds/usb-in.mp3`, `usb-out.mp3`); `modules/system/hardware/usb-sound.nix` fires on whole-disk `sd*[!0-9]` add/remove under `SUBSYSTEMS=="usb"` (one sound per stick, NVMe/SATA ignored) and `pkgs.usb-sound` (see `packages/scripts/usb-sound.nix`) plays the effect on every `/run/user/*` PipeWire session via `runuser` + `mpv` (backgrounded, udev-safe).

Agent guide: `AGENTS.md` — must be updated alongside `README.md` after every structural change; bump `Last updated: YYYY-MM-DD HH:MM UTC` to today.

License: MIT
