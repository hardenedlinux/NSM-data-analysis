with import <nixpkgs> {};
pkgs.buildEnv rec {
  name = "test";
  paths = [
    (import ./python.nix)
          ];
}
