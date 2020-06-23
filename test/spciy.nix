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


  nativeBuildInputs = with pkgs;[ cmake flex bison ninja ];
  buildInputs = [ python38 llvm clang_9 git which ];
  configureFlags = [
    "--with-zeek=${zeek}"
    "--generator=Ninja"
    "--enable-ccache"
  ];
  enableParallelBuilding = true;

  meta = with pkgs.stdenv.lib; {
    description = "C++ parser generator for dissecting protocols & files";
    homepage = http://zeek.org;
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
