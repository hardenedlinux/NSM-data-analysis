let
  pkgs = (import ../nix/nixpkgs.nix ) {};
in
with pkgs;
pkgs.stdenv.mkDerivation rec {
  version = "master";
  name = "spicy";
  src = fetchFromGitHub {
    owner = "zeek";
    repo = "spicy";
    rev = "ff5b3c233461835070aa8abd4cc3cbd24e0ad2bf";
    fetchSubmodules = true;
    sha256 = "1701bj5l9pc6cnbjwj8m27mwclrwbjalgfi8wzm2dyfpcx1c5vx7";
  };


  nativeBuildInputs = with pkgs;[ cmake flex bison  python38 zlib
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

  meta = with pkgs.stdenv.lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = http://zeek.org;
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
