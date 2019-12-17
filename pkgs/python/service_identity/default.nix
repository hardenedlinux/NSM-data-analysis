{ stdenv
, python3Packages
, fetchgit
}:

python3Packages.buildPythonPackage rec {
  pname = "service_identity";
  version = "master";
  src = python3Packages.fetchPypi {
    pname = "service_identity";
    version = "18.1.0";
    sha256 = "0b9f5qiqjy8ralzgwjgkhx82h6h8sa7532psmb8mkd65md5aan08";
  };


  propagatedBuildInputs = with python3Packages; [ bcrypt
                                                  pyopenssl
                                                  pyasn1-modules
                                                  attrs
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "Service identity verification for pyOpenSSL & cryptography.";
    homepage = "https://service-identity.readthedocs.io/en/stable/";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
