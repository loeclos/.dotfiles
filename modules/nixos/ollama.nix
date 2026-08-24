{ config, pkgs, inputs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.callPackage ../../derivations/ollama.nix {
      src = inputs.ollama;
      acceleration = "cuda";
    };
  };
}
