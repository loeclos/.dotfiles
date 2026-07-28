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

  hardware.graphics = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    open = true;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
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
