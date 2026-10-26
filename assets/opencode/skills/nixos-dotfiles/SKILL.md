---
name: nixos-dotfiles
description: Use when working on this NixOS flake at ~/.dotfiles, running nixos-rebuild, rbld, update, nix-shell, or pkexec. Covers hosts, aliases, privilege escalation, and repo layout.
---

# NixOS Dotfiles

This machine is declarative. Host config lives in `~/.dotfiles` (flake root,
user `loeclos`). Never edit `/etc/nixos/` directly — edit the flake, verify,
then rebuild.

## Hosts and flake

- Flake outputs (`flake.nix`): `nixosConfigurations.{desktop,laptop,live-desktop,live-laptop}` via `lib/mkHost.nix`.
- Daily drivers: `desktop` (NVIDIA RTX, early-KMS + `useOSProber` + `/mnt/ssd`), `laptop`.
- ISOs: `live-desktop` / `live-laptop` (minimal GNOME + Calamares, `withHome = false`, embed flake at `/iso/dotfiles`). Never import `modules/system` or `hardware/<name>.nix` into them.
- Hardware scans `hosts/hardware/*.nix` are generated (`nixos-generate-config`) — never hand-edit.
- Shared base: `hosts/common.nix` (timezone, locale, NetworkManager, user groups).

## Shell aliases (defined in `modules/system/shell.nix`)

That file configures zsh — it is NOT a `nix-shell` env. There are no per-project
`shell.nix` dev shells in this repo.

- `dots` → `cd ~/.dotfiles` (always run flake commands from here).
- `ls` / `ll` / `la` → `eza --icons` variants.
- `edit` → `sudo -e` (safe root file edit).
- `shell` → `nix-shell` (shorthand only).
- `rbld [target]` → `sudo nixos-rebuild switch --flake ~/.dotfiles#<target>`, defaults to `hostname`. Accepts `laptop`, `.#laptop`, `#laptop`. Sends a `notify-send` on done/fail, preserves exit code. Prefer `rbld` for interactive use.
- `update [input]` → no arg runs `nix flake update` (all inputs, cwd must be flake root); with arg runs `sudo nix flake update <input> --flake ~/.dotfiles`.

Ad-hoc dev envs: `nix-shell -p <pkg>` or `nix shell nixpkgs#<pkg>`. Do not create `shell.nix` files unless the user asks.

## Privilege escalation: pkexec, not sudo (for agents)

Interactive user uses `sudo`. Agents (opencode, headless, no TTY) MUST use
`pkexec` — it prompts via the GUI `hyprpolkitagent` (`services.hyprpolkitagent`,
pinned v0.2.0 + minimal `Allow:` prompt). Config in
`modules/system/security/polkit.nix` (`enablePkexecWrapper` required) +
`modules/home/desktop/hyprpolkitagent.nix`.

Rules:

- Always absolute flake path: `pkexec nixos-rebuild switch --flake /home/loeclos/.dotfiles#desktop`. Relative `.` fails (root resolves `.` as `/root`).
- Same for builds: `pkexec nixos-rebuild build --flake /home/loeclos/.dotfiles#desktop`, `pkexec nix-collect-garbage -d`.
- `pkexec` re-prompts every time by design (no credential caching). Never add a wheel→`YES` polkit rule or `NOPASSWD` sudo rule to "fix" prompts.
- Dismissed prompt = `Not authorized / This incident has been reported` — expected, not broken config.

## Edit → verify → rebuild loop

1. Scope: host quirk → `hosts/<name>.nix`. Shared system → `hosts/common.nix` or `modules/system/`. Graphical/compositor/app → `modules/home/`. Something built (derivation or `writeShellScriptBin`) → `packages/{builds,scripts}/` + expose as `pkgs.<name>` in `packages/default.nix` (single overlay). Assets → `assets/` referenced via `repoRoot + "/assets/..."`, never `../../` chains.
2. Conventions: `with pkgs;` for package lists, `pkgs.<name>` elsewhere. `callPackage` only in `packages/default.nix`. Theme colors/fonts/resolution only in `lib/theme.nix` (consumed via `extraSpecialArgs` as `{ theme, ... }:` / `{ repoRoot, ... }:`). Hyprland needs `configType = "lua"`.
3. Verify before rebuild:
   ```bash
   nix flake check --no-build   # must pass ("all checks passed!")
   nix fmt                      # opt-in formatter, 2-space nixfmt-rfc-style
   sudo nixos-rebuild build --flake .#desktop --dry-run
   ```
4. Rebuild (interactive): `rbld desktop` or `sudo nixos-rebuild switch --flake .#desktop`. From an agent: `pkexec` form above.
5. ISOs: `nix build .#nixosConfigurations.live-desktop.config.system.build.isoImage`. Install: `sudo install-nix` (guided installer on the ISO; manual fallback `sudo nixos-install --flake /iso/dotfiles#desktop`).

## When editing ~/.dotfiles itself

Read `AGENTS.md` first — it is binding. Least-change diffs, auto-import means no manifest edits (drop a `.nix` in the right folder), `git mv` when moving, and mandatory docs: update `README.md` (tree + `Last updated: YYYY-MM-DD HH:MM UTC`) and `AGENTS.md` (sections 2–3) on every change.
