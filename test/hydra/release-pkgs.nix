{ ... }:
let
  overlays = [
    (import ../../nix/python-packages-overlay.nix)
    (import ../../nix/packages-overlay.nix)
  ];

  pkgs = import <nixpkgs> {inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  ##
  overlays1 = [
    (import ../../nix/overlay/time-python.nix)
  ];

  timepkgs  = import <nixpkgs> { overlays=overlays1; config={ allowUnfree=true; allowBroken=true; };};

  my-python = (import ../../pkgs/python.nix {inherit pkgs timepkgs;});
  my-go =  (import ../../pkgs/go.nix {inherit pkgs;});
  my-R = (import ../../pkgs/R.nix {inherit pkgs;});

in {
  

  # Env-haskell = pkgs.buildEnv {
  # name = "Env-haskell";
  # paths =  [
  #   ihaskellEnv
  # ];
  # };

  Env-vast = pkgs.buildEnv {
    name = "nsm-vast";
    paths = with pkgs; [
      pkgs.vast
    ];
    ignoreCollisions = true; ##for broker
  };
  Env-zeek = pkgs.buildEnv {
    name = "nsm-zeek";
    paths = with pkgs; [
      (zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true;})
    ];
  };

  Env-broker = pkgs.buildEnv {
    name = "broker";
    paths = with pkgs; [
      broker
    ];
  };
  Env-R = pkgs.buildEnv {
    name = "Env-R";
    paths = with pkgs; [
      my-go
    ];
  };

  Env-python = pkgs.buildEnv {
    name = "Env-python";
    paths = with pkgs; [
      my-python
    ];
  };
  Env-go = pkgs.buildEnv {
    name = "Env-go";
    paths = with pkgs; [
      my-go
    ];
  };
}
