{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, zlib, file, curl
, libmaxminddb, gperftools, python, swig, fetchpatch, caf
## Plugin dependencies
,  rdkafka, postgresql, fetchFromGitHub, coreutils
,  callPackage, libnghttp2, brotli, ninja, git, python38, llvm, clang_9, which, geoip, lib
,  PostgresqlPlugin ? false
,  KafkaPlugin ? false
,  Http2Plugin ? false
,  SpicyPlugin ? false
,  zeekctl ? true
}:
let
  preConfigure = (import ./script.nix {inherit coreutils;});

  pname = "zeek";
  version = "3.0.7";
  confdir = "/var/lib/${pname}";

  plugin = callPackage ./plugin.nix {
    inherit version confdir PostgresqlPlugin KafkaPlugin zeekctl Http2Plugin SpicyPlugin;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "1c0pxb2r8fhvnq2zbmw5z5q6asifipj6y5hpcqnsawy3q0ghv244";
  };

  configureFlags = [
    "--with-geoip=${geoip}"
    "--with-python=${python}/bin"
    "--with-python-lib=${python}/${python.sitePackages}"
  ];

  nativeBuildInputs = [ cmake flex bison file ] ++ lib.optionals SpicyPlugin [ python38 ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig caf ]
                ++ lib.optionals KafkaPlugin
                  [ rdkafka ]
                ++ lib.optionals PostgresqlPlugin
                  [ postgresql ]
                ++ lib.optionals Http2Plugin
                  [ libnghttp2 brotli ]
                ++ lib.optionals SpicyPlugin
                  [ ninja llvm clang_9 git which ];
  
  ZEEK_DIST = "${placeholder "out"}";
  #see issue https://github.com/zeek/zeek/issues/804 to modify hardlinking duplicate files.
  inherit preConfigure;

  enableParallelBuilding = true;

  patches = stdenv.lib.optionals stdenv.cc.isClang [
    # Fix pybind c++17 build with Clang. See: https://github.com/pybind/pybind11/issues/1604
    (fetchpatch {
      url = "https://github.com/pybind/pybind11/commit/759221f5c56939f59d8f342a41f8e2d2cacbc8cf.patch";
      sha256 = "0l8z7d7chq1awd8dnfarj4c40wx36hkhcan0702p5l89x73wqk54";
      extraPrefix = "aux/broker/bindings/python/3rdparty/pybind11/";
      stripLen = 1;
    })
  ];

  cmakeFlags = [
    "-DPYTHON_EXECUTABLE=${python}/bin/python2.7"
    "-DPYTHON_INCLUDE_DIR=${python}/include"
    "-DPYTHON_LIBRARY=${python}/lib"
    "-DPY_MOD_INSTALL_DIR=${placeholder "out"}/${python.sitePackages}"
    "-DENABLE_PERFTOOLS=true"
    "-DINSTALL_AUX_TOOLS=true"
    "-DINSTALL_ZEEKCTL=true"
    "-DZEEK_ETC_INSTALL_DIR=${placeholder "out"}/etc"
    "-DCAF_ROOT_DIR=${caf}"
  ];

  inherit (plugin) postFixup;
  
  meta = with stdenv.lib; {
    description = "Powerful network analysis framework much different from a typical IDS";
    homepage = "https://www.zeek.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pSub marsam tobim ];
    platforms = platforms.unix;
  };
}
