{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "yara-python";
  version = "3.11.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "14pzm2qmpm3qm43ap10vpl1xzs8bfy32ic7m52qyvv7qdcnlkk94";
  };  
  propagatedBuildInputs = with python3Packages; [ 
                                                  
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "A Python network visualization library";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
