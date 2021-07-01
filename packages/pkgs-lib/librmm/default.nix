{ stdenv, lib, pkgs, fetchgit, cmake, python3, cudatoolkit }:
let
  cnmem = fetchgit {
    url = "https://github.com/NVIDIA/cnmem";
    rev = "37896cc9bfc6536a8c878a1e675835c22d827821";
    sha256 = "sha256-Xpr0idhBhCxFC0yDWpZwwD29FRMGdTrD5RzgluwuonM=";
  };

in
stdenv.mkDerivation rec {
  version = "master";
  name = "librmm";
  src = fetchgit {
    url = "https://github.com/rapidsai/rmm";
    rev = "1bcc7b1f4f757fc79d4d20fbfd4a688eac5cab61";
    sha256 = "sha256-nUoOZmTxtHcyFY5CTBRevxAkOkfsp5G1tJPanypXZTc=";
  };

  configurePhase = ''
    export CUDA_PATH="${cudatoolkit}"
    export LD_LIBRARY_PATH=${cudatoolkit}/lib
    export INSTALL_PREFIX=$out
    bash ./build.sh -n librmm
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ cudatoolkit python3 ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "rmm";
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
