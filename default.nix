let
  haskellOverlay = import ./pkgs/overlay/haskell-overlay.nix;
  jupyter-overlays = [
    # Only necessary for Haskell kernel
    (import ./pkgs/overlay/python.nix)
    haskellOverlay
    #hasktorchOverlay
  ];

  nixpkgsPath = jupyterLib + "/nix";


  jupyter-pkgs = import nixpkgsPath { overlays=jupyter-overlays; config={ allowUnfree=true; allowBroken=true; };};

  jupyter = import jupyterLib {pkgs=jupyter-pkgs;};

  jupyterLib = builtins.fetchGit {
    url = https://github.com/GTrunSec/jupyterWith;
    rev = "8df01f073116b8b88c7a2d659c075401e187121b";
    ref = "current";
  };


  overlays = [
    (import ./pkgs/Python-overlay.nix)
  ];
  
  nixpkgs  = import ./pkgs/ownpkgs.nix { inherit overlays; config={ allowUnfree=true; allowBroken=true; };};

  vast = nixpkgs.callPackage ./pkgs/vast {};
  my-python = (import ./pkgs/python.nix {pkgs=nixpkgs;});
  julia = (import ./pkgs/julia.nix {});
  broker = nixpkgs.callPackage ./pkgs/broker {};
  my-go =  (import ./pkgs/go.nix {pkgs=nixpkgs;});
  my-R = (import ./pkgs/R.nix {pkgs=nixpkgs;});
  zeek = nixpkgs.callPackage ./pkgs/zeek { };

  iPython = jupyter.kernels.iPythonWith {
    python3 = nixpkgs.callPackage ./pkgs/overlay/own-python.nix { pkgs=nixpkgs;};
    name = "Python-NSM-env";
    packages = import ./pkgs/overlay/python-list.nix { pkgs=nixpkgs;};
    ignoreCollisions = true;
  };

  IRkernel = jupyter.kernels.iRWith {
    name = "IRkernel-NSM-env";
    packages = import ./pkgs/overlay/R-list.nix {pkgs=nixpkgs;};
   };

  iHaskell = jupyter.kernels.iHaskellWith {
    name = "ihaskell-NSM-env";
    haskellPackages = nixpkgs.haskell.packages.ghc881;
    packages = import ./pkgs/overlay/haskell-list.nix {pkgs=nixpkgs;};
    Rpackages = p: with p; [ ggplot2 dplyr xts purrr cmaes cubature
                             reshape2
                           ];
    inline-r = true;
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython IRkernel ];
      directory = ./jupyterlab;
    };

  generateDirectory = nixpkgs.writeScriptBin "generate-directory" (import ./pkgs/generate-directory.nix { inherit nixpkgs; });
in
nixpkgs.buildEnv {
  name = "NSM-analysis-env";
  buildInputs = [ nixpkgs.makeWrapper
                  vast
                  (zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true;})
                ];
  paths = [ my-python nixpkgs.yara julia my-go my-R 
            jupyterEnvironment
          ];
  ignoreCollisions = true;
  postBuild = ''
    ln -s ${vast}/bin/vast $out/bin/
    ln -s ${zeek}/bin/* $out/bin/
  '';
}
