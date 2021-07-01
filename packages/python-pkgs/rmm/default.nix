{ stdenv
, lib
, python3Packages
, fetchgit
, cudatoolkit
, cnmem
, spdlog
, linuxPackages
}:

python3Packages.buildPythonPackage rec {

  pname = "rmm";
  version = "0.2.0";
  src = fetchgit {
    url = "https://github.com/rapidsai/rmm";
    rev = "e7f07268373652f9f36f68b284af8ca0637c6e08";
    sha256 = "sha256-lmACOAJtWIjKWe82GTfD8XOADo+q9nrtNQraJlwPau0=";
  };

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
