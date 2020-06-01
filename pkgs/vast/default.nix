{stdenv, fetchFromGitHub, cmake, pandoc, gcc, caf, pkgconfig, arrow-cpp, openssl, doxygen, libpcap,
  gperftools, clang, git, python3Packages, jq, tcpdump, lib
, static ? stdenv.hostPlatform.isMusl}:

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
    version = "2020.05.28";
    name = "vast";
    src = fetchFromGitHub {
      owner = "tenzir";
      repo = "vast";
      rev = "2fc75850336b1b44b4ecd06bbbe2ce6f94fd145e";
      fetchSubmodules = true;
      sha256 = "0m2lg3rsnrl7sni0n5cz9by8za5zqgczb5qnxsfh5ddrmpl930k7";
    };

  nativeBuildInputs = [ cmake pkgconfig openssl arrow-cpp caf];

  buildInputs = [ cmake gcc caf arrow-cpp openssl doxygen libpcap pandoc
                  gperftools ];

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DNO_AUTO_LIBCPP=ON"
    "-DENABLE_ZEEK_TO_VAST=OFF"
    "-DVAST_VERSION_TAG=${version}"
  ] ++ lib.optional static "-DVAST_STATIC_EXECUTABLE:BOOL=ON";


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
