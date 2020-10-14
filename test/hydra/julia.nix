{ ... }:
let
  pkgs = (import <nixpkgs> {});
in
{
  Pkg-Julia = pkgs.buildEnv {
    name = "Julia";
    paths = with pkgs; [
      (pkgs.julia_13.overrideAttrs(oldAttrs: {
        src = pkgs.fetchzip {
          url = "https://github.com/JuliaLang/julia/releases/download/v1.5.1/julia-1.5.1-full.tar.gz";
          sha256 = "sha256-uaxlzni2RtmDhMzPbtDycj44CB0tJUzhmbwsAGwFv/U=";
        };
        checkTarget = "";}
      ))
    ];
  };
}
