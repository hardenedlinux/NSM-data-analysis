{ ... }:
let
  pkgs = (import <nixpkgs> {});
in {
  zeek = pkgs.callPackage ./pkgs/zeek {};
  broker = pkgs.callPackage ./pkgs/broker {};
  vast = pkgs.callPackage ./pkgs/vast {};
}
