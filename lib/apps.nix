# lib/apps.nix — single source of truth for essential applications.
# Switch the five *Name values below and the choice autopropagates to
# home.packages, environment.systemPackages, xdg defaults, Hyprland keybinds,
# float rules, and the picker scripts (via lib/mkHost.nix extraSpecialArgs,
# same pattern as lib/theme.nix — never import this file relatively).
# Each catalog entry carries everything consumers need: the nixpkgs attr
# (packageAttr), the binary (command), the .desktop id (desktopId, GUI apps),
# and a human label. Entries may instead name a flake input (flakeInput)
# whose packages.${system}.default is installed — used for the nixvim-built
# editor, which isn't a plain nixpkgs attr. Agent entries add inTerminal
# (TUI agents launch inside the selected terminal, GUI agents launch directly).
let
  browserName = "chromium"; # | "brave" | "qutebrowser" | "firefox"
  # Additional browsers installed alongside the default (kept as default for
  # keybinds/xdg). Entries must match keys in `browsers` below.
  extraBrowsers = [ "brave" ];
  terminalName = "ghostty"; # | "kitty" | "alacritty"
  agentName = "opencode"; # | "cursor"
  fileManagerName = "nautilus"; # | "thunar"
  editorName = "nvim"; # | "helix"

  browsers = {
    chromium = {
      packageAttr = "ungoogled-chromium";
      command = "chromium";
      desktopId = "chromium-browser.desktop";
      label = "Chromium";
    };
    brave = {
      packageAttr = "brave";
      command = "brave";
      desktopId = "brave-browser.desktop";
      label = "Brave";
    };
    qutebrowser = {
      packageAttr = "qutebrowser";
      command = "qutebrowser";
      desktopId = "org.qutebrowser.qutebrowser.desktop";
      label = "qutebrowser";
    };
    firefox = {
      packageAttr = "firefox";
      command = "firefox";
      desktopId = "firefox.desktop";
      label = "Firefox";
    };
  };

  terminals = {
    ghostty = {
      packageAttr = "ghostty";
      command = "ghostty";
      label = "Ghostty";
    };
    kitty = {
      packageAttr = "kitty";
      command = "kitty";
      label = "kitty";
    };
    alacritty = {
      packageAttr = "alacritty";
      command = "alacritty";
      label = "Alacritty";
    };
  };

  agents = {
    opencode = {
      packageAttr = "opencode";
      command = "opencode";
      inTerminal = true;
      label = "opencode";
    };
    cursor = {
      packageAttr = "code-cursor";
      command = "cursor";
      desktopId = "cursor.desktop";
      inTerminal = false;
      label = "Cursor";
    };
  };

  fileManagers = {
    nautilus = {
      packageAttr = "nautilus";
      command = "nautilus";
      desktopId = "org.gnome.Nautilus.desktop";
      label = "Nautilus";
    };
    thunar = {
      packageAttr = "thunar";
      command = "thunar";
      desktopId = "thunar.desktop";
      label = "Thunar";
    };
  };

  editors = {
    nvim = {
      flakeInput = "nixvim";
      command = "nvim";
      label = "Neovim";
    };
    helix = {
      packageAttr = "helix";
      command = "hx";
      label = "Helix";
    };
  };
in
{
  inherit
    browserName
    extraBrowsers
    terminalName
    agentName
    fileManagerName
    editorName
    browsers
    terminals
    agents
    fileManagers
    editors
    ;

  browser = browsers.${browserName};
  terminal = terminals.${terminalName};
  agent = agents.${agentName};
  fileManager = fileManagers.${fileManagerName};
  editor = editors.${editorName};
}
