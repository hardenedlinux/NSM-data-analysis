{ pkgs }:
let
  beakerx = pkgs.callPackage ./python/beakerx {};
  cudf = pkgs.callPackage ./python/cudf {inherit rmm;};
  rmm = pkgs.callPackage ./python/rmm {};
  clx = pkgs.callPackage ./python/clx { inherit python-whois;};
  libclx = pkgs.callPackage ./pkgs-lib/libclx { };
  zat = pkgs.callPackage ./python/zat {};
  choochoo = pkgs.callPackage ./python/choochoo {};
  service_identity = pkgs.callPackage ./python/service_identity {};
  editdistance = pkgs.callPackage ./python/editdistance {};
  IPy = pkgs.callPackage ./python/IPy {};
  #networkx = pkgs.callPackage ./python/networkx {};
  #netaddr = pkgs.callPackage ./python/netaddr {};
  tldextract = pkgs.callPackage ./python/tldextract {};
  pyshark = pkgs.callPackage ./python/pyshark {};
  cefpython3 = pkgs.callPackage ./python/cefpython3 {};
  pyvis = pkgs.callPackage ./python/pyvis {};
  yarapython = pkgs.callPackage ./python/yara-python {};
  #pyOpenSSL = pkgs.callPackage ./python/pyOpenSSL {};
  python-pptx = pkgs.callPackage ./python/python-pptx {};
  adblockparser = pkgs.callPackage ./python/adblockparser {};
  python-whois = pkgs.callPackage ./python/python-whois {};
  CherryPy = pkgs.callPackage ./python/CherryPy {};
  pygexf = pkgs.callPackage ./python/pygexf {};
  PyPDF2 = pkgs.callPackage ./python/PyPDF2 {};
  ipwhois = pkgs.callPackage ./python/ipwhois {};
  secure = pkgs.callPackage ./python/secure {};
  axelrod = pkgs.callPackage ./python/axelrod {};
  voila = pkgs.callPackage ./python/voila {};
  fastai = pkgs.callPackage ./python/fast-ai {};
  fastai2 = pkgs.callPackage ./python/fastai2 {};
  aiohttp = pkgs.callPackage ./python/aiohttp {};
  jupyterlab_git = pkgs.callPackage ./python/jupyterlab-git {};
  jupyter-lsp = pkgs.callPackage ./python/jupyter-lsp {};
  broker = pkgs.callPackage ./broker {};
  my-python-packages = (pkgs.python3.withPackages (ps: [ 
                                                         ps.pandas
                                                         beakerx
                                                         jupyter-lsp
                                                         jupyterlab_git
                                                         voila
                                                         fastai
                                                         fastai2
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
                                                         ps.networkx
                                                         zat
                                                         python-pptx
                                                         choochoo
                                                         ps.twisted
                                                         ps.pyspark
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
                                                         ps.tensorflow# does not support python 3.8
                                                         ps.scikitimage
                                                         ps.elasticsearch
                                                         ps.requests
                                                         yarapython
                                                         #cudf ../include/rmm/detail/memory_manager.hpp:37:10: fatal error: rmm/detail/cnmem.h: No such file or directory
                                                         #axelrod pathlib 1.0.1 does not support 3.7
                                                       ])).override (args: { ignoreCollisions = true;});
in
pkgs.buildEnv rec {
  name = "my-python";
  buildInputs = [
    pkgs.makeWrapper
    ] ;
  paths = [ my-python-packages
            (pkgs.python38.withPackages (pkgs: with pkgs; [aiohttp
                                                          ]))
          ];

  ignoreCollisions = true;
  postBuild = ''
'';
}
