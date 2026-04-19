{ pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/nixos/default.nix
	];

	networking.hostName = "desktop";
	networking.networkmanager.enable = true;

	time.timeZone = "America/Los_Angeles";
	i18n.defaultlocale = "en_US.UTF-8";

	users.users.loeclos = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
	};

	services.xserver.dpi = 144;
}
