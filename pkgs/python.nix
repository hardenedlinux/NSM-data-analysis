{ pkgs, timepkgs }:
let
  timesketch = timepkgs.callPackage ./timesketch {};
  time-python-packages = (timepkgs.python3.withPackages (ps: [ timesketch]));
  my-python-packages = (pkgs.python3.withPackages (ps: [
                                                         ps.pandas
                                                         ps.beakerx
                                                         ps.elastalert
                                                         ps.voila
                                                         ps.fastai
                                                         ps.fastai2
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
                                                         ps.tensorflow# does not support python 3.8
                                                         ps.scikitimage
                                                         ps.elasticsearch
                                                         ps.requests
                                                         ps.yarapython
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
            time-python-packages
          ];

  ignoreCollisions = true;
  postBuild = ''
'';
}
