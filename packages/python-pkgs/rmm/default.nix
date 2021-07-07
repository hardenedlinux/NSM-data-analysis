{ lib
, python3Packages
, cudatoolkit
, cnmem
, spdlog
, linuxPackages
, nixpkgs-hardenedlinux-sources
}:

python3Packages.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.rmm) pname version src;

  nativeBuildInputs = [ cudatoolkit ];

  propagatedBuildInputs = with python3Packages; [
    cython
    numba
  ];
  doCheck = false;


  buildInputs = [
    spdlog
    cnmem
    cudatoolkit
    linuxPackages.nvidia_x11
  ];

  postPatch = ''
    export CUDA_PATH="${cudatoolkit}"
    export LD_LIBRARY_PATH=${cudatoolkit}/lib

    ln -s ${cnmem}/include/cnmem.h include/rmm/detail
      cd python
  '';

  meta = with lib; {
    description = "RAPIDS Memory Manager";
    homepage = "https://github.com/rapidsai/rmm";
    license = licenses.asl20;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };

}
