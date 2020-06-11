{ ... }:
let
  pkgs = (import <nixpkgs> {});
in
{
  Pkg-Julia = pkgs.buildEnv {
    name = "Julia";
    paths = with pkgs; [
      (pkgs.julia_13.overrideAttrs(oldAttrs: {checkTarget = "";}))
    ];
  };
}
