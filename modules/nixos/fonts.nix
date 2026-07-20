{ pkgs, ... }:

# let
#   satoshi = pkgs.callPackage ../../derivations/satoshi-font.nix { };
# in
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.martian-mono
      nerd-fonts.departure-mono
      nerd-fonts.geist-mono
      inter-nerdfont
      dm-sans
      plus-jakarta-sans
      public-sans
      work-sans
      barlow
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "MartianMono Nerd Font" ];
        sansSerif = [ "GeistMono Nerd Font" "Inter Nerd Font" "DM Sans" "Plus Jakarta Sans" "Public Sans" ];
        serif = [ "MartianMono Nerd Font" ];
      };
    };
  };
}
