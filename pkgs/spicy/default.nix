{ stdenv, cmake, flex, bison, python38, zlib, llvmPackages_9, fetchFromGitHub, which, ninja, git }:

stdenv.mkDerivation rec {
  version = "master";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "abd410f6cbb3398d4f1c1890871cb2ccdf3694db";
    fetchSubmodules = true;
    sha256 = "sha256-pcioxNO/fis8o1YQEX7qq1+pbxy90AaFw7oE/dVwTMU=";
  };


  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [
    which
    # ninja
    python38
    git
    llvmPackages_9.clang-unwrapped
    llvmPackages_9.llvm
    llvmPackages_9.lld
  ];

  preConfigure = ''
    patchShebangs ./scripts
  '';

  cmakeFlags = [
    # "-DCMAKE_CXX_COMPILER=${llvmPackages_9.clang}/bin/clang++"
    # "-DCMAKE_C_COMPILER=${llvmPackages_9.clang}/bin/clang"
    # "-DCXX_SYSTEM_INCLUDE_DIRS=${llvmPackages_9.libcxx}/include/c++/v1"
    "-DHILTI_HAVE_JIT=true"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = https://docs.zeek.org/projects/spicy/en/latest/;
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
