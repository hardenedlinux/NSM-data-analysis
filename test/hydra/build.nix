with import <nixpkgs> { };
let
  brim = pkgs.callPackage ~/.config/nixpkgs/nixos-flk/pkgs/brim { };
in
pkgs.buildEnv {
  name = "test";
  paths = with pkgs; [
    brim
  ];
}
