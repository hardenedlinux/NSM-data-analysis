{ ... }:
let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];

  pkgs = import <nixpkgs> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  hardenedlinux-pkgs-R = (import ../../pkgs/R.nix {inherit pkgs;});
in {
  hardenedlinux-pkgs-R = pkgs.buildEnv {
    name = "hardenedlinux-pkgs-R";
    paths = with pkgs; [
      hardenedlinux-pkgs-go
    ];
  };
}
