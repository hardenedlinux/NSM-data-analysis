{ ... }:
let
  pkgs = (import <nixpkgs> {});
in {
  zeek = pkgs.callPackage ./pkgs/zeek {};
  broker = pkgs.callPackage ./pkgs/broker {};
  vast = pkgs.callPackage ./pkgs/vast {};
  julia = (import ./pkgs/julia-non-cuda.nix {});
  my-python = (import ./pkgs/python.nix {});
  my-go =  (import ./pkgs/go.nix {});
  my-R = (import ./pkgs/R.nix {});
}
