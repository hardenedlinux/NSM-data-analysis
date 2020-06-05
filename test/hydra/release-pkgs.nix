{ ... }:
let
  overlays = [
    (import ../../nix/overlay/python-packages-overlay.nix)
  ];

  pkgs = import <nixpkgs> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  ##
  overlays1 = [
    (import ../../nix/overlay/time-python.nix)
  ];
  timepkgs  = import <nixpkgs> { overlays=overlays1; config={ allowUnfree=true; allowBroken=true; };};
  my-python = (import ./pkgs/python.nix {inherit pkgs timepkgs;});
  my-go =  (import ./pkgs/go.nix {inherit pkgs;});
  my-R = (import ./pkgs/R.nix {inherit pkgs;});



  zeek = pkgs.callPackage ./pkgs/zeek {};
  vast = pkgs.callPackage ./pkgs/vast {};

in {
  

  # nsm-data-analysis-haskell = pkgs.buildEnv {
  # name = "nsm-data-analysis-haskell";
  # paths =  [
  #   ihaskellEnv
  # ];
  # };

  nsm-data-analysis-vast = pkgs.buildEnv {
    name = "nsm-vast";
    paths = with pkgs; [
      vast
    ];
    ignoreCollisions = true; ##for broker
  };
  nsm-data-analysis-zeek = pkgs.buildEnv {
    name = "nsm-zeek";
    paths = with pkgs; [
      zeek
    ];
  };

  nsm-data-analysis-broker = pkgs.buildEnv {
    name = "broker";
    paths = with pkgs; [
      broker
    ];
  };
  nsm-data-analysis-R = pkgs.buildEnv {
    name = "nsm-data-analysis-R";
    paths = with pkgs; [
      my-go
    ];
  };

  nsm-data-analysis-python = pkgs.buildEnv {
    name = "nsm-data-analysis-python";
    paths = with pkgs; [
      my-python
    ];
  };
  nsm-data-analysis-go = pkgs.buildEnv {
    name = "nsm-data-analysis-go";
    paths = with pkgs; [
      my-go
    ];
  };
}
