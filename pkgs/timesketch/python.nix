let
  result = import ./machnix.nix;
  nixpkgs_commit = "14dd961b8d5a2d2d3b2cf6526d47cbe5c3e97039";
  nixpkgs_sha256 = "07nc06mff31hwg6d7spnabfbipxjxhg856z1gcwbyr1cx299y996";
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
