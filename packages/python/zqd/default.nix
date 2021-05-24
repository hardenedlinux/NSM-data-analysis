{ lib
, python3Packages
, fetchgit
, python3
}:

python3Packages.buildPythonPackage rec {

  pname = "zqd";
  version = "2021-03-19";
  src = fetchgit {
    url = "https://github.com/brimsec/zq";
    rev = "9d71fc4c0ad148e354bccd58772e4aef4d70aa9a";
    sha256 = "1w5sh886ymn2ql4hq3g5ldf9sd8m7q359rw9h13448v9brakidc6";
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
