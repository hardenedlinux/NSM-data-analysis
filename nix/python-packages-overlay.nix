self: super:
rec {
      python3 = super.python37.override {
            packageOverrides = selfPythonPackages: pythonPackages: {
                  beakerx = super.python3Packages.callPackage ../pkgs/python/beakerx {};
                  #cudf = super.python3Packages.callPackage ../pkgs/python/cudf {inherit rmm;};
                  rmm = super.python3Packages.callPackage ../pkgs/python/rmm {};
                  clx = super.python3Packages.callPackage ../pkgs/python/clx { };
                  cudf = super.python3Packages.callPackage ../pkgs/python/cudf { };
                  libclx = super.python3Packages.callPackage ./pkgs-lib/libclx { };
                  zat = super.python3Packages.callPackage ../pkgs/python/zat {};
                  choochoo = super.python3Packages.callPackage ../pkgs/python/choochoo {};
                  service_identity = super.python3Packages.callPackage ../pkgs/python/service_identity {};
                  editdistance = super.python3Packages.callPackage ../pkgs/python/editdistance {};
                  IPy = super.python3Packages.callPackage ../pkgs/python/IPy {};
                  #networkx = super.python3Packages.callPackage ../pkgs/python/networkx {};
                  #netaddr = super.python3Packages.callPackage ../pkgs/python/netaddr {};
                  tldextract = super.python3Packages.callPackage ../pkgs/python/tldextract {};
                  pyshark = super.python3Packages.callPackage ../pkgs/python/pyshark {};
                  cefpython3 = super.python3Packages.callPackage ../pkgs/python/cefpython3 {};
                  pyvis = super.python3Packages.callPackage ../pkgs/python/pyvis {};
                  yarapython = super.python3Packages.callPackage ../pkgs/python/yara-python {};
                  #pyOpenSSL = super.python3Packages.callPackage ../pkgs/python/pyOpenSSL {};
                  python-pptx = super.python3Packages.callPackage ../pkgs/python/python-pptx {};
                  adblockparser = super.python3Packages.callPackage ../pkgs/python/adblockparser {};
                  python-whois = super.python3Packages.callPackage ../pkgs/python/python-whois {};
                  CherryPy = super.python3Packages.callPackage ../pkgs/python/CherryPy {};
                  pygexf = super.python3Packages.callPackage ../pkgs/python/pygexf {};
                  PyPDF2 = super.python3Packages.callPackage ../pkgs/python/PyPDF2 {};
                  ipwhois = super.python3Packages.callPackage ../pkgs/python/ipwhois {};
                  secure = super.python3Packages.callPackage ../pkgs/python/secure {};
                  axelrod = super.python3Packages.callPackage ../pkgs/python/axelrod {};
                  voila = super.python3Packages.callPackage ../pkgs/python/voila {};
                  fastai = super.python3Packages.callPackage ../pkgs/python/fast-ai {};
                  fastai2 = super.python3Packages.callPackage ../pkgs/python/fastai2 {};
                  elastalert = super.python3Packages.callPackage ../pkgs/python/elastalert {};
                  jupyter_server = super.python3Packages.callPackage ../pkgs/python/jupyter-server {};
                  jupyterlab_git =  super.pythonPackages.callPackage ../pkgs/python/jupyterlab-git {};
                  jupyter_lsp =  super.python3Packages.callPackage ../pkgs/python/jupyter-lsp {};
                  timesketch = super.callPackage ../pkgs/timesketch {};
                  #aiohttp = super.python3Packages.callPackage ../pkgs/python/aiohttp {};
            };
      };
}
