let
  browserName = "chromium";
  extraBrowsers = [ "brave" ];
  terminalName = "ghostty";
  agentName = "opencode";
  fileManagerName = "nautilus";
  editorName = "nvim";

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
