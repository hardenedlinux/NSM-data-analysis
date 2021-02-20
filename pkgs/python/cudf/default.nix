{ stdenv
, python3Packages
, fetchgit
, cudatoolkit
, linuxPackages
, spdlog
, arrow-cpp
, pyarrow
}:
let
  rmm-src = fetchgit {
    url = "https://github.com/rapidsai/rmm";
    rev = "e7f07268373652f9f36f68b284af8ca0637c6e08";
    sha256 = "sha256-lmACOAJtWIjKWe82GTfD8XOADo+q9nrtNQraJlwPau0=";
  };

in
python3Packages.buildPythonPackage rec {

  pname = "cudf";
  version = "master";
  src = fetchgit {
    url = "https://github.com/rapidsai/cudf";
    rev = "0f0e748fb4cb8c364e6ac2cc35fc40a2608025f2";
    sha256 = "sha256-hiHFT8w/lrmYJI/fMYgD2jfW6B4neOt+SSfSazWB2dI=";
  };

  preConfigure = ''
    export CUDA_HOME=${cudatoolkit}
    export LD_LIBRARY_PATH=${cudatoolkit}/lib

    ln -s ${rmm-src}//include/rmm cpp/include/rmm
    cd python/cudf
  '';

  nativeBuildInputs = [ cudatoolkit ];
  buildInputs = [
    linuxPackages.nvidia_x11
    spdlog
    cudatoolkit
    arrow-cpp
    pyarrow
  ];
  propagatedBuildInputs = with python3Packages; [
    numpy
    versioneer
    setuptools
    protobuf
    cysignals
    cython
    tables
    cupy
    pyarrow
    pandas
    numba
    rmm
    arrow
  ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "cuDF - GPU DataFrame Library ";
    homepage = "https://github.com/rapidsai/cudf";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
