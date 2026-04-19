{ pkgs, ... }:
{
	boot.plymouth = {
		enable = true;
		theme = "mac-style";
		themePackages = [ pkgs.mac-style-plymouth ];
	};
}
