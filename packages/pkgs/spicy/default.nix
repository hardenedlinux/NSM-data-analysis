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
, source
}:
stdenv.mkDerivation rec {
  version = "2021-04-13";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "5fdc7493d7779208039c61003f110a987f8cbb45";
    fetchSubmodules = true;
    sha256 = "0wcqs3kf3fnsckpnq18dh1rqh0yrw1xcvm0vq6msbjgl1qqv5anx";
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
