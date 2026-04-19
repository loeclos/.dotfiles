{ ... }:
{
	virtualisation.docker.enable = true;
	users.users.loeclos.extraGroups = [ "docker" ];
}
