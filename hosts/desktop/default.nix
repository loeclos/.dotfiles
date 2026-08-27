{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix
    ../../modules/nixos/default.nix
  ];

  networking.hostName = "desktop";

  hardware.graphics = {
    enable = true;
  };

  systemd.mounts = [
    {
      what = "/dev/disk/by-uuid/5DECDB1C46C85694";
      where = "/mnt/ssd";
      type = "ntfs-3g";
      options = "uid=1000,gid=100,rw,noatime";
    }
  ];

  systemd.automounts = [
    {
      where = "/mnt/ssd";
      wantedBy = [ "multi-user.target" ];
    }
  ];
}
