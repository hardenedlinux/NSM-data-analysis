{ stdenv
, python3Packages
, fetchurl
, cudatoolkit
, rmm
}:
python3Packages.buildPythonPackage rec {

  pname = "cudf";
  version = "0.12.0";
  src = fetchurl {
    url = "https://github.com/rapidsai/cudf/archive/cfb1f6b6e00964ce51a781223b29650d6801f818.tar.gz";
    sha256 = "sha256-CRHf8wbS53zB1yehTPhbbC3FHFhcrSrKt/xWqJ1n1OY=";
  };  

  preConfigure = ''
    export CUDA_HOME=${cudatoolkit}
    cd python/cudf
  '';
  nativeBuildInputs = [ cudatoolkit ];
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
