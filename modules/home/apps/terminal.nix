{
  config,
  theme,
  repoRoot,
  apps,
  ...
}:
{
  xdg.configFile."ghostty/shaders/cursor_warp.glsl".source =
    repoRoot + "/assets/ghostty/shaders/cursor_warp.glsl";

  programs.ghostty = {
    enable = apps.terminalName == "ghostty";

    installVimSyntax = true;

    enableZshIntegration = true;

    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "${theme.fonts.mono} ${toString theme.fonts.size}";
      font-size = theme.fonts.size;

      background-opacity = 1;

      window-padding-x = 3;
      window-padding-y = 3;

      custom-shader = "${config.home.homeDirectory}/.config/ghostty/shaders/cursor_warp.glsl";
      custom-shader-animation = "always";

      confirm-close-surface = false;
    };
  };
}
