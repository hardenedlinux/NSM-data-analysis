{ stdenv, lib, fetchgit, cmake, clang, python3, cudatoolkit }:

stdenv.mkDerivation rec {
  version = "master";
  name = "libclx";
  src = fetchgit {
    url = "https://github.com/rapidsai/clx";
    rev = "6cbe4830ac2a5f151445df1f33404d1949716bfd";
    sha256 = "0mnh57p4jc9bjczbkyqqzfy4mpzdqz1ypmam2lyh61p0xrgqrvsr";
  };

  configurePhase = ''
    export CUDA_PATH="${cudatoolkit}"
    export INSTALL_PREFIX=$out
    mkdir -p ./cpp/build
    cd cpp/build
    cmake .. -DCMAKE_INSTALL_PREFIX=$out
  '';
  nativeBuildInputs = [ cmake cudatoolkit python3 clang ];
  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "clx";
  };
}
