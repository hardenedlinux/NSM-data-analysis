{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "textblob";
  version = "0.15.3";
  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-f/PADLWoWjATLuZ2i4xoyyuddkMv7BjNGz/+L4WU7Iw=";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ nltk ];
}
