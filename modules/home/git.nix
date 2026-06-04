{ ... }:
{
  programs.git = {
    enable = true;

    settings = {
      credential.helper = [
        ""
        "!gh auth git-credential"
      ];
    };
  };
}
