{ pkgs, ... }:
let
  latex-typora = pkgs.fetchFromGitHub {
    owner = "shamsghi";
    repo = "LatexTypora";
    rev = "1c58469f4026e7959dbaf528978b01608fd0f3ec";
    hash = "sha256-LGmCahOO5t75Ex7zbOl4oppkulmwpXFNoM78ppidckM=";
  };
in
{
  home.packages = with pkgs; [ typora ];

  home.file = {
    ".config/Typora/themes/latex.css".source = "${latex-typora}/latex.css";
    ".config/Typora/themes/latex-dark.css".source = "${latex-typora}/latex-dark.css";
    ".config/Typora/themes/latex-dev-dark.css".source = "${latex-typora}/latex-dev-dark.css";
    ".config/Typora/themes/latex_fonts".source = "${latex-typora}/latex_fonts";
  };
}
