{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "Axelrod";
  version = "4.9.1";
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    python = "py2.py3";
    platform = "any";
    sha256 = "00274jaa6cxviq1zdlyvd4mcgmrishdfw901gamcy7xlc1mdf0zf";
  };
  propagatedBuildInputs = with python3Packages; [ 
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "https://github.com/Axelrod-Python/Axelrod";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
