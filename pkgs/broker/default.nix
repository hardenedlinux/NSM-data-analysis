{ stdenv, fetchFromGitHub, cmake, gcc, openssl, caf, python3, ncurses5 }:

stdenv.mkDerivation rec {
  version = "2021-02-26";
  name = "broker";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "broker";
    rev = "41d2109da960312995f54fae491e867c0621cc0e";
    fetchSubmodules = true;
    sha256 = "0l0vs4623z33cmfp8pkk5jrhy9d2jp6yrjcy88b41pkzg62bgnhb";
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
    platforms = with platforms; unix;
  };
}
