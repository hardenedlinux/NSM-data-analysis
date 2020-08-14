let
  overlays = [
    (import ../../nix/python-packages-overlay.nix)
  ];

  pkgs = import <nixpkgs-test> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  
in
{
  hardenedlinux-pkg-python-clx-env = pkgs.buildEnv {
    name = "python-cudf";
    paths = with pkgs; [
      (pkgs.python3.withPackages (ps: [ ps.cudf ]))
    ];
  };
}
