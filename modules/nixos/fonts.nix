{ pkgs, ... }:
{
	fonts = {
		packages = with pkgs; [
			nerd-fonts.martian-mono
		];

		fontconfig = {
			defaultFonts = {
				monospace = [ "MartianMono Nerd Font" ];
				sansSerif = [ "MartianMono Nerd Font" ];
				serif = [ "MartianMono Nerd Font" ];
			};
		};
	};
}
