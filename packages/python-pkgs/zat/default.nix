{ stdenv
, lib
, python3Packages
, nixpkgs-hardenedlinux-sources
}:

python3Packages.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.zat) pname src version;

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
