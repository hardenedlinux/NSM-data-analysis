{ ... }:
let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];
  pkgs = import <nixpkgs> { inherit overlays; config = { allowUnfree = true; allowBroken = true; }; };
in
{
  hardenedlinux-pkgs-vast = pkgs.buildEnv {
    name = "nsm-vast";
    paths = with pkgs; [
      pkgs.vast
    ];
  };
}
