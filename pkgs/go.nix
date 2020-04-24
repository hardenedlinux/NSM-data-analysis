{ pkgs ? import ./ownpkgs.nix {}
}:

let

  deepsea = pkgs.callPackage ./go/deepsea {};
  nvdtools = pkgs.callPackage ./go/nvdtools {};
  sybilhunter = pkgs.callPackage ./go/sybilhunter {};

in
pkgs.stdenv.mkDerivation rec {
  name = "my-go";
  buildInputs = [
    pkgs.makeWrapper
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
