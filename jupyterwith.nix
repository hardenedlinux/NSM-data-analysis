let
  haskTorchSrc = builtins.fetchGit {
    url = https://github.com/hasktorch/hasktorch;
    rev = "5f905f7ac62913a09cbb214d17c94dbc64fc8c7b";
    ref = "master";
  };

  jupyterLib = builtins.fetchGit {
    url = https://github.com/GTrunSec/jupyterWith;
    rev = "da7d92c3277f370c7439ff54beec8d632f0c9f82";
    ref = "current";
  };

  hasktorchOverlay = (import (haskTorchSrc + "/nix/shared.nix") { compiler = "ghc883"; }).overlayShared;
  haskellOverlay = import ./nix/overlay/haskell-overlay.nix;
  jupyter-overlays = [
    # Only necessary for Haskell kernel
    (import ./nix/overlay/python.nix)
    haskellOverlay
    hasktorchOverlay
  ];

  nixpkgsPath = jupyterLib + "/nix/nixpkgs.nix";

  jupyter-pkgs = import nixpkgsPath { overlays=jupyter-overlays; config={ allowUnfree=true; allowBroken=true; };};

  jupyter = import jupyterLib {pkgs=jupyter-pkgs;};

  ## 
  overlays1 = [
    (import ./nix/overlay/time-python.nix)
  ];

  overlays = [
    (import ./pkgs/Python-overlay.nix)
    (import ./nix/python-packages-overlay.nix)
    (import ./nix/packages-overlay.nix)
  ];

  #nixpkgs = import ~/.config/nixpkgs/nixos/channel/nixpkgs  { inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  nixpkgs  = import ./nix/nixpkgs.nix { inherit overlays; config={ allowUnfree=true; allowBroken=true; };};
  timepkgs  = import ./nix/nixpkgs.nix { overlays=overlays1; config={ allowUnfree=true; allowBroken=true; };};

  my-python = (import ./pkgs/python.nix {pkgs=nixpkgs; inherit timepkgs;});
  my-go =  (import ./pkgs/go.nix {pkgs=nixpkgs;});
  my-R = (import ./pkgs/R.nix {pkgs=nixpkgs;});

  iPython = jupyter.kernels.iPythonWith {
    python3 = nixpkgs.callPackage ./nix/overlay/own-python.nix { pkgs=nixpkgs;};
    name = "Python-NSM-env";
    packages = import ./nix/overlay/python-list.nix { pkgs=nixpkgs;};
    ignoreCollisions = true;
  };

  IRkernel = jupyter.kernels.iRWith {
    name = "IRkernel-NSM-env";
    packages = import ./nix/overlay/R-list.nix {pkgs=nixpkgs;};
   };

  iHaskell = jupyter.kernels.iHaskellWith {
    name = "ihaskell-NSM-env";
    haskellPackages = jupyter-pkgs.haskell.packages.ghc883;
    packages = import ./nix/overlay/haskell-list.nix {pkgs=jupyter-pkgs;};
    Rpackages = p: with p; [ ggplot2 dplyr xts purrr cmaes cubature
                             reshape2
                           ];
    inline-r = true;
  };

  currentDir = builtins.getEnv "PWD";
  iJulia = jupyter.kernels.iJuliaWith {
    name =  "Julia-data-env";
    directory = currentDir + "/.julia_pkgs";
    nixpkgs =  import (builtins.fetchTarball "https://github.com/GTrunSec/nixpkgs/tarball/39247f8d04c04b3ee629a1f85aeedd582bf41cac"){};
    NUM_THREADS = 8;
    extraPackages = p: with p;[   # GZip.jl # Required by DataFrames.jl
      gzip
      zlib
    ];
  };

  iNix = jupyter.kernels.iNixKernel {
    name = "nix-kernel";
  };

  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython IRkernel iHaskell iNix iJulia ];
      directory = ./jupyterlab;
      extraPackages = p: with p;[ python3Packages.jupyterlab_git python3Packages.jupyter_lsp python3Packages.python-language-server ];
      extraJupyterPath = p: "${p.python3Packages.jupyterlab_git}/lib/python3.7/site-packages:${p.python3Packages.jupyter_lsp}/lib/python3.7/site-packages:${p.python3Packages.python-language-server}/lib/python3.7/site-packages";
    };

  generateDirectory = nixpkgs.writeScriptBin "generate-directory" (import ./pkgs/generate-directory.nix { inherit nixpkgs; });
in
nixpkgs.buildEnv {
  name = "NSM-analysis-env";
  buildInputs = [ nixpkgs.makeWrapper
                  nixpkgs.vast
                  (nixpkgs.zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true;})
                ];
  paths = [ my-python nixpkgs.yara
            my-go
            my-R
            jupyterEnvironment
            iJulia.InstalliJulia
            iJulia.julia_wrapped
            iJulia.Install_JuliaCUDA
          ];
  ignoreCollisions = true;
  postBuild = ''
    ln -s ${nixpkgs.vast}/bin/vast $out/bin/
    ln -s ${nixpkgs.zeek}/bin/* $out/bin/
  '';
}