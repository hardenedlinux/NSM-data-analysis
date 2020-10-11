#builder for '/nix/store/ncqmhr9l092dcrdq4w6vm0q4kmh8jk0m-python3.8-fsspec-0.8.3.drv' failed with exit code 1; last 10 log lines:
{ pkgs ? import <nixpkgs> {}}:
with pkgs;
let
      hardenedlinux-python-packages = (pkgs.python3.withPackages (ps: [
            # ps.pandas
            # ps.beakerx
            # ps.elastalert
            # ps.btest
            # # ps.fastai
            # # ps.fastai2 pythnon3.8 failure
            # ps.matplotlib
            # ps.Mako
            # ps.numpy
            # ps.scikitlearn
            # ps.sqlalchemy
            # ps.secure
            # ps.dnspython
            # ps.exifread
            # ps.pysocks
            # ps.phonenumbers
            # ps.future
            # ps.ipwhois
            # ps.python-docx
            # ps.PyPDF2
            # ps.CherryPy
            # ps.adblockparser
            # ps.python-whois
            # ps.networkx
            ps.zat
            # ps.python-pptx
            # # ps.choochoo fsspec
            # ps.twisted
            # ps.pyspark
            # ps.cryptography
            # ps.bcrypt
            # ps.pyopenssl
            # ps.geoip2
            # ps.ipaddress
            # ps.service_identity
            # ps.netaddr
            # ps.pillow
            # ps.graphviz
            # # #Tor
            # ps.stem
            # ps.editdistance
            # ps.IPy
            # ps.tldextract
            # ps.scapy

            # ps.pyshark
            # # ## Interactive Maps
            # # #cefpython3 Failed
            # ps.pyvis
            # # #
            # ps.nltk
            # ps.Keras
            # #ps.tensorflow# does not support python 3.8
            # #ps.scikitimage fsspec X
            # ps.elasticsearch
            # ps.requests
            # ps.yarapython
            # cudf ../include/rmm/detail/memory_manager.hpp:37:10: fatal error: rmm/detail/cnmem.h: No such file or directory
            # axelrod pathlib 1.0.1 does not support 3.7
      ])).override (args: { ignoreCollisions = true;});

in
mkShell {
      buildInputs = [
            hardenedlinux-python-packages
            #timesketch
            #vast
            # broker
            deepsea
            nvdtools
            sybilhunter
            zq
      ];
}
