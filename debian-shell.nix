let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/2436c27541b2f52deea3a4c1691216a02152e729";
    sha256 = "0p98dwy3rbvdp6np596sfqnwlra11pif3rbdh02pwdyjmdvkmbvd";
  };
  # last update

  config = {
    packageOverrides = pkgs: {
      R = pkgs.R.overrideDerivation (oldAttrs: {
        unpackPhase = "true";
      });
      texlive = pkgs.texlive // {
        ae = pkgs.texlive.ae //{                                                                                                             
          pkgs = map (p:
            p.overrideAttrs (old: {unpackPhase = true;})
          ) pkgs.texlive.ae.pkgs;
        };
      };
    };
  };
  pkgs = import nixpkgs { inherit config; };
  ## load static nixpkgs
  #pkgs = import ~/src/nixpkgs-channels {};

  ## add own-python package
  bat = pkgs.callPackages ./pkgs/python/bat {};
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
      bat
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
  name = "jupyter-with-R-kernel";
  buildInputs = [ jupyter-R-kernel
                  pkgs.python37Packages.jupyter
                ] ++ my-python-packages;
  shellHook = ''
    export JUPYTER_PATH=${jupyter-R-kernel}/share/jupyter
    # see https://github.com/NixOS/nixpkgs/issues/38733
    ${R-with-my-packages}/bin/R --slave -e "system2('jupyter', 'notebook')"
  '';
}
