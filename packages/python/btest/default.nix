{ lib
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "btest";
  version = "0.67";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1df5b1462b62efba6c718d8aa09b1d566cc18e93f50f84132fe96326c40305c1";
  };

  doCheck = false;

  meta = with lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
