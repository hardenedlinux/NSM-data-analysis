{ pkgs }:
let
  deepsea = pkgs.callPackage ./go/deepsea { };
  nvdtools = pkgs.callPackage ./go/nvdtools { };
  sybilhunter = pkgs.callPackage ./go/sybilhunter { };
  zq = pkgs.callPackage ./go/zq { };
in
pkgs.stdenv.mkDerivation rec {
  name = "hardenedlinux-go";
  buildInputs = [
    pkgs.makeWrapper
    deepsea
    nvdtools
    sybilhunter
    zq
  ];

  phases = [ "installPhase" ];

  installPhase = ''
    makeWrapper ${deepsea}/bin/deepsea $out/bin/deepsea
    makeWrapper ${nvdtools}/bin/cpe2cve $out/bin/cpe2cve
    makeWrapper ${sybilhunter}/bin/sybilhunter $out/bin/sybilhunter
    makeWrapper ${zq}/bin/zq $out/bin/zq
  '';
}
