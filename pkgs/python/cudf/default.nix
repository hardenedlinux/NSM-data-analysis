{ stdenv
, python3Packages
, fetchgit
, cudatoolkit
, linuxPackages
}:
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
  cd python/cudf
  '';

  nativeBuildInputs = [ cudatoolkit  ];
  buildInputs = [ linuxPackages.nvidia_x11 ];
  propagatedBuildInputs = with python3Packages; [ numpy
                                                  versioneer
                                                  setuptools
                                                  # (cython.overrideDerivation (oldAttrs: {
                                                  #   src = fetchPypi {
                                                  #     pname = "Cython";
                                                  #     version = "0.29.15";
                                                  #     sha256 = "0c5cjyxfvba6c0vih1fvhywp8bpz30vwvbjqdm1q1k55xzhmkn30";
                                                  #    };
                                                  # }))
                                                  cysignals
                                                  cython
                                                  tables
                                                  cupy
                                                  pyarrow
                                                  pandas
                                                  numba
                                                  rmm
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "cuDF - GPU DataFrame Library ";
    homepage = "https://github.com/rapidsai/cudf";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
