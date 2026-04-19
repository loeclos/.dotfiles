{ ... }:
{
	programs.ghostty = {
		enable = true;

		installVimSyntax = true;
		
		settings = {
			theme = "Gruvbox Material Dark";
			font-family = "CaskaydiaMono Nerd Font";

			window-padding-x = 3;
		};
	};
}
