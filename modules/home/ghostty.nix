{ ... }:
{
	programs.ghostty = {
		enable = true;

		installVimSyntax = true;
		
		settings = {
			theme = "Gruvbox Material Dark";
			font-family = "MartionMono Nerd Font";

			window-padding-x = 3;
		};
	};
}
