let
  result = import ./machnix.nix;
  nixpkgs_commit = "441a7da8080352881bb52f85e910d8855e83fc55";
  nixpkgs_sha256 = "0093drxn7blw4hay41zbqzz1vhldil5sa5p0mwaqy5dn08yn4y3q";
  pkgs = import (builtins.fetchTarball {
    name = "nixpkgs";
    url = "https://github.com/nixos/nixpkgs/tarball/${nixpkgs_commit}";
    sha256 = nixpkgs_sha256;
  }) { config = {}; overlays = []; };
  python = pkgs.python37;
  manylinux1 = pkgs.pythonManylinuxPackages.manylinux1;
  overrides = result.overrides manylinux1 pkgs.autoPatchelfHook;
  py = pkgs.python37.override { packageOverrides = overrides; };
in
py.withPackages (ps: result.select_pkgs ps)
