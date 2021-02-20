{ stdenv, pkgs, fetchgit, cmake, cudatoolkit }:

stdenv.mkDerivation rec {
  version = "master";
  name = "cnmem";
  src = fetchgit {
    url = "https://github.com/NVIDIA/cnmem";
    rev = "37896cc9bfc6536a8c878a1e675835c22d827821";
    sha256 = "sha256-Xpr0idhBhCxFC0yDWpZwwD29FRMGdTrD5RzgluwuonM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cudatoolkit ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "cnmem";
  };
}
