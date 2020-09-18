{stdenv, fetchurl, cmake, flex, bison, openssl, libpcap, zlib, file, curl
, libmaxminddb, gperftools, python, swig, fetchpatch, caf
## Plugin dependencies
,  rdkafka, postgresql, fetchFromGitHub, coreutils
,  callPackage, libnghttp2, brotli, python38, llvmPackages_9, which, geoip, lib, ccache
,  PostgresqlPlugin ? false
,  KafkaPlugin ? false
,  Http2Plugin ? false
,  SpicyPlugin ? false
,  zeekctl ? true
}:
let
  preConfigure = (import ./script.nix {inherit coreutils;});

  pname = "zeek";
  version = "3.0.10";
  confdir = "/var/lib/${pname}";

  plugin = callPackage ./plugin.nix {
    inherit version confdir PostgresqlPlugin KafkaPlugin zeekctl Http2Plugin SpicyPlugin llvmPackages_9;
  };
in
stdenv.mkDerivation rec {
  inherit pname version;
  src = fetchurl {
    url = "https://download.zeek.org/zeek-${version}.tar.gz";
    sha256 = "sha256-VaQ7NIk0Gsxv0ONMgPwfmgZeY+i2hQR0stoYft1CMZ4=";
  };

  configureFlags = [
    "--with-geoip=${geoip}"
    "--with-python=${python}/bin"
    "--with-python-lib=${python}/${python.sitePackages}"
  ];
  ##for spicy ccache
  HOME = ".";

  nativeBuildInputs = [ cmake flex bison file ] ++ lib.optionals SpicyPlugin [ python38 ];
  buildInputs = [ openssl libpcap zlib curl libmaxminddb gperftools python swig caf ]
                ++ lib.optionals KafkaPlugin
                  [ rdkafka ]
                ++ lib.optionals PostgresqlPlugin
                  [ postgresql ]
                ++ lib.optionals Http2Plugin
                  [ libnghttp2 brotli ]
                ++ lib.optionals SpicyPlugin
                  [ which ccache llvmPackages_9.lld llvmPackages_9.clang-unwrapped llvmPackages_9.llvm ];
  
  ZEEK_DIST = "${placeholder "out"}";
  #see issue https://github.com/zeek/zeek/issues/804 to modify hardlinking duplicate files.
  inherit preConfigure;

  enableParallelBuilding = true;

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
