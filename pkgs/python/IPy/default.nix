{ stdenv
, python3Packages
, fetchurl
}:

python3Packages.buildPythonPackage rec {

  pname = "IPy";
  version = "1.00";
  src = fetchurl {
    url = "https://github.com/autocracy/python-ipy/archive/IPy-${version}.tar.gz";
    sha256 = "0hydd488mgxzdq9ynd2i4plh08wwiylbdxk5j1v8r4y9imsca89j";
  };  

  propagatedBuildInputs = with python3Packages; [
                                                   
                                                 ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "IPy are a Python class and tools for handling of IPv4 and IPv6 addresses and networks. It is similar to Net::IP Perl module.";
    homepage = "https://github.com/autocracy/python-ipy";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
