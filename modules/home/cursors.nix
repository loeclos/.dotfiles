{ pkgs, ... }:
{
	home.pointerCursor = {
		package = pkgs.bibata-cursors;
		name = "Bibata";
		size = 24;
		gtk.enable = true;
	};
}
