{ lib
, fetchFromGitHub
, python3Packages
, nixpkgs-hardenedlinux-sources
, eZeeKonfigurator_client-requirements
}:

python3Packages.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.eZeeKonfigurator_client) pname version src;

  propagatedBuildInputs = with python3Packages; [
    eZeeKonfigurator_client-requirements
  ];


  meta = with lib; {
    description = "client-side half of eZeeKonfigurator";
    homepage = "https://github.com/esnet/eZeeKonfigurator_client";
  };
}
