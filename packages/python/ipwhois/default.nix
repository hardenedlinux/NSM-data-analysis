{ python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "ipwhois";
  version = "1.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "831e3fef3b8041201a048e9456e3b80f45c6c8b7174f34ed211f66b596c84bbe";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [ dnspython ];
}
