{ stdenv
, cmake
, flex
, bison
, python38
, zlib
, llvmPackages_9
, fetchFromGitHub
, which
, ninja
, lib
, makeWrapper
, glibc
}:

stdenv.mkDerivation rec {
  version = "2021-03-18";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "9915a5f38d6dc6993984dfd93f8b441cb094b83d";
    fetchSubmodules = true;
    sha256 = "1wnf8gh4xl1160vign87qikp0qi355lr080ip7a03cdw0r3c3v7r";
  };


  nativeBuildInputs = [
    cmake
    flex
    bison
    python38
    zlib
    #ninja
  ];
  buildInputs = [
    which
    llvmPackages_9.clang-unwrapped
    llvmPackages_9.llvm
    makeWrapper
  ];

  preConfigure = ''
    patchShebangs ./scripts/autogen-type-erased
    patchShebangs ./scripts/autogen-dispatchers
  '';

  patches = [ ./version.patch ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=${llvmPackages_9.clang}/bin/clang++"
    "-DCMAKE_C_COMPILER=${llvmPackages_9.clang}/bin/clang"
  ];

  postFixup = ''
    for e in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$e \
        --set CLANG_PATH      "${llvmPackages_9.clang}/bin/clang" \
        --set CLANGPP_PATH    "${llvmPackages_9.clang}/bin/clang++" \
        --set LIBRARY_PATH    "${lib.makeLibraryPath [ flex bison python38 zlib glibc llvmPackages_9.libclang llvmPackages_9.libcxxabi llvmPackages_9.libcxx ]}"
     done
  '';

  meta = with lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = https://docs.zeek.org/projects/spicy/en/latest/;
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
