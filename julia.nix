with import <nixpkgs> {};
 stdenv.mkDerivation {
  name = "julia_13";
  buildInputs = [
    pkgs.julia_13
  ];
}
