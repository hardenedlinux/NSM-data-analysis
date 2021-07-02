{ lib
, fetchFromGitHub
, python3Packages
, nixpkgs-hardenedlinux-sources
, eZeeKonfigurator-requirements
, broker-json
}:

python3Packages.buildPythonPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.eZeeKonfigurator) pname version src;
  nativeBuildInputs = [ ];
  propagatedBuildInputs = with python3Packages; [
    eZeeKonfigurator-requirements
    broker-json
  ];

  postPatch = ''
    substituteInPlace requirements_common.txt \
    --replace "broker_json==0.2" ""
  '';

  meta = with lib;
    {
      description = "Web-based configuration for your Zeek clusters";
      homepage = "https://github.com/esnet/eZeeKonfigurator";
    };
}
