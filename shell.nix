{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    pkgs.python3Packages.zat
    pkgs.vast
  ];
}
