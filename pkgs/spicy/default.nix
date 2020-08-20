{stdenv, cmake, flex, bison, python38, zlib, llvmPackages_9, fetchFromGitHub, which, ninja}:

stdenv.mkDerivation rec {
  version = "master";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "193742cd1d197910dbc2b905e1e3ada7d968d480";
    fetchSubmodules = true;
    sha256 = "sha256-7OaKsiyqLAR/eeVWwT/sk2KZYnI2yqjB4DuQH7b2/to=";
  };


  nativeBuildInputs = [ cmake flex bison ];
  buildInputs = [ which
                  # ninja
                  python38
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
