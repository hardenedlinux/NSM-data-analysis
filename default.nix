let
  pkgs = {
    ihaskell = builtins.fetchTarball {
      url = "https://github.com/gibiansky/IHaskell/tarball/6063c58c169b626596be72051d9583cb31621fb1";
      sha256 = "1ibhldhhjxhc24ilzqav12j6ywzwl6in8qhy832bw1k2blq8ah6k";
    };

    nixpkgs = builtins.fetchTarball {
      url    = "https://github.com/GTrunSec/nixpkgs/tarball/e405fe40cc826bdecb1f22b5cb8c7291293530e2";
      sha256 = "0k9w1klirra841bvr3ahmc5w9r6pnldn1h98f9w2y7ji7k2w6xgs";
    };
  };


  ownpkgs_git = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs/tarball/806fac5d109cdc6653c33a18924dac31ac477a2b";
    sha256 = "0b1aksy1070xh9wn7mwdgyz2hpfljr4jxs6qj90x7pnxj3m3p7a4";
  };

  ownpkgs = (import ownpkgs_git) { };

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
  nixpkgs  = import pkgs.nixpkgs { overlays = [ rOverlay foo]; };

  r-libs-site = nixpkgs.runCommand "r-libs-site" {
    buildInputs = with ownpkgs; [ R
                                   rPackages.ggplot2 rPackages.dplyr rPackages.xts rPackages.purrr rPackages.cmaes rPackages.cubature
                                  rPackages.reshape2
                                 ];
  } ''echo $R_LIBS_SITE > $out'';

  ihaskellEnv = (import "${pkgs.ihaskell}/release.nix" {
    compiler = "ghc865";
    nixpkgs  = nixpkgs;
  packages = self: [
    self.inline-r
    self.hmatrix
    # we can re-introduce this when it gets fixed
    # self.hmatrix-sundials
    self.random-fu
    self.lens
    self.my-random-fu-multivariate
  ];
  }).passthru.ihaskellEnv;

  systemPackages = self: [ self.myR ];


  rtsopts = "-M3g -N2";

  vast = ownpkgs.callPackages ./pkgs/vast {};
  my-python = (import ./pkgs/python.nix {});
  julia = (import ./pkgs/julia-non-cuda.nix {});
  broker = ownpkgs.callPackages ./pkgs/broker {};
  my-go =  (import ./pkgs/go.nix {});
  my-R = (import ./pkgs/R.nix {});
  zeek = ownpkgs.callPackages ./pkgs/zeek {};

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

in
ownpkgs.buildEnv {
  name = "NSM-analysis-env";
  buildInputs = [ nixpkgs.makeWrapper
                  vast
                  zeek
                ];
  paths = [ ihaskellEnv my-python ownpkgs.yara julia my-go my-R ];
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
