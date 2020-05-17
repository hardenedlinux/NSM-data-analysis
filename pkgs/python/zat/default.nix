{ stdenv
, python3Packages
, fetchgit
}:


python3Packages.buildPythonPackage rec {
  pname = "zat";
  version = "master";
  src = fetchgit {
    url = "https://github.com/SuperCowPowers/zat.git";
    rev = "b22c908f1b46aa52f9677885e5001e22ec1cfb56";
    sha256 = "0c6dzz0vri5k4ff8bdcf696biiccrgz1npj3d3xrmcsfcg5xl9ij";
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
