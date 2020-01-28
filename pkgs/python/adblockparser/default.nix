{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "adblockparser";
  version = "0.7";
  src = fetchPypi {
    inherit pname version;
    sha256 = "7a3407ddc31a29e42732bbcb04f3677c6959bffa1ea9d712afd498e0b4d09b22";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ ];
}
