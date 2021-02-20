let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];

  pkgs = (import <nixpkgs>) { inherit overlays; };
in
{
  hardenedlinux-spicy = pkgs.buildEnv {
    name = "spicy";
    paths = with pkgs; [
      spicy
    ];
  };
}
