{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "PyPDF2";
  version = "1.26.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "e28f902f2f0a1603ea95ebe21dff311ef09be3d0f0ef29a3e44a932729564385";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ ];
}
