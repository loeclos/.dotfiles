{ pkgs, inputs, ... }:
let
  soundIn = inputs.self + "/assets/sounds/usb-in.mp3";
  soundOut = inputs.self + "/assets/sounds/usb-out.mp3";
in
{
  environment.systemPackages = [ pkgs.usb-sound ];

  # Play a short effect when a USB stick/drive appears or disappears.
  # KERNEL=="sd*[!0-9]" matches the whole-disk device (sda, sdb…) but not its
  # partitions (sda1), so one plug/unplug = one sound. SUBSYSTEMS=="usb"
  # keeps NVMe/SATA out. udev runs as root, so usb-sound fans out to each
  # active /run/user/<uid> PipeWire session via runuser (backgrounded).
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="block", KERNEL=="sd*[!0-9]", SUBSYSTEMS=="usb", RUN+="${pkgs.usb-sound}/bin/usb-sound ${soundIn}"
    ACTION=="remove", SUBSYSTEM=="block", KERNEL=="sd*[!0-9]", SUBSYSTEMS=="usb", RUN+="${pkgs.usb-sound}/bin/usb-sound ${soundOut}"
  '';
}
