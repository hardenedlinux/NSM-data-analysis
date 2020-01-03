{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "cefpython3";
  version = "66.0";
  format = "wheel";
  src = fetchPypi {
    inherit pname version;
    format = "wheel";
    platform = "manylinux1_x86_64";
    #sha256 = "0az5l32p2f8rbgxfj32y5m1b21pjyfgyl1d297mbr26g9x6zjhxn";
    sha256 = "03j11cxrmfj09yjfwzly708fsq2gw0dnkq70ap3n1qmfnp1ii04v";
  };  
  #preConfigure = "cd src";
  propagatedBuildInputs = with python3Packages; [
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
