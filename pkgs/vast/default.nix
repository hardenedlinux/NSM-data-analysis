{stdenv, fetchFromGitHub, cmake, pandoc, gcc, caf, pkgconfig, arrow-cpp, openssl, doxygen, libpcap,
  gperftools, clang, git, python3Packages, jq, tcpdump}:

let

  python = python3Packages.python.withPackages( ps: with ps; [
    coloredlogs
    jsondiff
    pyarrow
    pyyaml
    schema
  ]);

in

stdenv.mkDerivation rec {
    version = "0.2";
    name = "vast";
    src = fetchFromGitHub {
      owner = "tenzir";
      repo = "vast";
      rev = "f88106e04f78ed3432898457915d859c1dfe37d5";
      fetchSubmodules = true;
      sha256 = "18zb944gzw957wy3bmflnzhz0yzkhc7m7iwbjsdfh7nh042wa4px";
    };

    
  nativeBuildInputs = [ cmake pkgconfig openssl arrow-cpp caf];
  buildInputs = [ cmake gcc caf arrow-cpp openssl doxygen libpcap pandoc
                  gperftools];

   cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DNO_AUTO_LIBCPP=ON"
    "-DENABLE_ZEEK_TO_VAST=OFF"
    "-DNO_UNIT_TESTS=ON"
  ];


  preConfigure = ''
     export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/lib
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
