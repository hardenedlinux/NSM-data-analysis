{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
    pname = "secure";
    version = "0.2.1";
    src = fetchPypi {
      inherit pname version;
      sha256 = "4dc8dd4b548831c3ad7f94079332c41d67c781eccc32215ff5a8a49582c1a447";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ ];

}
