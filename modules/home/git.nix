{ ... }:
{
  programs.git = {
    enable = true;

    extraConfig = {
      credential.helper = "gh auth git-credential";
    };
  };
}
