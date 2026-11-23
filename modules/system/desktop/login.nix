{ pkgs, ... }:
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd \"/run/current-system/sw/bin/uwsm start hyprland-uwsm.desktop &> /dev/null\"";
        user = "greeter";
      };
    };
  };

  security.pam.services.hyprlock = { };
}
