{ stdenv
, python3Packages
, fetchgit
}:


python3Packages.buildPythonPackage rec {
  pname = "zat";
  version = "master";
  src = fetchgit {
    url = "https://github.com/SuperCowPowers/zat.git";
    rev = "49ec5c24946a0c943a708355e7194c35b7ddd4e0";
    sha256 = "1i9lvax3sx605jrp90d2ds8in58kv2r8jbgb854rmk4blm3fxbka";
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
