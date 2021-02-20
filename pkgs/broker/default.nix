{ stdenv, fetchFromGitHub, cmake, gcc, openssl, caf, python3, ncurses5 }:

stdenv.mkDerivation rec {
  version = "master";
  name = "broker";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "4e509c0b35014e7fb79442e0e61a0ae0f67ffcb5";
    fetchSubmodules = true;
    sha256 = "095kdnfj1d3fxnfqf5qm19qs2nsrkxsf1mnwa6hvr39ni6aymv4a";
  };


  nativeBuildInputs = [ cmake openssl ];
  buildInputs = [ cmake gcc openssl caf ncurses5 ];

  cmakeFlags = [
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python3.sitePackages}"
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DPYTHON_EXECUTABLE=${python3}/bin/python"
  ];

  postInstall = ''
    ln -s $out/${python3.sitePackages}/broker/_broker.so $out/lib
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Zeek's Messaging Library";
    homepage = http://zeek.org;
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
