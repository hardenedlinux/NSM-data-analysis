{stdenv, fetchurl, cmake, pandoc, gcc, caf, pkgconfig, arrow-cpp, openssl, doxygen, libpcap,
  gperftools, clang, git, python3Packages, jq, tcpdump, lib}:

let
  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

  python = python3Packages.python.withPackages( ps: with ps; [
    coloredlogs
    jsondiff
    pyarrow
    pyyaml
    schema
  ]);

in

stdenv.mkDerivation rec {
    version = "2020.04.29";
    name = "vast";
    src = fetchurl {
      url = "https://github.com/tenzir/vast/archive/${version}.tar.gz";
      sha256 = "0935r513si84l46dmnsj7p4gc2b3ih3x2qqcg9air9b53ahrc2ic";
    };

    
  nativeBuildInputs = [ cmake pkgconfig openssl arrow-cpp caf];
  buildInputs = [ cmake gcc caf arrow-cpp openssl doxygen libpcap pandoc
                  gperftools];

   cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DNO_AUTO_LIBCPP=ON"
    "-DENABLE_ZEEK_TO_VAST=OFF"
    "-DNO_UNIT_TESTS=ON"
    "-DVAST_VERSION_TAG=${version}"
  ];


 preConfigure = ''
    substituteInPlace cmake/FindPCAP.cmake \
      --replace /bin/sh "${stdenv.shell}" \
      --replace nm "''${NM}"
  '';

 dontStrip = isCross;
 postFixup = lib.optionalString isCross ''
   ${stdenv.cc.targetPrefix}strip -s $out/bin/vast
   ${stdenv.cc.targetPrefix}strip -s $out/bin/zeek-to-vast
  '';

   installCheckInputs = [ jq python tcpdump ];

   installCheckPhase = ''
    $PWD/integration/integration.py --app ${placeholder "out"}/bin/vast
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = " Visibility Across Space and Time";
    homepage = http://vast.io;
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
