{ stdenv
, python3Packages
, fetchurl
, cudatoolkit
}:
python3Packages.buildPythonPackage rec {

  pname = "cudf";
  version = "0.12.0";
  src = fetchurl {
    url = "https://github.com/rapidsai/cudf/archive/v${version}.tar.gz";
    sha256 = "0b09si7jalv4jq6jf41qcja7msbhgsysra9qv9jgm9nqfamryg9p";
  };  

  preConfigure = ''
    export CUDA_HOME=${cudatoolkit}
    cd python/cudf
  '';
  nativeBuildInputs = [ cudatoolkit ];
  propagatedBuildInputs = with python3Packages; [ numpy
                                                  versioneer
                                                  setuptools
                                                  (cython.overrideDerivation (oldAttrs: {
                                                    src = fetchPypi {
                                                      pname = "Cython";
                                                      version = "0.29.15";
                                                      sha256 = "0c5cjyxfvba6c0vih1fvhywp8bpz30vwvbjqdm1q1k55xzhmkn30";
                                                     };
                                                  }))
                                                  cysignals
                                                  tables
                                                  cupy
                                                  pyarrow
                                                  pandas
                                                  rmm
                                                  numba
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "cuDF - GPU DataFrame Library ";
    homepage = "https://github.com/rapidsai/cudf";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
