let
  pkgs = {
    ihaskell = builtins.fetchTarball {
      url = "https://github.com/gibiansky/IHaskell/tarball/bb2500c448c35ca79bddaac30b799d42947e8774";
      sha256 = "1n4yqxaf2xcnjfq0r1v7mzjhrizx7z5b2n6gj1kdk2yi37z672py";
    };

    #ghc864
    nixpkgs = builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs-channels/tarball/49dc8087a20e0d742d38be5f13333a03d171006a";
      sha256 = "1fdnqm4vyj50jb2ydcc0nldxwn6wm7qakxfhmpf72pz2y2ld55i6";
    };


  };


  ownpkgs_git = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/bea1a232c615aba177e0ef56600d5f847ad3bbd9";
    sha256 = "1zakg4qrby56j28p9jifsplj3xbda2pmg1cw2zfr1y8wcab61p25";
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
    buildInputs = with nixpkgs; [ R
                                   rPackages.ggplot2 rPackages.dplyr rPackages.xts rPackages.purrr rPackages.cmaes rPackages.cubature
                                  rPackages.reshape2
                                 ];
  } ''echo $R_LIBS_SITE > $out'';

  ihaskellEnv = (import "${pkgs.ihaskell}/release.nix" {
    compiler = "ghc864";
    nixpkgs  = nixpkgs;
  packages = self: [
    self.inline-r
    self.hmatrix
    # we can re-introduce this when it gets fixed
    # self.hmatrix-sundials
    self.random-fu
    self.my-random-fu-multivariate
  ];
  }).passthru.ihaskellEnv;

  systemPackages = self: [ self.myR ];

  broker = ownpkgs.callPackages ./pkgs/broker {};
  vast = ownpkgs.callPackages ./pkgs/vast {};
  zat = ownpkgs.callPackages ./pkgs/python/zat {};
  choochoo = ownpkgs.callPackages ./pkgs/python/choochoo {};
  service_identity = ownpkgs.callPackages ./pkgs/python/service_identity {};
  editdistance = nixpkgs.callPackages ./pkgs/python/editdistance {};
  IPy = nixpkgs.callPackages ./pkgs/python/IPy {};
  networkx = nixpkgs.callPackages ./pkgs/python/networkx {};
  netaddr = nixpkgs.callPackages ./pkgs/python/netaddr {};
  tldextract = nixpkgs.callPackages ./pkgs/python/tldextract {};
  pyshark = ownpkgs.callPackages ./pkgs/python/pyshark {};
  cefpython3 = ownpkgs.callPackages ./pkgs/python/cefpython3 {};
  pyvis = ownpkgs.callPackages ./pkgs/python/pyvis {};
  yarapython = ownpkgs.callPackages ./pkgs/python/yara-python {};
  pyOpenSSL = ownpkgs.callPackages ./pkgs/python/pyOpenSSL {};
  python-pptx = ownpkgs.callPackages ./pkgs/python/python-pptx {};
  adblockparser = ownpkgs.callPackages ./pkgs/python/adblockparser {};
  python-whois = ownpkgs.callPackages ./pkgs/python/python-whois {};
  CherryPy = ownpkgs.callPackages ./pkgs/python/CherryPy {};
  pygexf = ownpkgs.callPackages ./pkgs/python/pygexf {};
  PyPDF2 = ownpkgs.callPackages ./pkgs/python/PyPDF2 {};
  ipwhois = ownpkgs.callPackages ./pkgs/python/ipwhois {};
  secure = ownpkgs.callPackages ./pkgs/python/secure {};
  # Go packages
  deepsea = ownpkgs.callPackages ./pkgs/go/deepsea {};

  jupyterlab = (ownpkgs.python3.withPackages (ps: [ ps.jupyterlab
                                                    ps.pandas
                                                    ps.matplotlib
                                                    ps.Mako
                                                    ps.numpy
                                                    ps.scikitlearn
                                                    ps.sqlalchemy
                                                    secure
                                                    ps.dnspython
                                                    ps.exifread
                                                    ps.pysocks
                                                    ps.phonenumbers
                                                    ps.future
                                                    ipwhois
                                                    ps.python-docx
                                                    PyPDF2
                                                    CherryPy
                                                    adblockparser
                                                    python-whois
                                                    networkx
                                                    zat
                                                    python-pptx
                                                    pyOpenSSL
                                                    choochoo
                                                    ps.twisted
                                                    ps.cryptography
                                                    ps.bcrypt
                                                    ps.pyopenssl
                                                    ps.geoip2
                                                    ps.ipaddress
                                                    service_identity
                                                    ps.netaddr
                                                    ps.pillow
                                                    ps.graphviz
                                                    #Tor
                                                    ps.stem
                                                    netaddr
                                                    editdistance
                                                    IPy
                                                    tldextract
                                                    ps.scapy
                                                    pyshark
                                                    ## Interactive Maps
                                                    #cefpython3 Failed
                                                    pyvis
                                                    #
                                                    ps.nltk
                                                    ps.Keras
                                                    ps.tensorflow
                                                    ps.scikitimage
                                                    ps.elasticsearch
                                                    ps.requests
                                                    yarapython
                                                  ])).override (args: { ignoreCollisions = true;});
  rtsopts = "-M3g -N2";



  nix.binaryCaches = [
    https://cache.nixos.community
   ];
  ihaskellJupyterCmdSh = cmd: extraArgs: nixpkgs.writeScriptBin "ihaskell-${cmd}" ''
    #! ${nixpkgs.stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export R_LIBS_SITE=${builtins.readFile r-libs-site}
    export PATH="${nixpkgs.stdenv.lib.makeBinPath ([ ihaskellEnv jupyterlab ] ++ systemPackages nixpkgs)}''${PATH:+:}$PATH"
    ${ihaskellEnv}/bin/ihaskell install \
      -l $(${ihaskellEnv}/bin/ghc --print-libdir) \
      --use-rtsopts="${rtsopts}" \
      && ${jupyterlab}/bin/jupyter ${cmd} ${extraArgs} "$@"
  '';

  julia = (import ./pkgs/julia-non-cuda.nix {});
in
nixpkgs.buildEnv {
  name = "NSM-analysis-env";
  buildInputs = [ nixpkgs.makeWrapper
                  vast
                  deepsea
                ];
  paths = [ ihaskellEnv jupyterlab ownpkgs.yara julia];
  postBuild = ''
    ln -s ${vast}/bin/vast $out/bin/
    ln -s ${deepsea}/bin/deepsea $out/bin/
    #ln -s ${broker}/lib/python3.7/site-packages/broker/_broker.so $out/lib
    ln -s ${ihaskellJupyterCmdSh "lab" ""}/bin/ihaskell-lab $out/bin/
    ln -s ${ihaskellJupyterCmdSh "notebook" ""}/bin/ihaskell-notebook $out/bin/
    ln -s ${ihaskellJupyterCmdSh "nbconvert" ""}/bin/ihaskell-nbconvert $out/bin/
    ln -s ${ihaskellJupyterCmdSh "console" "--kernel=haskell"}/bin/ihaskell-console $out/bin/
    for prg in $out/bin"/"*;do
      if [[ -f $prg && -x $prg ]]; then
        wrapProgram $prg --set PYTHONPATH "$(echo ${jupyterlab}/lib/*/site-packages)" \
                    --set PYTHONPATH "${broker}/lib/python3.7/site-packages" 
         fi
    done
  '';
}
