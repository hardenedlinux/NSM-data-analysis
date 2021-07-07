{ lib
, fetchFromGitHub
, python3Packages
, nixpkgs-hardenedlinux-sources
, machlib
, broker-json
, broker
}:
let
  eZeeKonfigurator-requirements = machlib.mkPython rec {
    #requirements = builtins.readFile (nixpkgs-hardenedlinux-sources.eZeeKonfigurator.src + "/requirements_common.txt") + ''
    requirements = ''
      setuptools-rust
      multidict==4.7.6
      chardet==3.0.4
      pyasn1==0.4.8
      aiohttp-sse-client==0.2.1
      channels==3.0.3
      Django==3.2.4
      django-crispy-forms==1.12.0
      django-eventstream==4.2.0
      GitPython==3.1.18
      requests==2.25.1
      gitdb2==4.0.2
      psycopg2==2.9.1
    '';
  };
in
python3Packages.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.eZeeKonfigurator) pname version src;

  nativeBuildInputs = [ ];

  propagatedBuildInputs = with python3Packages; [
    eZeeKonfigurator-requirements
    broker-json
    broker
  ];

  postPatch = ''
    substituteInPlace requirements_common.txt \
    --replace "broker_json==0.2" ""
  '';

  doCheck = false;

  meta = with lib;
    {
      description = "Web-based configuration for your Zeek clusters";
      homepage = "https://github.com/esnet/eZeeKonfigurator";
    };
}
