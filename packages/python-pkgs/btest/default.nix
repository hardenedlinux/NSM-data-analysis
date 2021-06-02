{ lib
, pythonPackages
, python3
, sources
}:
with python3.pkgs;
pythonPackages.buildPythonPackage rec {
  inherit (sources.btest) pname version src;
  doCheck = false;

  meta = with lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
