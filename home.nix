# home.nix — the single home-manager entrypoint (single-user repo).
# Pulls in every user module via modules/home (auto-imported).
{
  config,
  pkgs,
  lib,
  inputs,
  osConfig,
  ...
}:
{
  imports = [
    ./modules/home
  ];

  home.username = "loeclos";
  home.homeDirectory = "/home/loeclos";
  home.stateVersion = "26.05";

}
