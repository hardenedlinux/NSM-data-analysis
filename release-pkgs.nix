{ ... }:
let
  pkgs = (import <nixpkgs> {});
in {
  zeek = pkgs.callPackages ./pkgs/zeek {};
  broker = pkgs.callPackages ./pkgs/broker {};
  vast = pkgs.callPackages ./pkgs/vast {};
}
