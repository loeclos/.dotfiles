{ pkgs, ... }:

# let
#   satoshi = pkgs.callPackage ../../derivations/satoshi-font.nix { };
# in
{
  fonts = {
    packages = with pkgs; [
      sf-pro-nerd
      sf-mono-nerd
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
        monospace = [ "SFMono Nerd Font" "GeistMono Nerd Font" "DepartureMono Nerd Font" ];
        sansSerif = [ "SFProDisplay Nerd Font" "Inter Nerd Font" "DM Sans" "Plus Jakarta Sans" "Public Sans" "Work Sans" "Barlow" ];
      };
    };
  };
}
