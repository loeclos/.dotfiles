{ lib, ... }:
{
  virtualisation.docker.enable = true;
  users.users.loeclos.extraGroups = [ "docker" ];
  systemd.services.docker = {
    wants = lib.mkForce [
      "docker.socket"
      "containerd.service"
    ];
    after = lib.mkForce [
      "network.target"
      "docker.socket"
      "containerd.service"
    ];
  };
}
