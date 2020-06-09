let
  haskTorchSrc = builtins.fetchGit {
    url = https://github.com/hasktorch/hasktorch;
    rev = "5f905f7ac62913a09cbb214d17c94dbc64fc8c7b";
    ref = "master";
  };

  jupyterLib = builtins.fetchGit {
    url = https://github.com/GTrunSec/jupyterWith;
    rev = "ce6b72643cf74c2c278224cb29c59a24fedf7c25";
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


  env = (import (jupyterLib + "/lib/directory.nix")){ inherit pkgs;};
  pkgs = (import (jupyterLib + "/nix/nixpkgs.nix")) { overlays=jupyter-overlays; config={ allowUnfree=true; allowBroken=true; };};

  jupyter = import jupyterLib {pkgs=pkgs;};

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
    haskellPackages = pkgs.haskell.packages.ghc883;
    packages = import ./nix/overlay/haskell-list.nix {pkgs=pkgs;};
    Rpackages = p: with p; [ ggplot2 dplyr xts purrr cmaes cubature
                             reshape2
                           ];
    inline-r = true;
  };

  currentDir = builtins.getEnv "PWD";
  overlay_julia = [ (import ./nix/overlay/julia.nix)
                  ];
  iJulia = jupyter.kernels.iJuliaWith {
    name =  "Julia-data-env";
    directory = currentDir + "/.julia_pkgs";
    nixpkgs =  import (builtins.fetchTarball "https://github.com/GTrunSec/nixpkgs/tarball/3fac6bbcf173596dbd2707fe402ab6f65469236e"){ overlays=overlay_julia;};
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

 in
   nixpkgs.mkShell rec {
     name = "Jupyter-data-Env";
     buildInputs = [ jupyterEnvironment
                     nixpkgs.python3Packages.ipywidgets
                     nixpkgs.python3Packages.jupyterlab_git
                     nixpkgs.python3Packages.python-language-server
                     nixpkgs.python3Packages.jupyter_lsp
                     env.generateDirectory
                     iJulia.InstalliJulia
                     iJulia.julia_wrapped
                     iJulia.Install_JuliaCUDA
                   ];

  shellHook = ''
     ${nixpkgs.python3Packages.jupyter_core}/bin/jupyter nbextension install --py widgetsnbextension --user
     ${nixpkgs.python3Packages.jupyter_core}/bin/jupyter nbextension enable --py widgetsnbextension
      ${nixpkgs.python3Packages.jupyter_core}/bin/jupyter serverextension enable --py jupyterlab_git
      ${nixpkgs.python3Packages.jupyter_core}/bin/jupyter serverextension enable --py jupyter_lsp
      if [ ! -f "./jupyterlab/extensions/ihaskell_jupyterlab-0.0.7.tgz]; then
        if [ ! -f "./jupyterlab/extensions/jupyter-widgets-jupyterlab-manager-2.0.0.tgz]; then
       ${env.generateDirectory}/bin/generate-directory @jupyter-widgets/jupyterlab-mager@2.0
       ${env.generateDirectory}/bin/generate-directory @jupytlab/git
       ${env.generateDirectory}/bin/generate-directory @krassowski/jupytlab-lsp
  fi
    #${jupyterEnvironment}/bin/jupyter-lab
    '';
   }

