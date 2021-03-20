{ stdenv
, lib
, python3Packages
, fetchgit
, python3
}:

python3Packages.buildPythonPackage rec {

  pname = "zqd";
  version = "master";
  src = fetchgit {
    url = "https://github.com/brimsec/zq";
    rev = "951d89075f3fec22da164469d37de94b370c473e";
    sha256 = "sha256-cy1VzrlEqoI/H3zel2ex1lEG5BgAWmCgO1m8TynTSzA=";
  };

  propagatedBuildInputs = with python3Packages; [
    requests
  ];
  doCheck = false;

  postPatch = ''
    cd python/zqd
  '';

  meta = with lib; {
    description = "Search and analysis tooling for structured logs";
    homepage = "https://github.com/brimsec/zq";
    license = licenses.bsd3;

  };

}
