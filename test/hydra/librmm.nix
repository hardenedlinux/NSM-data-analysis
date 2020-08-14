{ ... }:
let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];
  pkgs = import <nixpkgs> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
in {
  hardenedlinux-pkgs-librmm = pkgs.buildEnv {
    name = "nsm-librmm";
    paths = with pkgs; [
      pkgs.librmm
    ];
  };
}
