let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/60e1709baefb8498103d598ca4f14ac39719d448";
    sha256 = "15vsi0k65vjmr57jdjihad1yx0d8i83xnc0v7fpymgrwldvjblx4";
  };
  # last update


  pkgs = import nixpkgs {config = {}; };
  ## load static nixpkgs

  ## add own-python package
  vast = pkgs.callPackages ./pkgs/vast {};
  zat = pkgs.callPackages ./pkgs/python/zat {};
  service_identity = pkgs.callPackages ./pkgs/python/service_identity {};
  editdistance = pkgs.callPackages ./pkgs/python/editdistance {};
  IPy = pkgs.callPackages ./pkgs/python/IPy {};
  netaddr = pkgs.callPackages ./pkgs/python/netaddr {};
  tldextract = pkgs.callPackages ./pkgs/python/tldextract {};
  pyshark = pkgs.callPackages ./pkgs/python/pyshark {};
  cefpython3 = pkgs.callPackages ./pkgs/python/cefpython3 {};
  pyvis = pkgs.callPackages ./pkgs/python/pyvis {};
  # Go packages
  deepsea = pkgs.callPackages ./pkgs/go/deepsea {};
  my-python-packages = [ 
    (pkgs.python3.withPackages (pkgs: with pkgs; [ jupyterlab
                                                   pandas
                                                   matplotlib
                                                   numpy
                                                   scikitlearn
                                                   sqlalchemy
                                                   networkx
                                                   zat
                                                   twisted
                                                   cryptography
                                                   bcrypt
                                                   pyopenssl
                                                   geoip2
                                                   ipaddress
                                                   service_identity
                                                   netaddr
                                                   pillow
                                                   graphviz
                                                   #Tor
                                                   stem
                                                   netaddr
                                                   editdistance
                                                   IPy
                                                   tldextract
                                                   scapy
                                                   pyshark
                                                   ## Interactive Maps
                                                   #cefpython3 Failed
                                                   pyvis
                                                   #
                                                   nltk
                                                   Keras
                                                   tensorflow
                                                   scikitimage
            ]))
  ];
  # R-with-my-packages = pkgs.rWrapper.override{ packages = with pkgs.rPackages;
  #   my-R-packages
  #   ++ [ JuniperKernel]; };
  # jupyter-R-kernel = pkgs.stdenv.mkDerivation {
  #   name = "jupyter-R-kernel";
  #   buildInputs = [ pkgs.python37Packages.jupyter pkgs.python37Packages.notebook
  #                   R-with-my-packages
  #                   pkgs.which ];
  #   unpackPhase = ":";
  #   installPhase = ''
  #   export HOME=$TMP
  #   echo $JUPYTER_PATH
  #   ${R-with-my-packages}/bin/R --slave -e "JuniperKernel::listKernels()"
  #   ${R-with-my-packages}/bin/R --slave -e "JuniperKernel::installJuniper(prefix='$out')"
  # '';
  # };
in
pkgs.mkShell rec {
  name = "nix-nsm-data-analysis-lab";
  buildInputs = [ 
                  pkgs.python37Packages.jupyter
                ] ++ my-python-packages;
  shellHook = ''
  '';
}
