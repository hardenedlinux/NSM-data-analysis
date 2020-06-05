let
  result = import ./machnix.nix {pkgs=pkgs;};
  # nixpkgs_commit = "14dd961b8d5a2d2d3b2cf6526d47cbe5c3e97039";
  # nixpkgs_sha256 = "07nc06mff31hwg6d7spnabfbipxjxhg856z1gcwbyr1cx299y996";
  pkgs = (import <nixpkgs> { config = {}; overlays = []; });
  python = pkgs.python37;
  manylinux1 = pkgs.pythonManylinuxPackages.manylinux1;
  overrides = result.overrides manylinux1 pkgs.autoPatchelfHook;
  py = pkgs.python37.override { packageOverrides = overrides; };
in
py.withPackages (ps: result.select_pkgs ps)
