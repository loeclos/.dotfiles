{ pkgs, lib, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		../../modules/nixos/default.nix
	];

	networking.hostName = "laptop";
	networking.networkmanager.enable = true;

	time.timeZone = "America/Los_Angeles";
	i18n.defaultLocale = "en_US.UTF-8";

	users.users.loeclos = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" "docker" "audio" ];
	};
}
