with import <nixpkgs> {};
let
  timesketch = pkgs.callPackage ./. {python3Packages=python37Packages;};
in
pkgs.mkShell rec {
  name = "timesketch";
  buildInputs = [
    timesketch
  ];
}
