{ stdenv
, lib
, python3Packages
, python3
, fetchurl
}:
python3Packages.buildPythonPackage rec {

  pname = "Axelrod";
  version = "v4.9.1";
  src = fetchurl {
    url = "https://github.com/Axelrod-Python/Axelrod/archive/${version}.tar.gz";
    sha256 = "01v0vc7hqfmyyrmd5w7bqb7nifa1wx468gxlh9hya2ccd5pmpgf3";
  };

  propagatedBuildInputs = with python3Packages; [
    pathlib
  ];
  doCheck = false;

  meta = with lib; {
    description = "https://github.com/Axelrod-Python/Axelrod";
    license = licenses.asl20;

  };

}
