{ lib, ... }:
{
  imports = import ../../lib/autoimport.nix { inherit lib; } ./.;
}
