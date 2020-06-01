{ ... }:
let
  pkgs = (import <nixpkgs> {});
in
{
  nsm-data-analysis-Julia = pkgs.buildEnv {
    name = "nsm-data-analysis-Julia";
    paths = with pkgs; [
      pkgs.julia_13
    ];
  };
}
