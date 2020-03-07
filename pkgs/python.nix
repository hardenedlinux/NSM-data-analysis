{ pkgs ? import <nixpkgs> {} }:
let
  ownpkgs_git = builtins.fetchTarball {
      url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/bea1a232c615aba177e0ef56600d5f847ad3bbd9";
      sha256 = "1zakg4qrby56j28p9jifsplj3xbda2pmg1cw2zfr1y8wcab61p25";
  };
  ownpkgs = (import ownpkgs_git) { };


  cuda_git = builtins.fetchTarball {
      url    = "https://github.com/GTrunSec/nixpkgs-channels/tarball/42f0be81ae05a8fe6d6e8e7f1c28652e7746e046";
      sha256 = "1rxb5kmghkzazqcv4d8yczdiv2srs4r7apx4idc276lcikm0hdmf";
  };

  cudapkgs = (import cuda_git) { };
  cudf = ownpkgs.callPackages ./python/cudf {};
  rmm = ownpkgs.callPackages ./cuda/rmm {};
  clx = ownpkgs.callPackages ./python/clx {};
  zat = ownpkgs.callPackages ./python/zat {};
  choochoo = ownpkgs.callPackages ./python/choochoo {};
  service_identity = ownpkgs.callPackages ./python/service_identity {};
  editdistance = ownpkgs.callPackages ./python/editdistance {};
  IPy = ownpkgs.callPackages ./python/IPy {};
  networkx = ownpkgs.callPackages ./python/networkx {};
  netaddr = ownpkgs.callPackages ./python/netaddr {};
  tldextract = ownpkgs.callPackages ./python/tldextract {};
  pyshark = ownpkgs.callPackages ./python/pyshark {};
  cefpython3 = ownpkgs.callPackages ./python/cefpython3 {};
  pyvis = ownpkgs.callPackages ./python/pyvis {};
  yarapython = ownpkgs.callPackages ./python/yara-python {};
  pyOpenSSL = ownpkgs.callPackages ./python/pyOpenSSL {};
  python-pptx = ownpkgs.callPackages ./python/python-pptx {};
  adblockparser = ownpkgs.callPackages ./python/adblockparser {};
  python-whois = ownpkgs.callPackages ./python/python-whois {};
  CherryPy = ownpkgs.callPackages ./python/CherryPy {};
  pygexf = ownpkgs.callPackages ./python/pygexf {};
  PyPDF2 = ownpkgs.callPackages ./python/PyPDF2 {};
  ipwhois = ownpkgs.callPackages ./python/ipwhois {};
  secure = ownpkgs.callPackages ./python/secure {};


  # my-python-packages = [
  #   (ownpkgs.python3.withPackages (pkgs: with pkgs; [
  #     setuptools
  #     zat
  #   ]))
  # ];
  broker = ownpkgs.callPackages ./broker {};
  my-cuda-packages = (cudapkgs.python3.withPackages (ps: [ cudf]));
  my-python-packages = (ownpkgs.python3.withPackages (ps: [ ps.jupyterlab
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
                                                            clx
                                                          ])).override (args: { ignoreCollisions = true;});
in
ownpkgs.buildEnv rec {
  name = "my-python";
  buildInputs = [
    ownpkgs.makeWrapper
    ] ;
  paths = [ my-python-packages ];
  postBuild = ''
    #ln -s ${broker}/lib/python3.7/site-packages/broker/_broker.so $out/lib
'';
}
