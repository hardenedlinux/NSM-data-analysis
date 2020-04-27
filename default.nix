let
  pkgs = {
    ihaskell = builtins.fetchTarball {
      url = "https://github.com/gibiansky/IHaskell/tarball/6063c58c169b626596be72051d9583cb31621fb1";
      sha256 = "1ibhldhhjxhc24ilzqav12j6ywzwl6in8qhy832bw1k2blq8ah6k";
    };
  };

  rOverlay = rself: rsuper: {
    myR = rsuper.rWrapper.override {
      packages = with rsuper.rPackages; [ ggplot2 dplyr xts purrr cmaes cubature];
    };
  };

  foo = self: super: {
    haskell = super.haskell // { packageOverrides =
	    hself: hsuper: {
        my-random-fu-multivariate = hself.callPackage ./pkgs/haskell/my-random-fu-multivariate { };
      };
    };
  };

  nixpkgs  = import ./pkgs/ownpkgs.nix { overlays = [ rOverlay foo]; };

  r-libs-site = nixpkgs.runCommand "r-libs-site" {
    buildInputs = with nixpkgs; [ R
                                   rPackages.ggplot2 rPackages.dplyr rPackages.xts rPackages.purrr rPackages.cmaes rPackages.cubature
                                  rPackages.reshape2
                                 ];
  } ''echo $R_LIBS_SITE > $out'';

  ihaskellEnv = (import "${pkgs.ihaskell}/release-8.8.nix" {
    compiler = "ghc881";
    nixpkgs  = nixpkgs;
  packages = self: [
    #self.inline-r
    self.hmatrix
    # we can re-introduce this when it gets fixed
    # self.hmatrix-sundials
    #self.random-fu
    self.lens
    self.my-random-fu-multivariate
  ];
  }).passthru.ihaskellEnv;

  systemPackages = self: [ self.myR ];


  rtsopts = "-M3g -N2";

  vast = nixpkgs.callPackage ./pkgs/vast {};
  my-python = (import ./pkgs/python.nix {});
  julia = (import ./pkgs/julia-non-cuda.nix {});
  broker = nixpkgs.callPackage ./pkgs/broker {};
  my-go =  (import ./pkgs/go.nix {});
  my-R = (import ./pkgs/R.nix {});
  zeek = nixpkgs.callPackage ./pkgs/zeek {};

  ihaskellJupyterCmdSh = cmd: extraArgs: nixpkgs.writeScriptBin "ihaskell-${cmd}" ''
    #! ${nixpkgs.stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export R_LIBS_SITE=${builtins.readFile r-libs-site}
    export PATH="${nixpkgs.stdenv.lib.makeBinPath ([ ihaskellEnv my-python my-R ] ++ systemPackages nixpkgs)}''${PATH:+:}$PATH"
    ${ihaskellEnv}/bin/ihaskell install \
      -l $(${ihaskellEnv}/bin/ghc --print-libdir) \
      --use-rtsopts="${rtsopts}" \
      && ${my-python}/bin/jupyter ${cmd} ${extraArgs} "$@"
  '';
  

  KernelsBin = nixpkgs.writeScriptBin "Kernels-NSM" ''
    ${my-python}/bin/python -m ipykernel install --user --name "Python-NSM" "$@"
    mkdir -p $HOME/.local/share/jupyter/kernels/ir_my/
    cp ${my-R}/kernels/ir_nsm/* $HOME/.local/share/jupyter/kernels/ir_my/
    chmod 777 $HOME/.local/share/jupyter/kernels/ir_my/*
  '';


  generateDirectory = nixpkgs.writeScriptBin "generate-directory" (import ./pkgs/generate-directory.nix { inherit nixpkgs; });

in
nixpkgs.buildEnv {
  name = "NSM-analysis-env";
  buildInputs = [ nixpkgs.makeWrapper
                  vast
                  zeek
                ];
  paths = [ ihaskellEnv my-python nixpkgs.yara julia my-go my-R KernelsBin generateDirectory ];
  postBuild = ''
    ln -s ${vast}/bin/vast $out/bin/
    ln -s ${zeek}/bin/* $out/bin/
    ln -s ${ihaskellJupyterCmdSh "lab" ""}/bin/ihaskell-lab $out/bin/
    ln -s ${ihaskellJupyterCmdSh "notebook" ""}/bin/ihaskell-notebook $out/bin/
    ln -s ${ihaskellJupyterCmdSh "nbconvert" ""}/bin/ihaskell-nbconvert $out/bin/
    ln -s ${ihaskellJupyterCmdSh "console" "--kernel=haskell"}/bin/ihaskell-console $out/bin/
    for prg in $out/bin"/"*;do
      if [[ -f $prg && -x $prg ]]; then
        wrapProgram $prg --set PYTHONPATH "$(echo ${my-python}/lib/*/site-packages)" \
                    --set PYTHONPATH "${broker}/lib/python3.7/site-packages"
         fi
    done
  '';
}
