{ ... }:
let
  pkgs = (import <nixpkgs> {});
  my-python = (import ./pkgs/python.nix {inherit pkgs;});
  my-go =  (import ./pkgs/go.nix {inherit pkgs;});
  my-R = (import ./pkgs/R.nix {inherit pkgs;});

  foo = self: super: {
    haskell = super.haskell // { packageOverrides =
	    hself: hsuper: {
        my-random-fu-multivariate = hself.callPackage ./pkgs/haskell/my-random-fu-multivariate { };
        i-inline-c = hself.callHackage "inline-c" "0.8.0.1" {};
        i-inline-r = hself.callHackage "inline-r" "0.10.2" {};
      };
                               };
  };

  haskell-pkgs  = import <haskell-pkgs> { overlays = [ foo];  config={ allowUnfree=true; allowBroken=true; ignoreCollisions = true;};};

  ihaskellEnv = (import (<ihaskell> + "/release-8.6.nix") {
    compiler = "ghc865";
    nixpkgs  = haskell-pkgs;
  packages = self: [
    self.inline-r
    self.hmatrix
    self.random-fu
    self.lens
    self.my-random-fu-multivariate
  ];
  }).passthru.ihaskellEnv;
in {
  zeek = pkgs.callPackage ./pkgs/zeek {};
  broker = pkgs.callPackage ./pkgs/broker {};
  vast = pkgs.callPackage ./pkgs/vast {};

  nsm-data-analysis-haskell = pkgs.buildEnv {
  name = "nsm-data-analysis-haskell";
  paths =  [
    ihaskellEnv
  ];
  };

  nsm-data-analysis-R = pkgs.buildEnv {
  name = "nsm-data-analysis-R";
  paths = with pkgs; [
    my-go
  ];
  };
  # nsm-data-analysis-Julia = pkgs.buildEnv {
  # name = "nsm-data-analysis-Julia";
  # paths = with pkgs; [
  #   my-julia
  # ];
  # };

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
