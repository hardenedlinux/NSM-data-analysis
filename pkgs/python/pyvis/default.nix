{ lib
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "pyvis";
  version = "0.1.9";
  src = fetchPypi {
    inherit pname version;
    sha256 = "f9ea603025f31f02155760be638e6c443d992050a2e6942496fbba0586170cbf";
  };
  propagatedBuildInputs = with python3Packages; [
    jinja2
    ipython
    networkx
    jsonpickle
  ];

  doCheck = false;

  meta = with lib; {
    description = "A Python network visualization library";
    license = licenses.asl20;
  };
}
