{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
pname = "python-whois";
    version = "0.7.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "79793794788d49f28430f75cb92b22b0ee59b0210a7e8519494b47fa70e6ec3b";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ future ];
}
