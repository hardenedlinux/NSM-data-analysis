{ lib
, python3Packages
, fetchgit
, python3
, nixpkgs-hardenedlinux-sources
, elastalert2-requirements
}:
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
