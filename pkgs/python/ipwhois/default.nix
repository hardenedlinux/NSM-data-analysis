{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
    pname = "ipwhois";
    version = "1.1.0";
    src = fetchPypi {
      inherit pname version;
      sha256 = "904efbd8d5fbb3319fc7e3aa33923fdd272bb81fd5a04bd56fd9125be6437a71";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ dnspython ];
}
