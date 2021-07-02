{ lib
, python3Packages
, nixpkgs-hardenedlinux-sources
, broker
}:
python3Packages.buildPythonPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.broker-to-json) pname version src;
  doCheck = false;

  nativeBuildInputs = [ broker ];

  meta = with lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
