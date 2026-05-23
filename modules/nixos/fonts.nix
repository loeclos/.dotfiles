{ pkgs, ... }:
{
  fonts = {
    packages = with pkgs; [
      nerd-fonts.martian-mono
      inter
      alice
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [ "MartianMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Alice" ];
      };
    };
  };
}
