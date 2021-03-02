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
    rev = "80ed0e7169cf544e9613b13d3bd3485f1dae9b92";
    sha256 = "sha256-2IHyiGdKJhNRAUx+/7OncmrE0L9VdaYBAobuoBOvBB4=";
  };



  propagatedBuildInputs = with python3Packages; [
    pandas
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
    
  };

}
