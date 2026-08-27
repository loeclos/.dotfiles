{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland -- --config ~/.local/state/hyprland/hypr.log";
        user = "greeter";
      };
    };
  };
}
