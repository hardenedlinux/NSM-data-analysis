{ stdenv
, python3Packages
, fetchurl
}:

python3Packages.buildPythonPackage rec {

  pname = "networkx";
  version = "2.3";

  src = fetchurl {
    url = "https://github.com/networkx/networkx/archive/networkx-${version}.tar.gz";
    sha256 = "04s7szzn8xfrafvikk1p2jx7nx2sg2k322c4q3wnvj9qxxdnmj9n";
  };  

  propagatedBuildInputs = with python3Packages; [ decorator
                                                 ];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "Bro Analysis Tools (BAT): Processing and analysis of Bro network data with Pandas, scikit-learn, and Spark";
    homepage = "https://github.com/SuperCowPowers/bat";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
