{
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/default.nix
  ];

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.loeclos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
    ];
  };

  # hardware.graphics = {
  #   enable = true;
  #   enable32Bit = true;
  # };
  #
  # hardware.nvidia = {
  #   # Change this from true to false
  #   open = false;
  #
  #   # Ensure modesetting is on
  #   modesetting.enable = true;
  # };

  services.xserver = {
    # videoDrivers = [ "nvidia" ];
    dpi = 144;
  };

  systemd.mounts = [{
    what = "/dev/disk/by-uuid/5DECDB1C46C85694";
    where = "/mnt/ssd";
    type = "ntfs-3g";
    options = "uid=1000,gid=100,rw,noatime";
  }];

  systemd.automounts = [{
    where = "/mnt/ssd";
    wantedBy = [ "multi-user.target" ];
  }];
}
