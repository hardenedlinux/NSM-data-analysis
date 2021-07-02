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
    description = "Zeek Broker to JSON";
    homepage = "https://github.com/grigorescu/broker-to-json";
    license = "The Regents of the University of California through the Lawrence Berkeley National Laboratory. All rightsreserved";
    platforms = platforms.all;
  };
}
