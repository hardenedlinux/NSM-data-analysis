{ stdenv
, python3Packages
, fetchurl
}:

python3Packages.buildPythonPackage rec {

  pname = "pyshark";
  version = "v0.4.2.11";
  src = fetchurl {
    url = "https://github.com/KimiNewt/pyshark/archive/v0.4.2.11.tar.gz";
    sha256 = "0jlpbk0w9xlir1f82z6512v54214c555q6zcn8v1nkm0xkdgsna3";
  };  
  preConfigure = "cd src";
  propagatedBuildInputs = with python3Packages; [ py
                                                  pytest
                                                  mock
                                                  lxml
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "Python wrapper for tshark, allowing python packet parsing using wireshark dissectors";
    homepage = "https://github.com/KimiNewt/pyshark";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
