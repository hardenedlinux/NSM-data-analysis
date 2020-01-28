{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "CherryPy";
  version = "18.5.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "63b2f61c38c469112145bd4e4e2385cd18f3233799e7a33bd447df468916d22b";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ setuptools_scm
                                                  more-itertools
                                                  cheroot
                                                  portend
                                                  zc_lockfile
                                                  jaraco_collections
                                                ];
}
