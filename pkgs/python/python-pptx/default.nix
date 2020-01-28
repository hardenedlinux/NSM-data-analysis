{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
    pname = "python-pptx";
    version = "0.6.18";
    src = fetchPypi {
      inherit pname version;
      sha256 = "a857d69e52d7e8a8fb32fca8182fdd4a3c68c689de8d4e4460e9b4a95efa7bc4";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ lxml
                                                    XlsxWriter
                                                    pillow
                                                  ];
}
