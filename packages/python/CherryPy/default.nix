{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "CherryPy";
  version = "18.6.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "16f410izp2c4qhn4n3l5l3qirmkf43h2amjqms8hkl0shgfqwq2n";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    setuptools_scm
    more-itertools
    cheroot
    portend
    zc_lockfile
    jaraco_collections
  ];
}
