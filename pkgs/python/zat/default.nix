{ stdenv
, python3Packages
, fetchgit
}:


python3Packages.buildPythonPackage rec {
  pname = "zat";
  version = "v0.3.8";
  src = fetchgit {
   # url = "https://github.com/SuperCowPowers/${pname}/archive/v${version}.tar.gz";
    url = "https://github.com/SuperCowPowers/zat.git";
    rev = "477bcf7f734777e3dba9aadde344f5be3e6bb8fa";
    sha256 = "09v17rc3r7cz7jcfdf9idy16gg2jd944qp3w4j2ggiycxgamzy4m";
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
