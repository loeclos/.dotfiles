# hosts/live-laptop.nix — installer ISO for the laptop host.
# Shared GNOME + recovery base comes from ./live.nix; no extra drivers
# needed (generic Intel/AMD + enableAllHardware from the base covers it).
# Never import hardware/laptop.nix here — its filesystem UUIDs describe
# the installed machine, not bootable media.
# Built via: nix build .#nixosConfigurations.live-laptop.config.system.build.isoImage
{
  imports = [ ./live.nix ];

  networking.hostName = "live-laptop";
  isoImage.edition = "laptop";
}
