{ pkgs, ... }:
{
	# nix.settings.expiremental-features = [
	# 	"nix-commnad"
	# 	"flakes"
	# ];

	environment.systemPackages = with pkgs; [
		greetd
		tuigreet
		ghostty
		unzip
		vimPlugins.LazyVim
	];

	environment.shellAliases = {
		dots = "cd ~/.dotfiles";
		rebuild = "dots && sudo nixos-rebuild switch --flake";
	};

	system.stateVersion = "26.05";
}
