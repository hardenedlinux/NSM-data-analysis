{ stdenv
, lib
, python3Packages
, fetchgit
, callPackage
}:
python3Packages.buildPythonPackage rec {
  pname = "zat";
  version = "2021-03-08";

  src = fetchgit {
    url = "https://github.com/SuperCowPowers/zat.git";
    rev = "62718471a2f2d77c4c13b93f665f1eb9a892fa10";
    sha256 = "0ynhkdfb0ypxk23a89rmvf6bvck2jh00qgx9qrvadvc2k3mhlcm1";
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

  meta = with lib; {
    description = "Bro Analysis Tools (BAT): Processing and analysis of Bro network data with Pandas, scikit-learn, and Spark";
    homepage = "https://github.com/SuperCowPowers/bat";
    license = licenses.asl20;

  };

}
