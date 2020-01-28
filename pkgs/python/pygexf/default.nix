{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
pname = "pygexf";
    version = "0.2.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "5ee8549f2bc9140743d48deb5218bf6ab6492d818e6bd594046a8abd7a643797";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ ];
}
