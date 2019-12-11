let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/60e1709baefb8498103d598ca4f14ac39719d448";
    sha256 = "15vsi0k65vjmr57jdjihad1yx0d8i83xnc0v7fpymgrwldvjblx4";
  };
  # last update


  pkgs = import nixpkgs {config = {}; };
  ## load static nixpkgs
  #pkgs = import ~/src/nixpkgs-channels {};

  ## add own-python package
  vast = pkgs.callPackages ./pkgs/vast {};
  zat = pkgs.callPackages ./pkgs/python/zat {};
  editdistance = pkgs.callPackages ./pkgs/python/editdistance {};
  IPy = pkgs.callPackages ./pkgs/python/IPy {};
  networkx = pkgs.callPackages ./pkgs/python/networkx {};
  netaddr = pkgs.callPackages ./pkgs/python/netaddr {};
  tldextract = pkgs.callPackages ./pkgs/python/tldextract {};    
  # Change these if you need extra R or Python packages.
  my-R-packages = with pkgs.rPackages; [
    summarytools
    cmaes
    ggplot2
    dplyr
    doBy
    xts
  ];
  my-python-packages = [ 
    (pkgs.python3.withPackages (pkgs: with pkgs; [
      setuptools
      tldextract
      zat
      numpy
      scikitlearn
      netaddr
      editdistance
      IPy
      matplotlib
      sqlalchemy
      pandas
      networkx
    ]))
  ];

  R-with-my-packages = pkgs.rWrapper.override{ packages = with pkgs.rPackages;
    my-R-packages
    ++ [ JuniperKernel]; };
  jupyter-R-kernel = pkgs.stdenv.mkDerivation {
    name = "jupyter-R-kernel";
    buildInputs = [ pkgs.python37Packages.jupyter pkgs.python37Packages.notebook
                    R-with-my-packages
                    pkgs.which ];
    unpackPhase = ":";
    installPhase = ''
    export HOME=$TMP
    echo $JUPYTER_PATH
    ${R-with-my-packages}/bin/R --slave -e "JuniperKernel::listKernels()"
    ${R-with-my-packages}/bin/R --slave -e "JuniperKernel::installJuniper(prefix='$out')"
  '';
  };
in
pkgs.mkShell rec {
  name = "nix-nsm-data-analysis-lab";
  buildInputs = [ jupyter-R-kernel
                  pkgs.python37Packages.jupyter
                ] ++ my-python-packages;
  shellHook = ''
    export JUPYTER_PATH=${jupyter-R-kernel}/share/jupyter
    # see https://github.com/NixOS/nixpkgs/issues/38733
    ${R-with-my-packages}/bin/R --slave -e "system2('jupyter', 'notebook')"
  '';
}
