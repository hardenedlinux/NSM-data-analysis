{ lib
, python3Packages
, python3
, source
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  inherit (source) pname version src;
  doCheck = false;

  meta = with lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
