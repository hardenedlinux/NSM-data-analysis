{ stdenv, lib, pkgs, fetchgit, cmake, cudatoolkit, nixpkgs-hardenedlinux-sources }:

stdenv.mkDerivation rec {

  inherit (nixpkgs-hardenedlinux-sources.cnmem) pname version src;

  nativeBuildInputs = [ cmake ];

  buildInputs = [ cudatoolkit ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "cnmem";
  };
}
