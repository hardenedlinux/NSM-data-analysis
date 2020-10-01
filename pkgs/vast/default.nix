{ stdenv, fetchFromGitHub, cmake, pandoc, gcc, caf, pkgconfig, arrow-cpp, openssl, doxygen, libpcap
, flatbuffers, libyamlcpp, jemalloc
, gperftools, clang, git, python3Packages, jq, tcpdump, lib, callPackage
, static ? stdenv.hostPlatform.isMusl
, disableTests ? true
}:

let
  broker = callPackage ../broker {};
  sCross = stdenv.buildPlatform != stdenv.hostPlatform;

  python = python3Packages.python.withPackages( ps: with ps; [
    coloredlogs
    jsondiff
    pyarrow
    pyyaml
    schema
  ]);

in

stdenv.mkDerivation rec {
  version = "2020.09.30";
  name = "vast";
  src = fetchFromGitHub {
    owner = "tenzir";
    repo = "vast";
    rev = "5c61ec39e7fb37bc61a443f8d7e52aa1f22a86c9";
    fetchSubmodules = true;
    sha256 = "sha256-ZnF4/0SyJ2V0yCyWPLdWgeN5ytFURw+EfRizuqLLgvI=";
  };

  nativeBuildInputs = [ cmake pkgconfig openssl arrow-cpp caf];

  buildInputs = [ cmake gcc caf arrow-cpp openssl doxygen libpcap pandoc
                  gperftools flatbuffers libyamlcpp jemalloc broker ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_SYSCONFDIR:PATH=/etc"
    "-DCMAKE_FIND_PACKAGE_PREFER_CONFIG=ON"
    "-DCAF_ROOT_DIR=${caf}"
    "-DVAST_RELOCATABLE_INSTALL=${if static then "ON" else "OFF"}"
    "-DVAST_VERSION_TAG=${version}"
    "-DVAST_USE_JEMALLOC=ON"
    "-DBROKER_ROOT_DIR=${broker}"
  ] ++ lib.optionals static [
    "-DVAST_STATIC_EXECUTABLE:BOOL=ON"
    "-DCMAKE_INTERPROCEDURAL_OPTIMIZATION:BOOL=ON"
  ] ++ lib.optional disableTests "-DBUILD_UNIT_TESTS=OFF";

  preConfigure = ''
    substituteInPlace cmake/FindPCAP.cmake \
      --replace /bin/sh "${stdenv.shell}" \
      --replace nm "''${NM}"
  '';

  dontStrip = true;

  hardeningDisable = lib.optional static "pic";

  installCheckInputs = [ jq python tcpdump ];

  installCheckPhase = ''
    python ../integration/integration.py --app ${placeholder "out"}/bin/vast
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = " Visibility Across Space and Time";
    homepage = http://vast.io;
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
