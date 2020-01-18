{stdenv, fetchFromGitHub, cmake, gcc, openssl, caf, python3, ncurses5}:

stdenv.mkDerivation rec {
    version = "master";
    name = "broker";
    src = fetchFromGitHub {
      owner = "zeek";
      repo = "broker";      
      rev = "237c3cd2d87d467a5b9ac0517c6461ac00c7b85c";
      fetchSubmodules = true;
      sha256 = "0v0wphzpnwii26l9vsdy8dgb5xvmrayaxhfcj5yl5ljrbi3d11zl";
    };

    
  nativeBuildInputs = [ cmake openssl];
  buildInputs = [ cmake gcc openssl caf ncurses5];

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
    maintainers = with maintainers; [ GTrunSec ];
    platforms = with platforms; linux;
  };
}
