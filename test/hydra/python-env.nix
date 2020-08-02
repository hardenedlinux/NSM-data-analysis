let
  overlays = [
    (import ../../nix/python-packages-overlay.nix)
  ];

  overlays1 = [
    (import ../../nix/overlay/time-python.nix)
  ];

  timepkgs  = import <nixpkgs> { overlays=overlays1; config={ allowUnfree=true; allowBroken=true; };};
  hardenedlinux-pkgs-python = (import ../../pkgs/python.nix {inherit pkgs timepkgs;});
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
