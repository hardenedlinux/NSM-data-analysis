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
}:
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
  ];

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
  '';

  meta = with lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = https://docs.zeek.org/projects/spicy/en/latest/;
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
