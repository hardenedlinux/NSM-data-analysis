{ ... }:
let
  pkgs = (import <nixpkgs> {});
  my-julia = (import ./pkgs/julia-non-cuda.nix {inherit pkgs;});
  my-python = (import ./pkgs/python.nix {inherit pkgs;});
  my-go =  (import ./pkgs/go.nix {inherit pkgs;});
  my-R = (import ./pkgs/R.nix {inherit pkgs;});
in {
  zeek = pkgs.callPackage ./pkgs/zeek {};
  broker = pkgs.callPackage ./pkgs/broker {};
  vast = pkgs.callPackage ./pkgs/vast {};
  nsm-data-analysis-pkgs = pkgs.buildEnv {
  name = "nsm-data-analysis-pkgs";
  paths = with pkgs; [
    my-julia
    my-go
    my-R
    my-python
  ];
  };
}
