{ ... }:
let
  overlays = [ (import ~/.config/nixpkgs/nixos-flk/overlays/kepler.gl) ];
  pkgs = (import <nixpkgs> { inherit overlays;});
in
pkgs.buildEnv rec {
    name = "kerpler";
    paths = with pkgs; [
      nodePackages.kepler-gl
    ];
}
