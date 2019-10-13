{ stdenv
, python3Packages
, fetchurl
}:

python3Packages.buildPythonPackage rec {

  pname = "netaddr";
  version = "0.7.19";
  src = fetchurl {
    url = "https://github.com/drkjam/netaddr/archive/netaddr-${version}.tar.gz";
    sha256 = "14wk6ric0bcqbwrpq13dvcdaw3nmjr2674mrcvpwnk6dpzhjkbni";
  };  

  propagatedBuildInputs = with python3Packages; [
                                                   
                                                 ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "A network address manipulation library for Python";
    homepage = "https://github.com/drkjam/netaddr";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
