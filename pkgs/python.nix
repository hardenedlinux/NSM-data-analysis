{ pkgs ? import <nixpkgs> {} }:
let
  cudf = pkgs.callPackage ./python/cudf {};
  rmm = pkgs.callPackage ./cuda/rmm {};
  clx = pkgs.callPackage ./python/clx {};
  zat = pkgs.callPackage ./python/zat {};
  choochoo = pkgs.callPackage ./python/choochoo {};
  service_identity = pkgs.callPackage ./python/service_identity {};
  editdistance = pkgs.callPackage ./python/editdistance {};
  IPy = pkgs.callPackage ./python/IPy {};
  networkx = pkgs.callPackage ./python/networkx {};
  netaddr = pkgs.callPackage ./python/netaddr {};
  tldextract = pkgs.callPackage ./python/tldextract {};
  pyshark = pkgs.callPackage ./python/pyshark {};
  cefpython3 = pkgs.callPackage ./python/cefpython3 {};
  pyvis = pkgs.callPackage ./python/pyvis {};
  yarapython = pkgs.callPackage ./python/yara-python {};
  pyOpenSSL = pkgs.callPackage ./python/pyOpenSSL {};
  python-pptx = pkgs.callPackage ./python/python-pptx {};
  adblockparser = pkgs.callPackage ./python/adblockparser {};
  python-whois = pkgs.callPackage ./python/python-whois {};
  CherryPy = pkgs.callPackage ./python/CherryPy {};
  pygexf = pkgs.callPackage ./python/pygexf {};
  PyPDF2 = pkgs.callPackage ./python/PyPDF2 {};
  ipwhois = pkgs.callPackage ./python/ipwhois {};
  secure = pkgs.callPackage ./python/secure {};


  # my-python-packages = [
  #   (pkgs.python3.withPackages (pkgs: with pkgs; [
  #     setuptools
  #     zat
  #   ]))
  # ];
  broker = pkgs.callPackage ./broker {};
  my-python-packages = (pkgs.python3.withPackages (ps: [ ps.jupyterlab
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
pkgs.buildEnv rec {
  name = "my-python";
  buildInputs = [
    pkgs.makeWrapper
    ] ;
  paths = [ my-python-packages ];
  postBuild = ''
    #ln -s ${broker}/lib/python3.7/site-packages/broker/_broker.so $out/lib
'';
}
