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

  nsm-data-analysis-R = pkgs.buildEnv {
  name = "nsm-data-analysis-R";
  paths = with pkgs; [
    my-go
  ];
  };
  nsm-data-analysis-Julia = pkgs.buildEnv {
  name = "nsm-data-analysis-Julia";
  paths = with pkgs; [
    my-julia
  ];
  };

  nsm-data-analysis-python = pkgs.buildEnv {
  name = "nsm-data-analysis-python";
  paths = with pkgs; [
    my-python
  ];
  };
  nsm-data-analysis-go = pkgs.buildEnv {
  name = "nsm-data-analysis-go";
  paths = with pkgs; [
    my-go
  ];
  };
}
