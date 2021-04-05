{ stdenv
, cmake
, flex
, bison
, python38
, zlib
, llvmPackages
, fetchFromGitHub
, which
, ninja
, lib
, makeWrapper
, glibc
, SpicyPlugin ? true
, zeekTLS
}:
let
  spicy-analyzers = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy-analyzers";
    rev = "26696b65574faf6282aaa5e7836fda1f43a09092";
    sha256 = "136bf69rwgii0wl9m1chji9778i4g0hr6073v3a2bm8n0q43x5w8";
  };
in
stdenv.mkDerivation rec {
  version = "2021-03-30";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "c5b3923ac81d8b1ef8071e0b9ba3b2cd529ca2db";
    fetchSubmodules = true;
    sha256 = "0d22880acwinrq9nyn4yhykp4fgrqckmx8rf3l3p8k2ssbllh0fh";
  };


  nativeBuildInputs = [
    cmake
    flex
    bison
    python38
    zlib
    ninja
  ];

  buildInputs = [
    which
    llvmPackages.clang-unwrapped
    llvmPackages.llvm
    makeWrapper
  ] ++ lib.optionals SpicyPlugin [ zeekTLS ];

  preConfigure = ''
    patchShebangs ./scripts/autogen-type-erased
    patchShebangs ./scripts/autogen-dispatchers
  '';

  patches = [ ./version.patch ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=${llvmPackages.clang}/bin/clang++"
    "-DCMAKE_C_COMPILER=${llvmPackages.clang}/bin/clang"
  ];

  postFixup = ''
    for e in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$e \
        --set CLANG_PATH      "${llvmPackages.clang}/bin/clang" \
        --set CLANGPP_PATH    "${llvmPackages.clang}/bin/clang++" \
        --set LIBRARY_PATH    "${lib.makeLibraryPath [ flex bison python38 zlib glibc llvmPackages.libclang llvmPackages.libcxxabi llvmPackages.libcxx ]}"
     done
     ${lib.optionalString SpicyPlugin
      ''
      cp -r ${spicy-analyzers} /build/spicy-analyzers
      chmod 755  /build/spicy-analyzers/
      substituteInPlace /build/spicy-analyzers/CMakeLists.txt \
      --replace "0.4" "0" \
      --replace "00400" "0"
      cd /build/spicy-analyzers
      mkdir build && cd build
      cmake -DCMAKE_INSTALL_PREFIX=$out ..
      make -j $NIX_BUILD_CORES && make install
      ''
      }
  '';

  meta = with lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = https://docs.zeek.org/projects/spicy/en/latest/;
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
