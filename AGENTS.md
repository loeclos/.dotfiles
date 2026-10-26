# AGENTS.md — Contributor & Agent Guide for loeclos/.dotfiles

> **Read this first.** This repo is a declarative NixOS flake that builds `desktop`, `laptop`, and `live-{desktop,laptop}` installer ISOs from one source of truth. Follow the structure, do the least change that works, and keep docs in sync.

## 1. Quick Use

```bash
# enter dir
cd ~/.dotfiles

# check eval (no build) — must pass before push
nix flake check --no-build

# format (2-space, nixfmt-rfc-style) — opt-in, preserves current style
nix fmt

# build without switching (dry)
sudo nixos-rebuild build --flake .#desktop
sudo nixos-rebuild build --flake .#laptop

# build installer ISOs (minimal GNOME + Calamares + recovery tools)
nix build .#nixosConfigurations.live-desktop.config.system.build.isoImage
nix build .#nixosConfigurations.live-laptop.config.system.build.isoImage

# switch
sudo nixos-rebuild switch --flake .#desktop

# update inputs (pin in flake.lock)
nix flake update
# or single: nix flake lock --update-input nixpkgs
```

Wallpapers live in `assets/wallpaper/` as one-word names (`road.png`, `flower.jpg`, `dock.jpg` … `image.png` deleted), deployed to `~/.config/wallpapers/` by `modules/home/desktop/wallpaper.nix`. Boot runs `walt random` (hyprpaper backend), else `road.png` (`services.hyprpaper` in `modules/home/desktop/wallpaper.nix`). Add new wallpapers as one word (`forest.jpg`, `lake.png`).
Sounds live in `assets/sounds/` as one-word names (`usb-in.mp3`, `usb-out.mp3`), played on USB stick/drive plug/unplug by `modules/system/hardware/usb-sound.nix` (udev `sd*[!0-9]` on `SUBSYSTEMS=="usb"` → `pkgs.usb-sound` fan-out to `/run/user/*` via mpv).

## 2. Architecture (Where Things Go)

```
flake.nix + flake.lock          # inputs, mkHost wiring, formatter
home.nix                        # single home-manager entrypoint (imports modules/home)
lib/
  theme.nix                     # palette, fonts, cursor, display — ONLY place for #1d2021, a99f8f, Martian Mono (terminal default; SFMono kept as fallback), Bibata-Modern-Ice 24, 1920x1080
  mkHost.nix                    # thin wiring: common + hosts/<name>.nix + home-manager (skipped with withHome=false for ISOs) + overlays (no feature config here)
  overlays.nix                  # every overlay: upstream (apple-fonts, plymouth-theme, install-nix) + packages/ + hyprtoolkit pin
  autoimport.nix                # manifest helper — drop a .nix in the right folder and it's live
hosts/
  common.nix                    # shared: timeZone, locale, NM, user groups
  {desktop,laptop}.nix          # installed machines (desktop holds NVIDIA early-KMS + useOSProber + /mnt/ssd NTFS mount + ollama desktop-only inline; disk layout via hardware UUID scans, not disko)
  live.nix                      # installer-ISO shared base (minimal GNOME + recovery + install-nix + /iso/dotfiles, never built directly — no modules/system import)
  live-{desktop,laptop}.nix     # installer ISOs (import live.nix; desktop adds NVIDIA, each sets isoImage.edition)
  hardware/{desktop,laptop}.nix # generated scans — don't hand-edit, regenerate with nixos-generate-config (never imported by live-* ISOs)
modules/
  system/                       # system-level, auto-imported (default.nix is 3 lines, never hand-edited)
    {boot,nix,shell}.nix        # grub text-mode (splashImage=null, no NixOS logo) 1920x1080, plymouth mac-style splash (quiet splash), nix/cachix, shell aliases (environment.shellAliases → bash+zsh) + zsh/ohMyZsh
    hardware/{audio,bluetooth,printing,storage,usb-sound}.nix  # NOT services/: hardware is hardware (storage = udisks2, was services/disk.nix; usb-sound = udev add/remove rules for USB sticks/drives → pkgs.usb-sound fan-out to /run/user/* via mpv)
    security/{polkit,keyring}.nix                    # NOT services/: security is security (polkit = daemon + pkexec setuid wrapper)
    virtualisation.nix          # top level, not services/: owns docker + libvirt/QEMU-KVM (qemu_kvm, swtpm, spiceUSBRedirection) + virt-manager, groups docker/libvirtd/kvm
    desktop/{hyprland,fonts,login}.nix  # login.nix = greetd/tuigreet TTY greeter (Hyprland via UWSM) + hyprlock PAM — one purpose, one file, no login/ subfolder
    apps/base.nix                 # base = environment.systemPackages (vague system.nix renamed); ollama lives in hosts/desktop.nix (pkgs.ollama-cuda, desktop-only CUDA)
  home/                         # user-level (home-manager), auto-imported
    theme/{gtk,cursor}.nix      # gtk+qt+dconf merged, cursor — theme via extraSpecialArgs
    desktop/                    # EVERYTHING graphical lives here (hyprland is not a sibling): dunst/hypridle/hyprlock/hyprshot/hyprsaver/hyprpolkitagent/rofi/wallpaper/waybar.{nix,css} + hyprland/ (only folder that earns depth: default+settings+keybinds+window-rules+autostart+gestures)
    apps/{terminal,opencode,spicetify,spun,typora}.nix  # GUI programs only (terminal = ghostty, also hosts `walt` TUI via ghostty.walt float 900x650); spun → pkgs.spun; typora + LaTeX-Typora-V2 theme; opencode → tui.json theme=cursor + nixos-dotfiles skill (rbld/update/pkexec/hosts, deployed to ~/.config/opencode/skills/)
    cli/{eza,git,github}.nix    # terminal tools are NOT apps (was apps/shell-eza,vcs-git,vcs-github); eza also owns HM programs.bash aliases so ls/ll/la work inside nix-shell (which skips /etc/bashrc, sources ~/.bashrc)
    system/{packages,xdg}.nix   # OS integration, not apps: packages = home.packages set; xdg = mimeApps
packages/                       # everything built in-repo, one overlay (packages/default.nix → pkgs.<name>, no callPackage chains in modules)
  builds/{sf-pro-nerd,hyprsaver,hyprpolkitagent,ollama,spun}.nix  # sf-pro-nerd: custom 7-font Display subset (pkgName SFProFontsPackage.pkg, skip 2nd 7z when Payload~ already extracted, 7z -tcpio for cpio Payload); spun: PolyForm Noncommercial flake=false, local playback (no Cider), vinyl default patched in postPatch; hyprpolkitagent: v0.2.0 (nixpkgs ships config-less Qt 0.1.3) + pinned hyprtoolkit (needs abseil-cpp) + minimal Allow:-only Dialog.cpp patch (postPatch cp ./hyprpolkitagent-dialog.cpp, transparent window, no buttons/details); ollama exposed as ollama-cuda (never shadow pkgs.ollama)
  scripts/{hypr-float-toggle,wifi-menu,bluetooth-menu,rofi-keybinds,usb-sound}.nix
assets/wallpaper/               # one-word names only
assets/sounds/{usb-in,usb-out}.mp3  # USB stick/drive plug/unplug effects (see system/hardware/usb-sound.nix, one-word like wallpapers)
assets/ghostty/shaders/cursor_warp.glsl  # Neovide-like cursor trail (see apps/terminal.nix, via repoRoot — never a relative ../../assets path)
assets/opencode/skills/nixos-dotfiles/SKILL.md  # agent skill for this system (rbld/update/pkexec/hosts/layout, deployed by apps/opencode.nix via repoRoot)
```

Manifests `modules/system/default.nix` and `modules/home/default.nix` are 3-line auto-imports (`lib/autoimport.nix`) — never hand-edited. Rule: **depth must be earned** — one file = flat (no `waybar/waybar.nix`, no `quickshell/picker.nix`, no `login/` subfolder); a folder with its own `default.nix` is self-contained and its other `.nix` files are private helpers (only `desktop/hyprland/` earns this today).

## 3. Principles — How to Change

### 3.1 Least Change
Do the smallest diff that solves the task. Don't reformat the world, don't move files unless the structure demands it, don't add deps for a one-line fix. Prefer editing one file over touching five.

### 3.2 Clean Code
- `with pkgs;` for package *lists*, `pkgs.<name>` everywhere else. `callPackage` appears only in `packages/default.nix` (the one overlay) and once in `flake.nix` (pinned `sf-pro-nerd`) — never in modules. If you catch yourself writing `pkgs.callPackage ../...` in a module, add the package to `packages/` instead.
- No dead/commented blocks — use `git log` for history, not `# foo` leftovers.
- No duplicate constants — colors/fonts/resolutions go in `lib/theme.nix`, not hardcoded `rgb(a99f8f)` in 5 places. Hyprland gaps/borders, bootloader `resolution`, terminal font, dunst colors all derive from `theme`.
- Helpers over copy-paste: `mkBind`/`mkExec` in `desktop/hyprland/keybinds.nix:4`, `mkFloatRule` in `window-rules.nix:4`, `"*" = lib.range 1 9` (monitor-keyed persistent workspaces) in `desktop/waybar.nix`.

### 3.3 Follow Structure — Fit Into Current Categories, Otherwise Create New
1. Search existing category first:
   - System theme/display → `lib/theme.nix` + `modules/system/{boot,nix,shell}.nix`
   - Hardware (audio/bluetooth/printing/storage) → `modules/system/hardware/*` (never `services/`)
   - Security (polkit/keyring) → `modules/system/security/*` (never `services/`)
   - Desktop compositor/lock/bar/picker → `modules/home/desktop/*` (hyprland lives here, nowhere else)
   - GUI programs → `modules/home/apps/*`; terminal tools → `modules/home/cli/*`; OS integration/package set → `modules/home/system/*`
   - Something we build (derivation or shell script) → `packages/{builds,scripts}/` + expose as `pkgs.<name>` in `packages/default.nix`
2. If nothing fits, create a new file **inside the closest existing folder** (e.g., `modules/system/hardware/mything.nix`), not a new top-level folder, unless you need a full multi-file feature — then create a folder with its own `default.nix` (like `desktop/hyprland/`). No manifest edits needed either way: auto-import picks it up.
3. New hosts: add `hosts/<name>.nix` (import `hardware/<name>.nix` + `../modules/system`), then wire in `flake.nix` via `mkHost { hostname = "<name>"; }`. See `lib/mkHost.nix:1` for overlay/home-manager injection — don't duplicate that block. Generated scans live in `hosts/hardware/` — regenerate with `nixos-generate-config`, don't hand-edit. Live ISOs are the exception: `hosts/live.nix` is a shared base (no `../modules/system`, no hardware scans), `hosts/live-{desktop,laptop}.nix` import it and add only ISO quirks (NVIDIA for desktop, `isoImage.edition`), wired with `withHome = false` + `installation-cd-graphical-calamares-gnome.nix` in `flake.nix`.

### 3.4 File Naming
- `modules/system/apps/base.nix` = `environment.systemPackages`, `modules/home/system/packages.nix` = `home.packages` — extend those lists, don't create new package files.
- Use kebab-case, one-word where possible (wallpapers already normalized). `default.nix` exists only for the two auto-import manifests + self-contained feature folders; feature files are `hypridle.nix`, `virtualisation.nix`, not `base/` subfolders.

### 3.5 Task Tracking
- Always create a `TodoWrite` todo list at the start of *every* task — even one-liners / "trivial" fixes. Break work into steps, keep exactly one `in_progress` at a time, mark completed as you go. No execution without todos.

## 4. Making Changes — Checklist

1. **Scope:** Host-specific? Edit `hosts/<name>.nix` (hardware quirks only). Shared? Edit `hosts/common.nix` or `modules/*`. Theme? Edit `lib/theme.nix` once.
2. **Edit:** Keep `configType = "lua"` for Hyprland (`desktop/hyprland/default.nix`) — newer Hyprland requires it. Use `theme`/`repoRoot` via `extraSpecialArgs` (injected by `lib/mkHost.nix`), so home modules take `{ theme, ... }:` / `{ repoRoot, ... }:` — never `import ../../../lib/theme.nix`, never a relative `../../assets/...` path.
3. **Scripts:** If you add a `writeShellScriptBin`, put it in `packages/scripts/<name>.nix` and expose it as `pkgs.<name>` in `packages/default.nix` — consumers reference the attr, never `callPackage` it. Same for compiled derivations → `packages/builds/<name>.nix`.
4. **Wallpapers:** One word, lowercase, keep extension. Boot default `road.png` lives in `modules/home/desktop/wallpaper.nix` (`services.hyprpaper.settings.wallpaper`) — update there if changing default.
5. **Todos:** Create a `TodoWrite` todo list at the start of *every* task — even one-liners. Keep exactly one `in_progress`, mark completed as you go.

## 5. Verification (Do This Before PR)

```bash
git add -A
nix flake check --no-build   # must say "all checks passed!" (formatter warning ok)
# optional build dry-run
sudo nixos-rebuild build --flake .#desktop --dry-run
```

If you moved files, use `git mv` to preserve history. Ensure `lib/theme.nix` consumers use `theme.palette`/`theme.mkRgb` not hardcoded hex.

## 6. Docs — MANDATORY / BLOCKING — YOU MUST UPDATE BOTH DOCS AFTER *EVERY* CHANGE

> **BLOCKING REQUIREMENT — PRs WILL BE REJECTED AND BUILDS CONSIDERED BROKEN IF DOCS ARE STALE. NO EXCEPTIONS.**
> **If you touched code, you touch docs. No docs = incomplete change. Do not skip even for one-line / "trivial" fixes.**

**STOP — DO NOT SKIP THIS SECTION. For *EVERY* change you must:**

- **`README.md` — REQUIRED** — keep `Repository structure` tree, `What this repo contains`, `How it fits together`, and `Build & deploy` in sync with the actual `flake.nix` / `lib/mkHost.nix` / `modules/*/default.nix` state. **MUST** bump `- Last updated: YYYY-MM-DD HH:MM UTC` to today (UTC) on every commit — today is `2026-08-27 00:00 UTC` as baseline, update to the current date and time. Date without time is rejected.
- **`AGENTS.md` (this file) — REQUIRED** — if you add/rename/move a category or file, change the `theme`/`mkHost` contract, or alter the wallpaper/derivation/script layout, update sections 2 and 3 immediately. Keep the `lib/theme.nix` palette/fonts table accurate. Stale AGENTS.md causes future agents/humans to make wrong changes.
- **`TodoWrite` — REQUIRED** — create a todo list at the start of *every* task (even one-liners) and keep it updated. Keep exactly one `in_progress` at a time. No todos = incomplete workflow.

**NEVER SHIP — not even a 1-line fix — WITHOUT ALL FOUR (reviewers must request changes if any is missing):**
```bash
# 1. README.md: update tree + Last updated: YYYY-MM-DD HH:MM UTC  ← REQUIRED
# 2. AGENTS.md: update architecture/categories/principles ← REQUIRED
# 3. TodoWrite: todos created and tracked for every task  ← REQUIRED
# 4. nix flake check --no-build passes                   ← REQUIRED
```
**Missing docs = change is NOT DONE. Treat this as a build failure.**

## 7. Common Pitfalls

- Adding `hardware.bluetooth` in two places — it lives only in `system/hardware/bluetooth.nix`.
- Using `custom/seperator` — it was renamed to `custom/separator` (breaking). Don't reintroduce the typo.
- Leaving `satoshi.zip` blobs — deleted as unused. Don't re-add without wiring in `system/desktop/fonts.nix`.
- Ghostty shaders: only `assets/ghostty/shaders/cursor_warp.glsl` is kept, deployed via `xdg.configFile` in `apps/terminal.nix` (source via `repoRoot`, absolute `custom-shader` path + `custom-shader-animation = always`). Never use a relative `../../assets/...` path (Ghostty resolves it against its CWD, so it silently breaks) and don't re-add the other deleted shaders without wiring them the same way.
- Forgetting `extraSpecialArgs` — home modules that need colors/fonts/assets must declare `{ theme, ... }:` / `{ repoRoot, ... }:` (injected by `lib/mkHost.nix`).
- GRUB lives only in `system/boot.nix` (`splashImage = null` = text mode, overrides NixOS default logo) — don't duplicate `boot.loader.grub` per host (desktop keeps only `useOSProber`). Upstream GRUB has no `xhci` driver, so keyboards must use native USB2 ports under Ultra Fast Boot; mouse in GRUB menu is unsupported by design.
- Boot splash lives only in `system/boot.nix` (`boot.plymouth` with `theme = "mac-style"`). The `plymouth-theme` flake input exposes `pkgs.mac-style-plymouth` via its overlay (wired in `lib/overlays.nix`) — don't vendor a local derivation or duplicate `themePackages` per host.
- Wallpaper picker is `walt` (flake input `github:gitfudge0/walt`, system package in `modules/system/apps/base.nix`, hyprpaper backend in `modules/home/desktop/wallpaper.nix`). `SUPER+SHIFT+W` runs `ghostty --class=ghostty.walt -e walt` (float `ghostty.walt` 900x650 in `desktop/hyprland/window-rules.nix`); autostart runs `hyprpaper` + `walt random`. `~/.config/wallpapers` is a store symlink (deployed from `assets/wallpaper/`) — first `walt` run, point it at that dir. Don't reintroduce `awww-daemon`/`mpvpaper`/quickshell-picker (slow, video-only value-add) unless speed no longer matters.
- Waybar workspaces must use `format = "{name}"` + `sort-by = "name"` + `persistent-only = true` (see `desktop/waybar.nix`) — Hyprland 0.56 dropped `id` from its workspaces IPC, so Waybar sees every real workspace as id 0: `{id}` renders as `0` and real workspaces duplicate the persistent buttons. Don't revert to `{id}` / drop `persistent-only` until upstream Waybar handles the id-less IPC.
- Waybar network is icon-only (`desktop/waybar.nix`): `{icon}` for wifi, `󰌗` for ethernet, `format-disconnected` icon-only, `bluetooth` sits right of `network` in `modules-right`. Don't re-add `{bandwidthDownBytes}/{bandwidthUpBytes}` (plus `interval = 2` + `:>` fixed-width) unless speeds are wanted back in the bar.
- Hyprland media/brightness controls live in `desktop/hyprland/keybinds.nix`: F2/F3 and `XF86AudioLowerVolume`/`XF86AudioRaiseVolume` adjust volume by 5; `XF86AudioMute` toggles mute; F5/F6 and `XF86MonBrightnessDown`/`XF86MonBrightnessUp` adjust brightness by 5%. Keep hardware keys paired with the function-key binds.
- QEMU/OVMF: upstream removed the `virtualisation.libvirtd.qemu.ovmf` submodule (all OVMF images ship with QEMU by default) — don't re-add an `ovmf = { enable = ...; packages = ...; }` block, it fails `nix flake check`. UEFI guests work out of the box; only `swtpm.enable` needs setting for TPM.
- Privilege escalation lives in `system/security/polkit.nix` (`security.polkit.enable` + `enablePkexecWrapper` → `/run/wrappers/bin/pkexec`; enabling polkit alone is NOT enough, the wrapper is required since store binaries can't be setuid). The GUI agent is `services.hyprpolkitagent` (`modules/home/desktop/hyprpolkitagent.nix`, HM user service under UWSM-owned `graphical-session.target` — don't exec it from `desktop/hyprland/autostart.nix`: the binary lives in `libexec/`, not `bin/`, so it's not on PATH). Agents (e.g. opencode) run password-protected commands via `pkexec` — the GUI prompt appears on the user's screen, no TTY needed: `pkexec nixos-rebuild switch --flake /home/loeclos/.dotfiles#desktop`, `pkexec nix-collect-garbage -d`, `pkexec <anything-root-needs>`. Always use the absolute flake path (relative `.` fails: pkexec runs as root, which resolves `.` against `/root`, not the repo). A dismissed prompt reports `Not authorized / This incident has been reported` — expected, not a broken setup.
- hyprpolkitagent version skew: nixpkgs ships Qt-based 0.1.3 (no `hyprpolkitagent.conf`/`hyprtoolkit.conf` support, unthemable) — the overlay pins v0.2.0 (hyprtoolkit, config + theming) plus the exact `hyprtoolkit` rev from its flake.lock (needs `abseil-cpp` added to the override's `buildInputs`). Don't drop the pins until nixpkgs catches up; v0.2.0 also fixes session resolution for headless (`User.Display` fallback), which agent-invoked pkexec relies on. Upstream v0.2.0 hardcodes a full card (title/identity/message/$-box/buttons/details/background) with no config knobs to hide them — the minimal floating prompt (`Allow: <command>` + input only, transparent window, Enter submits / Escape cancels) lives in `packages/builds/hyprpolkitagent-dialog.cpp` (copied over `src/ui/Dialog.cpp` in `postPatch`); home `modules/home/desktop/hyprpolkitagent.nix` keeps `background = 0x00000000` + compact `420x160` geometry (the patch draws its own translucent bg0 card at 80% so white text reads on any wallpaper) and the window rule dims the screen around it (`dim_around`, no blur/shadow). Agents prefix privileged commands with `pkexec` directly (GUI prompt every time, no credential caching unlike sudo) — never add a wheel→`YES` polkit rule or `NOPASSWD` sudo rule to "fix" prompts.
- Live ISOs: `hosts/live.nix` must never import `../modules/system` (GRUB/greetd/Hyprland conflict with the installer-cd stack — ISO would set `boot.loader.grub.enable = true` and drag the full desktop into the squashfs). `live-{desktop,laptop}.nix` must never import `hardware/<name>.nix` (filesystem UUIDs describe the installed machine, not bootable media) — duplicate only the driver bits (NVIDIA for desktop). ISOs need `withHome = false` in `flake.nix` or the Hyprland home env bloats the image. The flake is embedded at `/iso/dotfiles` (`isoImage.contents` in `live.nix`) — install via `sudo install-nix` (guided: picks drive, partitions, refreshes hardware UUIDs, runs nixos-install; lives in `hosts/live.nix` systemPackages via the `install-nix` overlay), manual fallback `sudo nixos-install --flake /iso/dotfiles#desktop` (or `#laptop`), never via Calamares (which installs generic NixOS).
- USB sounds live in `system/hardware/usb-sound.nix` (udev `ACTION=="add/remove"`, `SUBSYSTEM=="block"`, `KERNEL=="sd*[!0-9]"`, `SUBSYSTEMS=="usb"` → `pkgs.usb-sound` with `inputs.self + "/assets/sounds/usb-{in,out}.mp3"`). Whole-disk `sd*[!0-9]` = one sound per stick (partitions like `sda1` would double-fire); `SUBSYSTEMS=="usb"` (parent walk) keeps NVMe/SATA silent on both add and remove (where `ENV{ID_BUS}` can be missing). udev runs as root with no PipeWire, so `pkgs.usb-sound` (`packages/scripts/usb-sound.nix`) fans out to every `/run/user/<uid>=1000+` via `runuser` + `mpv --no-video --really-quiet`, backgrounded (`&`) so udev never blocks — don't play inline, don't use `paplay`/`aplay` (no mp3 decode), don't match `DEVTYPE=="disk"` alone (unreliable on remove).

## 8. References

- Entrypoint: `flake.nix` `nixosConfigurations`
- Theme source: `lib/theme.nix:1`
- Host helper: `lib/mkHost.nix:1`
- Hyprland split: `modules/home/desktop/hyprland/{settings,keybinds,window-rules,autostart,gestures}.nix`
- Waybar separator & persistent workspaces: `modules/home/desktop/waybar.nix`
- Login + lock: `modules/system/desktop/login.nix` (greetd + tuigreet TTY greeter, `/run/current-system/sw/bin/uwsm start hyprland-uwsm.desktop`, + hyprlock PAM) + home `modules/home/desktop/hyprlock.nix` (blurred bg + centered password field, `hypridle` lock_cmd)
- UWSM owns the session: home `modules/home/desktop/hyprland/default.nix` must keep `systemd.enable = false` — HM integration activates `graphical-session.target` early and `uwsm start` aborts.
- Wallpaper default + picker: `modules/home/desktop/wallpaper.nix` (hyprpaper `road.png` + `walt`), `walt` binary from `inputs.walt` (system package in `modules/system/apps/base.nix`)
- Live ISOs: `hosts/live.nix` (shared GNOME + recovery base) + `hosts/live-{desktop,laptop}.nix` (per-host quirks), wired in `flake.nix` with `installation-cd-graphical-calamares-gnome.nix` + `withHome = false`

Keep it lean, keep it sorted, keep docs current.
