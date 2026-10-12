{ lib, pkgs, ... }:
{
  virtualisation.docker.enable = true;

  programs.virt-manager.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };

  users.users.loeclos.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
  ];
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
