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
			env = ["XCURSOR_SIZE, 24"];

			exec-once = [
				"hyprctl setcursor Bibata-Modern-Ice 24"
				"waybar"
			];
			
			inherit monitor;

			"$mod" = "SUPER";
			general = {
				gaps_in = 1;
				gaps_out = 1;
				border_size = 1;
				"col.active_border" = "rgba(426967)";
			};

			bind = [
				"$mod, Return, exec, ghostty"
				"$mod, B, exec, firefox"
				"$mod, Q, killactive"
				"$mod, F, fullscreen"

				"$mod, SPACE, exec, pkill rofi || rofi -show drun"
				"$mod SHIFT, SPACE, exec, pkill waybar || waybar"

				"$mod, 1, workspace, 1"
				"$mod, 2, workspace, 2"
				"$mod, 3, workspace, 3"
				"$mod, 4, workspace, 4"
				"$mod, 5, workspace, 5"
				"$mod, 6, workspace, 6"
				"$mod, 7, workspace, 7"
				"$mod, 8, workspace, 8"
				"$mod, 9, workspace, 9"
				"$mod, 0, workspace, 10"

				"$mod, H, movefocus, l"
				"$mod, L, movefocus, r"
				"$mod, K, movefocus, u"
				"$mod, J, movefocus, d"

				"$mod SHIFT, H, swapwindow, l"
				"$mod SHIFT, L, swapwindow, r"
				"$mod SHIFT, K, swapwindow, u"
				"$mod SHIFT, J, swapwindow, d"
			];

			bindm = [
				"$mod, mouse:272, movewindow"
				"$mod, mouse:273, resizewindow"
			];

			animations = {
				enabled = true;

				bezier = [
					"smooth,0.25,0.9,0.35,1.0"
				];

				animation = [
					"windows,1,5,smooth,slide"
					"windowsIn,1,5,smooth,slide"
					"windowsOut,1,4,smooth,slide"

					"fade,1,4,smooth"
					"fadeIn,1,4,smooth"
					"fadeOut,1,3,smooth"
					
					"workspaces,1,6,smooth,slide"
					"layers,1,4,smooth,fade"
				];
			};

			decoration = {
				blur = {
					enabled = true;
					size = 6;
					passes = 2;
				};
			};

			
			misc = {
				animate_manual_resizes = true;
				animate_mouse_windowdragging = true;
				force_default_wallpaper = 0;
				disable_hyprland_logo = true;
			};
		};
	};
}
