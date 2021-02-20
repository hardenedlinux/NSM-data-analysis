let
  overlays = [
    (import ../../nix/packages-overlay.nix)
  ];

  pkgs = import <nixpkgs> { inherit overlays; config = { allowUnfree = true; allowBroken = true; }; };
  hardenedlinux-pkgs-go = (import ../../pkgs/go.nix { inherit pkgs; });

in
{
  hardenedlinux-pkgs-vast = pkgs.buildEnv {
    name = "nsm-vast";
    paths = with pkgs; [
      pkgs.vast
    ];
    ignoreCollisions = true; ##for broker
  };

  hardenedlinux-pkgs-broker = pkgs.buildEnv {
    name = "broker";
    paths = with pkgs; [
      broker
    ];
  };

  hardenedlinux-pkgs-go = pkgs.buildEnv {
    name = "hardenedlinux-pkgs-go";
    paths = with pkgs; [
      hardenedlinux-pkgs-go
    ];
  };
}
