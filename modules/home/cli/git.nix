{ ... }:
{
  programs.git = {
    enable = true;

    settings = {

      user = {
        name = "gleb";
        email = "116607327+loeclos@users.noreply.github.com";
      };
      init.defaultBranch = "main";

      credential.helper = [
        ""
        "!gh auth git-credential"
      ];
    };
  };
}
