let
  result = import ./machnix.nix;
  python = pkgs.python37;
  pkgs = (import <nixpkgs> { config = {}; overlays = []; });
  manylinux1 = pkgs.pythonManylinuxPackages.manylinux1;
  overrides = result.overrides manylinux1 pkgs.autoPatchelfHook;
  py = pkgs.python37.override { packageOverrides = overrides; };
in
py.withPackages (ps: result.select_pkgs ps)
