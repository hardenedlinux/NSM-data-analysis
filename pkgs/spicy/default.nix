{stdenv, cmake, flex, bison, python38, zlib, llvmPackages_9, fetchFromGitHub, which, ninja }:


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


  nativeBuildInputs = [ cmake flex bison  python38 zlib
                                  llvmPackages_9.clang-unwrapped llvmPackages_9.llvm
                                ];
  buildInputs = [ which llvmPackages_9.lld ninja ];

  preConfigure = ''
   patchShebangs ./scripts/autogen-type-erased
   patchShebangs ./scripts/autogen-dispatchers
'';

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=${llvmPackages_9.clang}/bin/clang++"
    "-DCMAKE_C_COMPILER=${llvmPackages_9.clang}/bin/clang"
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
