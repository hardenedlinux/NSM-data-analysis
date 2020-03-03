{ stdenv
, python3Packages
, fetchurl
}:

python3Packages.buildPythonPackage rec {

  pname = "clx";
  version = "0.2.0";
  src = fetchurl {
    url = "https://github.com/rapidsai/clx/archive/v${version}.tar.gz";
    sha256 = "1nqx6glivqjjazrihwp2hz5y80hp7h3lms4sjady7ziiwqncbjq7";
  };  

  propagatedBuildInputs = with python3Packages; [ confluent-kafka
                                                   
                                                 ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "A collection of RAPIDS examples for security analysts, data scientists, and engineers to quickly get started applying RAPIDS and GPU acceleration to real-world cybersecurity use cases.
";
    homepage = "https://github.com/rapidsai/clx";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
