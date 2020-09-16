{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {

  pname = "btest";
  version = "0.62";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-UOsu8gvdVh4GyY+EGEYEnh2AcoRIpy2U2YUS6LjaGBM=";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A Simple Driver for Basic Unit Tests";
    homepage = "https://github.com/zeek/btest";
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
