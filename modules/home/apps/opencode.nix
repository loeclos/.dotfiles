# modules/home/apps/opencode.nix — opencode TUI defaults (theme) + nixos-dotfiles skill
{ repoRoot, ... }:
{
  xdg.configFile."opencode/tui.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/tui.json";
    theme = "cursor";
  };

  # Global skill so every agent on this machine knows rbld/update/pkexec,
  # hosts, and the flake layout. Source lives in-repo, deployed here so it
  # survives rebuilds (same pattern as ghostty shaders in apps/terminal.nix).
  xdg.configFile."opencode/skills/nixos-dotfiles/SKILL.md".source =
    repoRoot + "/assets/opencode/skills/nixos-dotfiles/SKILL.md";
}
