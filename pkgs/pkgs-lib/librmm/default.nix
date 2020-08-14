{stdenv, pkgs, fetchgit, cmake, clang, python3, cudatoolkit}:

stdenv.mkDerivation rec {
  version = "master";
  name = "librmm";
  src = fetchgit {
    url = "https://github.com/rapidsai/rmm";
    rev = "cfbb2975f96bced32ad9cd2d8e6cfb7bb00701f1";
    sha256 = "sha256-o5E4IadrX6lpj1qCe+uWBPvXIxiN1PixiOpcvHfn4qU=";
  };

  configurePhase = ''
  export CUDA_PATH="${cudatoolkit}"
  export LD_LIBRARY_PATH=${cudatoolkit}/lib
  export INSTALL_PREFIX=$out
  bash ./build.sh -n librmm
  '';
  nativeBuildInputs = [ cmake cudatoolkit python3 clang ];
  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "rmm";
  };
}
