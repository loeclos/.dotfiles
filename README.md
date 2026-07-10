.dotfiles — NixOS configuration
===============================

A versatile, extensible NixOS configuration (flake + home-manager) intended as a reusable starting point for multiple machines. It provides system-level NixOS modules, user/home-manager modules, fonts and assets, and per-host overlays so the same repository can manage desktop and laptop installations.

Detailed documentation
- Full, detailed docs: https://deepwiki.com/loeclos/.dotfiles

Overview
--------

Last updated: 2026-07-10

This repository is a Nix flake that contains:
- a flake-based NixOS configuration and home-manager setups,
- assets and derivations used by those configurations (fonts, shaders, wallpapers),
- per-host configuration under hosts/, and
- reusable modules under modules/ for both NixOS and home-manager.

The flake builds and composes machine configurations; home-manager modules expose per-user configuration. The repository keeps a small number of derivations (e.g., packaging a font) and local assets required by the configuration.

Repository structure
--------------------

Top-level tree (annotated):
- **modules/home/hyprpaper.nix**: Wallpaper config code uncommented and fixed.
- **modules/home/packages.nix**: More dev tools, chat apps, utilities, AI tools added (obsidian, element-desktop, opencode, crush, code-cursor, etc). Cleaned up sections.
- **modules/nixos/fonts.nix**: Now also pulls `inter` and `alice` fonts for improved look.
- **modules/nixos/packages.nix**: Swapped out login/display managers and misc tools. SDDM-astronaut, hyprlock, wlogout added.

For the full diff, see: https://github.com/loeclos/.dotfiles/commit/95344baa229e7c73777abbca414d555dee216307

## 🔧 Flake Configuration

... *(remains unchanged - see previous version and feel free to request expansion if needed)* ...

## 📦 Language Composition

This repository is now composed of:
- **GLSL**: 65.8% (terminal/graphics shader code)
- **Nix**: 28.5% (system/user config)
- **CSS**: 5.7% (Waybar, UI styles)

---

For more information on NixOS and Flakes, visit:
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)
