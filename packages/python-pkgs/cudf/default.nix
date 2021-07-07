{ lib
, python3Packages
, cudatoolkit
, linuxPackages
, spdlog
, arrow-cpp
, pyarrow
, nixpkgs-hardenedlinux-sources
, rmm
}:

python3Packages.buildPythonPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.cudf) pname version src;

  preConfigure = ''
    export CUDA_HOME=${cudatoolkit}
    export LD_LIBRARY_PATH=${cudatoolkit}/lib

    #ln -s rmm-src //include/rmm cpp/include/rmm
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

  meta = with lib; {
    description = "cuDF - GPU DataFrame Library ";
    homepage = "https://github.com/rapidsai/cudf";
    license = licenses.asl20;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}
