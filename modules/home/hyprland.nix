{ config, pkgs, lib, osConfig, ... }:

let
	hostname = osConfig.networking.hostName or "unknown";

	monitor = if hostname == "desktop" then
		"DP-1,3840x2160@60,0x0,1"
	else if hostname == "laptop" then
		"eDP-1,1920x1080@60,0x0,1"
	else
		",preferred,auto,1";

in
{
	wayland.windowManager.hyprland = {
		enable = true;
		systemd.enable = true;

		settings = {
			inherit monitor;

			"$mod" = "SUPER";
			general = {
				gaps_in = 1;
				gaps_out = 1;
				border_size = 1;
				"col.active_border" = "rgba(33d6bc70)";
			};

			bind = [
				"$mod, Return, exec, ghostty"
				"$mod, B, exec, firefox"
				"$mod SHIFT, Q, killactive"
				"$mod, F, fullscreen"
				"$mod, SPACE, exec, rofi -show drun"
				"$mod, 1, workspace, 1"
			];

			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];
			
			misc = {
				force_default_wallpaper = 0;
				disable_hyprland_logo = true;
			};
		};
	};
}
