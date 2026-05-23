# .dotfiles - NixOS Configuration

A complete declarative NixOS system configuration using Flakes and Home Manager, managing both system-level and user-level settings across multiple hosts with a focus on a modern Wayland-based desktop and custom graphics.

## 📋 Overview

This repository contains a reproducible NixOS configuration for multiple machines (desktop and laptop) using:
- **Nix Flakes** for reproducible builds and dependency management
- **Home Manager** for declarative user environment management
- **Hyprland** as the window manager (Wayland)
- **Custom GPU/terminal shaders** for visual polish
- **Modular architecture** for clean separation of concerns

## 🏗️ Repository Structure and Major File Changes

Recent restructuring includes the addition of a large GLSL shader suite and updates to several Nix/NixOS/home-manager files.

```
.
├── assets/
│   ├── fonts/
│   │   └── satoshi.zip                   # Satoshi font (added)
│   └── ghostty/
│       └── shaders/                      # ✨ NEW: GPU cursor/trail shaders
│           ├── README.md                 # Shader docs
│           ├── cursor_warp.glsl
│           ├── cursor_sweep.glsl
│           ├── cursor_tail.glsl
│           ├── rectangle_boom_cursor.glsl
│           ├── ripple_cursor.glsl
│           ├── ripple_rectangle_cursor.glsl
│           ├── sonic_boom_cursor.glsl
│           └── .gitignore
├── derivations/
│   └── satoshi-font.nix                  # Package for Satoshi font (added)
├── flake.nix                             # Updated with new inputs (hermes-agent, helium)
├── flake.lock                            # Updated
├── hosts/                                # Host-specific configs
├── modules/
│   ├── home/
│   │   ├── ghostty.nix                   # ☑️ Now enables custom shaders
│   │   ├── hermes-agent.nix              # New module
│   │   ├── hyprland.nix                  # Keybinding/monitor/visual tweaks
│   │   ├── hyprpaper.nix                 # Wallpaper logic improvements
│   │   ├── packages.nix                  # New/removed apps (see below)
│   │   └── ...
│   └── nixos/
│       ├── fonts.nix                     # Now also installs Inter & Alice fonts
│       ├── packages.nix                  # Updated to include/exclude various pkgs
│       └── ...
├── users/loeclos/
└── ...
```

### Notable File Changes (Latest Commit)
- **assets/ghostty/shaders/**: Added 8+ custom GLSL shaders for advanced cursor/terminal effects and a README explaining use and customization.
- **assets/fonts/satoshi.zip**: Added font zip for Satoshi.
- **derivations/satoshi-font.nix**: New Nix expression to install Satoshi font.
- **flake.nix/flake.lock**: Now includes `hermes-agent` and `helium` flakes as inputs.
- **modules/home/ghostty.nix**: Configures custom Ghostty shader for terminal, improving graphics.
- **modules/home/hermes-agent.nix**: Added new module for Hermes agent.
- **modules/home/hyprland.nix**: More robust monitor detection and control tweaks; naming made lowercase.
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
