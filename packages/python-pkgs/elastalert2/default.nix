{ lib
, python3Packages
, fetchgit
, python3
, nixpkgs-hardenedlinux-sources
, machlib
}:

let
  elastalert2-requirements = machlib.mkPython rec {
    requirements = builtins.readFile (nixpkgs-hardenedlinux-sources.elastalert2.src + "/requirements.txt");
  };
in
python3Packages.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.elastalert2) pname version src;

  propagatedBuildInputs = with python3Packages; [
    elastalert2-requirements
  ];

  doCheck = false;

  meta = with lib; {
    description = "Easy & Flexible Alerting With ElasticSearch";
    homepage = "https://github.com/Yelp/elastalert";
    license = licenses.asl20;
  };
}
