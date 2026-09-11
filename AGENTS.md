# AGENTS.md — Contributor & Agent Guide for loeclos/.dotfiles

> **Read this first.** This repo is a declarative NixOS flake that builds `desktop`, `laptop`, and `live` hosts from one source of truth. Follow the structure, do the least change that works, and keep docs in sync.

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
sudo nixos-rebuild build --flake .#live

# switch (or Super+Shift+R → rofi-nixosrebuild)
sudo nixos-rebuild switch --flake .#desktop

# update inputs (pin in flake.lock)
nix flake update
# or single: nix flake lock --update-input nixpkgs
```

Wallpapers live in `assets/wallpaper/` as one-word names (`road.png`, `flower.jpg`, `dock.jpg` … `image.png` deleted), deployed to `~/.config/wallpapers/` by `modules/home/desktop/quickshell/wallpaper-picker.nix`. Boot restores the last wallpaper, else `road.png` (`wallpaper-picker --restore` in `pkgs/scripts/wallpaper-picker.nix`). Add new wallpapers as one word (`forest.jpg`, `lake.png`).

## 2. Architecture (Where Things Go)

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
    apps/{ghostty.nix,shell-eza.nix,spicetify.nix,user.nix,vcs-git.nix,vcs-github.nix,xdg.nix} # xdg.nix: mimeApps
derivations/{sf-pro-nerd.nix,hyprsaver.nix,ollama.nix,quickshell-multimedia.nix}
pkgs/scripts/{hypr-float-toggle.nix,wifi-menu.nix,bluetooth-menu.nix,rofi-keybinds.nix,rofi-nixosrebuild.nix,screen-recorder.nix,wallpaper-picker.nix}
assets/wallpaper/               # one-word names only
users/loeclos/home.nix
```

Manifests `modules/nixos/default.nix` and `modules/home/default.nix` are the import lists — keep sorted and grouped by header (`# core`, `# hardware`, etc.).

## 3. Principles — How to Change

### 3.1 Least Change
Do the smallest diff that solves the task. Don't reformat the world, don't move files unless the structure demands it, don't add deps for a one-line fix. Prefer editing one file over touching five.

### 3.2 Clean Code
- No `with pkgs;` mixing `pkgs.qemu` vs `qemu` — either `with pkgs; [ ghostty eza ]` consistently or explicit `pkgs.` everywhere. Current code uses `with pkgs;` for package lists but `pkgs.callPackage` outside — keep that convention.
- No dead/commented blocks — use `git log` for history, not `# foo` leftovers.
- No duplicate constants — colors/fonts/resolutions go in `lib/theme.nix`, not hardcoded `rgb(a99f8f)` in 5 places. Hyprland gaps/borders, bootloader `resolution`, ghostty font, dunst/hyprlock colors all derive from `theme`.
- Helpers over copy-paste: `mkBind`/`mkExec` in `hyprland/keybinds.nix:4`, `mkFloatRule` in `window-rules.nix:4`, `lib.genAttrs (map toString (lib.range 1 9))` in `waybar.nix:48`, `lib.genAttrs` in `rofi-nixosrebuild.nix:6`.

### 3.3 Follow Structure — Fit Into Current Categories, Otherwise Create New
1. Search existing category first:
   - System theme/display → `lib/theme.nix` + `modules/nixos/core/*`
   - Hardware (audio/bluetooth/printing/disk) → `modules/nixos/hardware/*` or `services/*`
   - Desktop compositor/lock/bar → `modules/home/desktop/*` or `hyprland/*`
   - User apps/packages → `modules/home/apps/*` or `modules/nixos/apps/*`
   - Shell helpers → `pkgs/scripts/*`
2. If nothing fits, create a new file **inside the closest existing folder** (e.g., `modules/nixos/services/mything.nix`), not a new top-level folder, unless you need a full feature group — then create a folder with its own `default.nix` (like `hyprland/`).
3. Add the new file to the appropriate `default.nix` manifest in sorted order. Keep manifests alphabetical within each group.
4. New hosts: add `hosts/<name>/default.nix` (import `hardware-configuration.nix` + needed `modules/nixos` bits), then wire in `flake.nix:112` via `mkHost { hostname = "<name>"; }`. See `lib/mkHost.nix:1` for overlay/home-manager injection — don't duplicate that block.

### 3.4 File Naming
- `modules/nixos/apps/system.nix` = `environment.systemPackages`, `modules/home/apps/user.nix` = `home.packages` — don't create new `packages.nix`.
- Use kebab-case, one-word where possible (wallpapers already normalized). No `default.nix` except manifests; feature files are `hyprlock.nix`, `virtualisation.nix`, not `base.nix`.

### 3.5 Task Tracking
- Always create a `TodoWrite` todo list at the start of *every* task — even one-liners / "trivial" fixes. Break work into steps, keep exactly one `in_progress` at a time, mark completed as you go. No execution without todos.

## 4. Making Changes — Checklist

1. **Scope:** Host-specific? Edit `hosts/<host>/default.nix` or `hosts/<host>/nvidia.nix`. Shared? Edit `hosts/common.nix` or `modules/*`. Theme? Edit `lib/theme.nix` once.
2. **Edit:** Keep `configType = "lua"` for Hyprland (`hyprland/default.nix:22`) — newer Hyprland requires it. Use `theme` via `extraSpecialArgs` (injected by `lib/mkHost.nix:24`), so home modules take `{ theme, ... }:` not `import ../../../lib/theme.nix`.
3. **Scripts:** If you add a `writeShellScriptBin`, put it in `pkgs/scripts/<name>.nix` and expose via `apps/user.nix:59` (`pkgs.callPackage ../../../pkgs/scripts/<name>.nix`), don't inline in `user.nix`.
4. **Wallpapers:** One word, lowercase, keep extension. Boot default `road.png` lives in `pkgs/scripts/wallpaper-picker.nix` (`cmd_restore`) — update there if changing default.
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

- **`README.md` — REQUIRED** — keep `Repository structure` tree, `What this repo contains`, `How it fits together`, and `Build & deploy` in sync with the actual `flake.nix:112` / `lib/mkHost.nix` / `modules/*/default.nix` state. **MUST** bump `- Last updated: YYYY-MM-DD HH:MM UTC` to today (UTC) on every commit — today is `2026-08-27 00:00 UTC` as baseline, update to the current date and time. Date without time is rejected.
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

- Adding `hardware.bluetooth` in two places — it lives only in `hardware/bluetooth.nix`.
- Using `custom/seperator` — it was renamed to `custom/separator` (breaking). Don't reintroduce the typo.
- Leaving `satoshi.zip`/`ghostty/shaders` blobs — they were deleted as unused (~6.2MB). Don't re-add without wiring them in `fonts.nix` or `ghostty.nix`.
- Forgetting `extraSpecialArgs.theme` — home modules that need colors/fonts must declare `{ theme, ... }:`.
- Wallpaper picker needs `awww-daemon` running (not hyprpaper — they fight over the wallpaper layer). No `python3` — online Wallhaven search is unsupported by design (Enter-in-search shows "Online search failed"). `~/.config/wallpapers` is a store symlink — the launcher `readlink -f`s it because `find -maxdepth` (upstream thumb sync) won't traverse a symlinked start dir.

## 8. References

- Entrypoint: `flake.nix:112` `nixosConfigurations`
- Theme source: `lib/theme.nix:1`
- Host helper: `lib/mkHost.nix:1`
- Hyprland split: `modules/home/hyprland/{settings,keybinds,window-rules,autostart}.nix`
- Waybar separator & persistent workspaces: `modules/home/desktop/waybar/waybar.nix:20,48`
- Wallpaper default + picker: `pkgs/scripts/wallpaper-picker.nix` (`cmd_restore`), module `modules/home/desktop/quickshell/wallpaper-picker.nix`

Keep it lean, keep it sorted, keep docs current.
