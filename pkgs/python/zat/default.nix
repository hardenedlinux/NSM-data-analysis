{ stdenv
, python3Packages
, fetchgit
, callPackage
}:
python3Packages.buildPythonPackage rec {
  pname = "zat";
  version = "master";

  src = fetchgit {
    url = "https://github.com/SuperCowPowers/zat.git";
    rev = "d6d015662e8f8e1b2e8c3f540c466187116f1072";
    sha256 = "sha256-Bto0ZPL8/Ee0M1loHCzxB7ALkoB8eaB7NNACtNleyc4=";
  };  



  propagatedBuildInputs = with python3Packages; [ pandas
                                                  scikitlearn
                                                  pyarrow
                                                  requests
                                                  watchdog
                                                  numpy
                                                  pyspark
                                                ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "Bro Analysis Tools (BAT): Processing and analysis of Bro network data with Pandas, scikit-learn, and Spark";
    homepage = "https://github.com/SuperCowPowers/bat";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
