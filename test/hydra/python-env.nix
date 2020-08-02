let
  overlays = [
    (import ../../nix/python-packages-overlay.nix)
  ];

  hardenedlinux-pkgs-python = (import ../../pkgs/python.nix {inherit pkgs ;});
  pkgs = import <nixpkgs> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  
in
{
  hardenedlinux-pkg-python-env = pkgs.buildEnv {
    name = "Env-python";
    paths = with pkgs; [
      hardenedlinux-pkgs-python
    ];
  };
}
