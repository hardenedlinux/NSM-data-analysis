{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "pyvis";
  version = "0.1.7.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "02p4r540wyp5kxhrvjfr9lqflb50c9fn2rp9r4m1ay0pknx2pjw1";
  };  
  propagatedBuildInputs = with python3Packages; [ jinja2
                                                  ipython
                                                   networkx
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "A Python network visualization library";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
