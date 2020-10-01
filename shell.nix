{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [
    (pkgs.python3.withPackages (ps: [ ps.zat ]))
    pkgs.vast
  ];
}
