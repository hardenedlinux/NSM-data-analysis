let
  pkgs = {
    ihaskell = builtins.fetchTarball {
      url = "https://github.com/gibiansky/IHaskell/tarball/0ef1f37fcedb7146786638488d38b812ca41352e";
      sha256 = "147k1crdafpshimw5xsn2cfzifghbvwflq6h20iqgbh0k516q6yx";
    };
  };


  rOverlay = rself: rsuper: {
    myR = rsuper.rWrapper.override {
      packages = with rsuper.rPackages; [ my-R];
    };
  };

  foo = self: super: {
    haskell = super.haskell // { packageOverrides =
	    hself: hsuper: {
        hmatrix-sundials = hself.callCabal2nix "hmatrix-sundials" (builtins.fetchGit {
          url = "https://github.com/haskell-numerics/hmatrix-sundials.git";
          rev = "9b6ec2b5fc509f74c5e61657dfc638a2c7ebced0";
        }) { sundials_arkode = haskell-pkgs.sundials; sundials_cvode = haskell-pkgs.sundials; };

        my-random-fu-multivariate = hself.callPackage ./pkgs/haskell/my-random-fu-multivariate { };
        i-inline-c = hself.callHackage "inline-c" "0.8.0.1" {};
        i-inline-r = hself.callHackage "inline-r" "0.10.2" {};
      };
    };
  };
  overlays = [
    rOverlay
    (import ./pkgs/Python-overlay.nix)
  ];
  nixpkgs  = import ./pkgs/ownpkgs.nix { inherit overlays; config={ allowUnfree=true; allowBroken=true; ignoreCollisions = true;};};
  haskell-pkgs  = import ./pkgs/haskell-pkgs.nix { overlays = [ foo];  config={ allowUnfree=true; allowBroken=true; ignoreCollisions = true;};};


  vast = nixpkgs.callPackage ./pkgs/vast {};
  my-python = (import ./pkgs/python.nix {pkgs=nixpkgs;});
  julia = (import ./pkgs/julia.nix {});
  broker = nixpkgs.callPackage ./pkgs/broker {};
  my-go =  (import ./pkgs/go.nix {pkgs=nixpkgs;});
  my-R = (import ./pkgs/R.nix {pkgs=nixpkgs;});
  zeek = nixpkgs.callPackage ./pkgs/zeek { };

  r-libs-site = nixpkgs.runCommand "r-libs-site" {
    buildInputs = with nixpkgs; [ R
                                  rPackages.ggplot2 rPackages.dplyr rPackages.xts rPackages.purrr rPackages.cmaes rPackages.cubature
                                  rPackages.reshape2
                                ];
  } ''echo $R_LIBS_SITE > $out'';

  ihaskellEnv = (import "${pkgs.ihaskell}/release-8.6.nix" {
    compiler = "ghc865";
    nixpkgs  = haskell-pkgs;
  packages = self: [
    self.inline-r
    self.hmatrix
    self.hmatrix-sundials
    self.random-fu
    self.lens
    self.my-random-fu-multivariate
  ];
  }).passthru.ihaskellEnv;

  systemPackages = self: [ self.myR ];


  rtsopts = "-M3g -N2";

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
                  (zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true;})
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
