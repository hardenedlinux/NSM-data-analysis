{ stdenv
, python3Packages
, fetchgit
}:

let
  service-identity = python3Packages.fetchPypi {
    pname = "service_identity";
    version = "18.1.0";
    sha256 = "0b9f5qiqjy8ralzgwjgkhx82h6h8sa7532psmb8mkd65md5aan08";
  };
in

python3Packages.buildPythonPackage rec {
  pname = "honeygrove";
  version = "master";
  src = fetchgit {
    url = "https://github.com/UHH-ISS/honeygrove.git";
    rev = "28113ee80747f03ccc6d84a128d27f8c064515a5";
    sha256 = "1azrzncfjzkf84ayj00bc09gxp0wcg2jggxndhhv2xn81gcf6ikp";
  };  


  propagatedBuildInputs = with python3Packages; [ bcrypt
                                                  pyopenssl
                                                  geoip2
                                                  cryptography
                                                  twisted
                                                 ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "A multi-purpose, modular medium-interaction honeypot based on Twisted.";
    homepage = "https://github.com/UHH-ISS/honeygrove.git";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
