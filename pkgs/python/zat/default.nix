{ stdenv
, python3Packages
, fetchgit
}:


python3Packages.buildPythonPackage rec {
  pname = "zat";
  version = "master";
  src = fetchgit {
    url = "https://github.com/SuperCowPowers/zat.git";
    rev = "953c437a64a940673092c868628642db9726e27a";
    sha256 = "1gdy823zxdlk8r8jmawi2d9m3hy6xdsx2kxfms6l9bzqpigc6ywh";
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
