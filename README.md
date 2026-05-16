# .dotfiles - NixOS Configuration

A complete declarative NixOS system configuration using Flakes and Home Manager, managing both system-level and user-level settings across multiple hosts with a focus on a modern Wayland-based desktop environment.

## 📋 Overview

This repository contains a reproducible NixOS configuration for multiple machines (desktop and laptop) using:
- **Nix Flakes** for reproducible builds and dependency management
- **Home Manager** for declarative user environment management
- **Hyprland** as the window manager (Wayland)
- **Modular architecture** for clean separation of concerns

## 🏗️ Repository Structure

```
.
├── flake.nix                          # Main Flake configuration
├── hosts/                             # Host-specific configurations
│   ├── desktop/
│   │   ├── configuration.nix          # Desktop-specific settings
│   │   └── hardware-configuration.nix # Auto-generated hardware config
│   └── laptop/
│       ├── configuration.nix          # Laptop-specific settings
│       └── hardware-configuration.nix # Auto-generated hardware config
├── modules/
│   ├── nixos/                         # System-level modules
│   │   ├── default.nix                # Module aggregator
│   │   ├── base.nix                   # Base system settings
│   │   ├── audio.nix                  # Audio/ALSA/PulseWire config
│   │   ├── bootloader.nix             # Boot configuration
│   │   ├── docker.nix                 # Container support
│   │   ├── fonts.nix                  # Font configuration
│   │   ├── greetd.nix                 # Display manager
│   │   ├── hyprland.nix               # Window manager
│   │   ├── packages.nix               # System packages
│   │   ├── plymouth.nix               # Boot splash screen
│   │   └── zsh.nix                    # Shell configuration
│   └── home/                          # User-level modules (Home Manager)
│       ├── default.nix                # Module aggregator
│       ├── cursors.nix                # Cursor theme
│       ├── ghostty.nix                # Terminal emulator
│       ├── gtk.nix                    # GTK theme settings
│       ├── hyprland.nix               # Hyprland keybinds & settings
│       ├── hyprpaper.nix              # Wallpaper configuration
│       ├── neovim.nix                 # Text editor (disabled)
│       ├── packages.nix               # User packages
│       ├── rofi.nix                   # Application launcher
│       └── waybar/
│           ├── waybar.nix             # Status bar configuration
│           └── style.css              # Waybar styling
└── users/
    └── loeclos/
        └── home.nix                   # User-specific Home Manager config
```

## 🔧 Flake Configuration

The `flake.nix` serves as the entry point and defines:

### Inputs (Dependencies)
- **nixpkgs**: Unstable branch for latest packages
- **home-manager**: User environment management
- **nixos-hardware**: Hardware-specific optimizations
- **mac-style-plymouth**: Custom boot splash theme
- **nixvim**: Neovim configuration flake (custom)

### Outputs
Two complete NixOS configurations defined as `nixosConfigurations`:
- **desktop**: Full desktop system configuration
- **laptop**: Laptop-optimized configuration

## 🖥️ System Configuration

### Base System (`modules/nixos/base.nix`)
- Enables experimental Nix features (flakes, nix-command)
- Sets default user shell to Zsh
- System state version: 26.05

### Boot & UEFI (`modules/nixos/bootloader.nix`)
- **systemd-boot** as the bootloader
- EFI variables enabled for UEFI systems

### Boot Theme (`modules/nixos/plymouth.nix`)
- Custom "mac-style" Plymouth theme
- Displays during system boot

### Audio (`modules/nixos/audio.nix`)
- **PipeWire** audio server with multiple backends:
  - ALSA (32-bit support for compatibility)
  - PulseAudio emulation
  - JACK for professional audio
- **Bluetooth** enabled with power-on-boot
- RealtimeKit for audio priority

### Containerization (`modules/nixos/docker.nix`)
- Docker daemon enabled
- User `loeclos` added to docker group

### Display Manager (`modules/nixos/greetd.nix`)
- **greetd** login manager with tuigreet TUI
- Runs `start-hyprland` session on login

### Window Manager (`modules/nixos/hyprland.nix`)
- **Hyprland** Wayland compositor enabled
- XWayland support for legacy X11 apps
- UWSM (Universal Wayland Session Manager) for session management
- XDG Portal with Hyprland desktop portal

### Shell (`modules/nixos/zsh.nix`)
- **Zsh** shell with:
  - Command completion and syntax highlighting
  - Autosuggestions enabled
  - **Oh-My-Zsh** theme: "bira"
  - Custom aliases:
    - `ll`: long ls format
    - `edit`: sudo editor
    - `update`: rebuild NixOS
    - `dots`: cd to dotfiles
    - `rebuild`: quick rebuild command
  - 10,000 line history with duplicate filtering

### Fonts (`modules/nixos/fonts.nix`)
- **MartianMono Nerd Font** for all contexts (mono, sans-serif, serif)

### System Packages (`modules/nixos/packages.nix`)
- `greetd`, `tuigreet`: Login manager
- `ghostty`: Modern terminal emulator
- `unzip`: Archive utility
- `iwd`: Wireless daemon
- `brightnessctl`: Brightness control
- `moka-icon-theme`: System icons
- `pamixer`: Audio mixer utility

## 👤 User Configuration (Home Manager)

### User Settings (`users/loeclos/home.nix`)
- Username: `loeclos`
- Home directory: `/home/loeclos`
- State version: 26.05

### Terminal (`modules/home/ghostty.nix`)
- **Ghostty** terminal with:
  - Gruvbox Material Dark theme
  - MartianMono Nerd Font
  - Zsh integration
  - Custom window padding

### Window Manager Bindings (`modules/home/hyprland.nix`)

#### Displays
- **Desktop**: DP-1 (3840×2160 @ 60Hz)
- **Laptop**: eDP-1 (1920×1080 @ 60Hz)

#### Key Bindings
| Key | Action |
|-----|--------|
| `SUPER + Return` | Open terminal (ghostty) |
| `SUPER + B` | Open Firefox |
| `SUPER + Q` | Kill active window |
| `SUPER + F` | Fullscreen |
| `F5/F6` | Brightness down/up |
| `F2/F3` | Volume down/up |
| `SUPER + Space` | Application launcher (rofi) |
| `SUPER + SHIFT + Space` | Toggle waybar |
| `SUPER + 1-0` | Switch workspaces |
| `SUPER + H/J/K/L` | Focus left/down/up/right |
| `SUPER + SHIFT + H/J/K/L` | Swap windows |
| `SUPER + Mouse` | Move/resize windows |

#### Animations
- Smooth animations with custom bezier curves
- Window slide animations on open/close
- Fade effects on workspace switches

### Status Bar (`modules/home/waybar/waybar.nix`)

A comprehensive top panel showing:

**Left**: Hyprland workspaces (1-9)

**Center**: Media player info (MPRIS) - artist, title, play status

**Right**:
- System tray (expandable)
- Volume percentage
- Memory usage (GB)
- CPU usage (%)
- Battery percentage with indicators
- Clock (DD/MM - HH:MM format)

**Customizations**:
- Icon-based workspace display
- Battery warning at 30%, critical at 15%
- Smart volume/brightness via function keys
- Calendar tooltip with date navigation

### Application Launcher (`modules/home/rofi.nix`)
- Rofi with Gruvbox Dark Hard theme
- MartianMono Nerd Font
- Application search and launch

### Wallpaper (`modules/home/hyprpaper.nix`)
- Image: `~/.config/wallpapers/gruvbox-road.png`
- Mode: Cover (scales to fill)

### Cursor Theme (`modules/home/cursors.nix`)
- **Bibata Modern Ice** cursor theme
- Size: 24px
- GTK integrated

### User Packages (`modules/home/packages.nix`)
- `nixvim`: Neovim configuration (custom flake input)
- `telegram-desktop`: Messaging app
- `git`, `gh`: Version control and GitHub CLI
- `firefox`: Web browser
- `btop`: Resource monitor
- `hollywood`: Terminal screensaver
- `genact`: Fake activity monitor
- `nautilus`: File manager
- `fastfetch`: System info fetcher
- `impala`: Display manager
- `discord`: Chat (with OpenASAR modification for privacy)

## 🚀 Usage

### Building the System

For desktop:
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#desktop
```

For laptop:
```bash
sudo nixos-rebuild switch --flake ~/.dotfiles#laptop
```

Or use the shell alias:
```bash
update  # Simple rebuild
rebuild # Rebuild from dotfiles directory
```

### Updating

To update all inputs (nixpkgs, home-manager, etc.):
```bash
nix flake update
```

### Switching Hosts

If you're moving the configuration to a different machine, update the host name in the respective `hosts/*/configuration.nix` and regenerate hardware configuration:
```bash
sudo nixos-generate-config --root /
```

Then integrate the new hardware config into `hosts/*/hardware-configuration.nix`.

## ⚙️ Key Configuration Details

### Multi-Host Support
- Single flake definition supports both desktop and laptop
- Each host has its own configuration module
- Shared modules via `modules/nixos/default.nix` and `modules/home/default.nix`
- Host-specific settings (hostname, DPI, monitor) override defaults

### Unfree Software
- Enabled for both system and Home Manager
- Allows packages like Discord, NVIDIA drivers if needed

### Declarative Home Manager
- All user configurations managed through Home Manager modules
- Automatic backup of overwritten files with `.backup` extension
- Seamless integration between system and user packages

### Custom Inputs
- `mac-style-plymouth`: Custom Plymouth theme from author's repo
- `nixvim`: Custom Neovim configuration flake
- Both inputs track nixpkgs to ensure compatibility

## 🔗 Dependencies on External Flakes

- **nixpkgs**: Latest packages from NixOS unstable
- **home-manager**: User environment declarative management
- **nixos-hardware**: Hardware-specific optimizations (referenced but not actively used)
- **mac-style-plymouth**: Custom boot splash screen from GitHub
- **nixvim**: Custom Neovim configuration

## 📝 Notes

- Desktop uses 144 DPI scaling for 4K displays
- Laptop and desktop share the same base configuration but differ in display settings
- Audio uses PipeWire for modern audio handling with backward compatibility
- Hyprland configured with smooth animations for visual polish
- Modular structure allows easy addition of new machines
- Hardware configurations are auto-generated and shouldn't be manually edited

## 🔄 Extending the Configuration

### Adding New System Modules
1. Create `modules/nixos/mynewmodule.nix`
2. Add to imports in `modules/nixos/default.nix`

### Adding New Home Modules
1. Create `modules/home/mynewmodule.nix`
2. Add to imports in `modules/home/default.nix`

### Adding New Host
1. Create `hosts/newhostname/` directory
2. Add `configuration.nix` with host-specific settings
3. Add `hardware-configuration.nix` (auto-generated)
4. Add to `flake.nix` outputs with `nixpkgs.lib.nixosSystem`

## 📦 Language Composition

This repository is composed of:
- **Nix**: 79.7% (configuration language)
- **CSS**: 20.3% (Waybar styling)

---

For more information on NixOS and Flakes, visit:
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes Documentation](https://nixos.wiki/wiki/Flakes)
