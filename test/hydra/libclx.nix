{ ... }:
let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];
  pkgs = import <nixpkgs> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
in {
  hardenedlinux-pkgs-libclx = pkgs.buildEnv {
    name = "nsm-libclx";
    paths = with pkgs; [
      pkgs.libclx
    ];
  };
}
