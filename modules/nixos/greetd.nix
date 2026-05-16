{ pkgs, ... }:
{
  services.greetd = {
    enable = false;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };
}
