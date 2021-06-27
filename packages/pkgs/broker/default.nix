{ stdenv, lib, fetchFromGitHub, cmake, gcc, openssl, caf, python3, ncurses5, nixpkgs-hardenedlinux-sources }:

stdenv.mkDerivation rec {
  name = "broker";
  inherit (nixpkgs-hardenedlinux-sources.broker) pname version src;

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

  meta = with lib; {
    description = "Zeek's Messaging Library";
    homepage = http://zeek.org;
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
