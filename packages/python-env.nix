{ pkgs }:
let
  custom-python-packages = (pkgs.python3.withPackages (ps: [
    ps.pandas
    ps.beakerx
    ps.elastalert
    ps.btest
    ps.fastai
    ps.matplotlib
    ps.Mako
    ps.numpy
    ps.scikitlearn
    ps.sqlalchemy
    ps.secure
    ps.dnspython
    ps.exifread
    ps.pysocks
    ps.phonenumbers
    ps.future
    ps.ipwhois
    ps.python-docx
    ps.PyPDF2
    ps.CherryPy
    ps.adblockparser
    ps.python-whois
    ps.networkx
    ps.zat
    ps.python-pptx
    ps.choochoo
    ps.twisted
    ps.pyspark
    ps.cryptography
    ps.bcrypt
    ps.pyopenssl
    ps.geoip2
    ps.ipaddress
    ps.service_identity
    ps.netaddr
    ps.pillow
    ps.graphviz
    #Tor
    ps.stem
    ps.editdistance
    ps.IPy
    ps.tldextract
    ps.scapy

    ps.pyshark
    ## Interactive Maps
    #cefpython3 Failed
    ps.pyvis
    #
    ps.nltk
    ps.Keras
    ps.scikitimage
    ps.elasticsearch
    ps.requests
    ps.yarapython

    ps.zqd
    #cudf ../include/rmm/detail/memory_manager.hpp:37:10: fatal error: rmm/detail/cnmem.h: No such file or directory
    #axelrod pathlib 1.0.1 does not support 3.7
  ])).override (args: { ignoreCollisions = true; });
in
pkgs.buildEnv rec {
  name = "hardenedlinux-python";
  buildInputs = [
    pkgs.makeWrapper
  ];
  paths = [
    custom-python-packages
  ];

  ignoreCollisions = true;
  postBuild = ''
'';
}
