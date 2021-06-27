{ lib
, pythonPackages
, python3
, nixpkgs-hardenedlinux-sources
}:
with python3.pkgs;
pythonPackages.buildPythonPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.btest) pname version src;
  doCheck = false;

  meta = with lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
