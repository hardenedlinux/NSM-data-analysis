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
    version = "2020.02.27";
    name = "vast";
    # src = fetchFromGitHub {
    #   owner = "tenzir";
    #   repo = "vast";
    #   rev = "bffaeada156a6dd4fee4f61f8e24cce593d892ca";
    #   fetchSubmodules = true;
    #   sha256 = "1d29r89pzmhz6jvanndlscyb9q58x14n8ilbkg4bic5smndfgdsq";
    # };
    src = fetchurl {
      url = "https://github.com/tenzir/vast/archive/2020.02.27.tar.gz";
      sha256 = "14v5h40a2sppl37dix5rq8879q3r8ph5wic2qfprd4p1w120iq0n";
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
    maintainers = with maintainers; [ GTrunSec ];
    platforms = with platforms; linux;
  };
}
