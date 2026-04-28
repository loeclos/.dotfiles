{ pkgs, ... }:
{
	home.packages = with pkgs; [
		nemo
		fastfetch
	];
	
	imports = [
		./hyprland.nix
		./neovim.nix
		./base.nix
		./hyprpaper.nix
		./ghostty.nix
		./cursors.nix
		./rofi.nix
		./waybar/waybar.nix
		./nixvim.nix
	];
}
