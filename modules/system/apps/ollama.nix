# modules/system/apps/ollama.nix — local LLM backend (pinned CUDA build).
{ pkgs, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda; # see packages/default.nix
  };
}
