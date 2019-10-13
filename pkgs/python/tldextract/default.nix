{ stdenv
, python3Packages
, fetchurl
}:

python3Packages.buildPythonPackage rec {

  pname = "tldextract";
  version = "2.2.1";
  src = fetchurl {
    url = "https://github.com/john-kurkowski/tldextract/archive/${version}.tar.gz";
    sha256 = "137hwn7q3nblgcd985lbr2ia02aa5r08zh8r748ifwjqzf50xid2";
  };  

  propagatedBuildInputs = with python3Packages; [requests
                                                requests-file];
  doCheck = false;
  
  meta = with stdenv.lib; {
    description = "Accurately separate the TLD from the registered domain and subdomains of a URL, using the Public Suffix List.";
    homepage = "https://github.com/john-kurkowski/tldextract/releases";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
