{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
    pname = "pyOpenSSL";
    version = "19.1.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ six
                                                    cryptography
                                                  ];
}
