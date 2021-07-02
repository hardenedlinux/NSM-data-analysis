{ lib
, fetchFromGitHub
, python3Packages
, nixpkgs-hardenedlinux-sources
, machlib
}:

machlib.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.eZeeKonfigurator) pname version src;

  meta = with lib; {
    description = "Web-based configuration for your Zeek clusters";
    homepage = "https://github.com/esnet/eZeeKonfigurator";
  };
}
