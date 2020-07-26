{stdenv, cmake, flex, bison, python38, zlib, llvmPackages_9, fetchFromGitHub, which, ninja }:


stdenv.mkDerivation rec {
  version = "master";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "ce1a239d91f2df411814a594a3b3d8058c3e6192";
    fetchSubmodules = true;
    sha256 = "0gd57y1sdg7i2k9bacnqlakcm41s36311ngi2sqgk1phzmqaslv1";
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
