{ pkgs ? import <nixpkgs> {} }:
let
  ownpkgs_git = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/bea1a232c615aba177e0ef56600d5f847ad3bbd9";
    sha256 = "1zakg4qrby56j28p9jifsplj3xbda2pmg1cw2zfr1y8wcab61p25";
  };

  ownpkgs = (import ownpkgs_git) { };
  # Go packages
  deepsea = ownpkgs.callPackages ./go/deepsea {};
  nvdtools = ownpkgs.callPackages ./go/nvdtools {};
  sybilhunter = ownpkgs.callPackages ./go/sybilhunter {};

in
ownpkgs.stdenv.mkDerivation rec {
  name = "my-go";
  buildInputs = [
    ownpkgs.makeWrapper
    deepsea
    nvdtools
    sybilhunter
    ];
  phases = [ "installPhase" ];
  installPhase = ''
    makeWrapper ${deepsea}/bin/deepsea $out/bin/deepsea
    makeWrapper ${nvdtools}/bin/cpe2cve $out/bin/cpe2cve
    makeWrapper ${sybilhunter}/bin/sybilhunter $out/bin/sybilhunter
'';
}
