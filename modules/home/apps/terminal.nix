{
  config,
  theme,
  repoRoot,
  apps,
  ...
}:
{
  # Cursor warp shader (Neovide-like trail) from assets/ghostty/shaders/.
  # Deployed via xdg.configFile so Ghostty gets an absolute path (relative
  # asset paths never resolve — Ghostty resolves them against its CWD).
  xdg.configFile."ghostty/shaders/cursor_warp.glsl".source =
    repoRoot + "/assets/ghostty/shaders/cursor_warp.glsl";

  programs.ghostty = {
    # Only the selected terminal (lib/apps.nix) gets HM config; the package
    # itself is installed via modules/system/apps/base.nix.
    enable = apps.terminalName == "ghostty";

    installVimSyntax = true;

    enableZshIntegration = true;

    settings = {
      theme = "Gruvbox Material Dark";
      font-family = "${theme.fonts.mono} ${toString theme.fonts.size}";
      font-size = theme.fonts.size;

      window-padding-x = 3;
      window-padding-y = 3;

      custom-shader = "${config.home.homeDirectory}/.config/ghostty/shaders/cursor_warp.glsl";
      custom-shader-animation = "always";

      confirm-close-surface = false;
    };
  };
}
