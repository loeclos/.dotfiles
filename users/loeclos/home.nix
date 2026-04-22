{ config, pkgs, lib, inputs, osConfig, ... }:
{
	imports = [
		../../modules/home/default.nix
	];

	home.username = "loeclos";
	home.homeDirectory = "/home/loeclos";
	home.stateVersion = "26.05";

	home.packages = with pkgs; [
		telegram-desktop
		git
		gh
		firefox
		btop
		hollywood
		genact
	];
}
