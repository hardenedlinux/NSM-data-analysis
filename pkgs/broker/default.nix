{stdenv, fetchgit, cmake, gcc, openssl, caf, python3, ncurses5}:

stdenv.mkDerivation rec {
    version = "master";
    name = "broker";
    src = fetchgit {
      url = "https://github.com/zeek/broker.git";
      rev = "237c3cd2d87d467a5b9ac0517c6461ac00c7b85c";
      fetchSubmodules = true; = true;
      sha256 = "0rlz55w6v6sizxdd0ixb43yi0vnx6di4ipw06y3zl9mdmh7s5hbx";
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
