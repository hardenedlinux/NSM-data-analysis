final: prev:
rec {
      packageOverrides = selfPythonPackages: pythonPackages: {
            beakerx = prev.python3Packages.callPackage ../pkgs/python/beakerx {};
            btest = prev.python3Packages.callPackage ../pkgs/python/btest {};
            rmm = prev.python3Packages.callPackage ../pkgs/python/rmm {};
            clx = prev.python3Packages.callPackage ../pkgs/python/clx { };
            cudf = prev.python3Packages.callPackage ../pkgs/python/cudf { };
            libclx = prev.python3Packages.callPackage ./pkgs-lib/libclx { };
            zat = prev.python3Packages.callPackage ../pkgs/python/zat {};
            choochoo = prev.python3Packages.callPackage ../pkgs/python/choochoo {};
            service_identity = prev.python3Packages.callPackage ../pkgs/python/service_identity {};
            editdistance = prev.python3Packages.callPackage ../pkgs/python/editdistance {};
            IPy = prev.python3Packages.callPackage ../pkgs/python/IPy {};
            #networkx = prev.python3Packages.callPackage ../pkgs/python/networkx {};
            #netaddr = prev.python3Packages.callPackage ../pkgs/python/netaddr {};
            tldextract = prev.python3Packages.callPackage ../pkgs/python/tldextract {};
            pyshark = prev.python3Packages.callPackage ../pkgs/python/pyshark {};
            cefpython3 = prev.python3Packages.callPackage ../pkgs/python/cefpython3 {};
            pyvis = prev.python3Packages.callPackage ../pkgs/python/pyvis {};
            yarapython = prev.python3Packages.callPackage ../pkgs/python/yara-python {};
            #pyOpenSSL = prev.python3Packages.callPackage ../pkgs/python/pyOpenSSL {};
            python-pptx = prev.python3Packages.callPackage ../pkgs/python/python-pptx {};
            adblockparser = prev.python3Packages.callPackage ../pkgs/python/adblockparser {};
            python-whois = prev.python3Packages.callPackage ../pkgs/python/python-whois {};
            CherryPy = prev.python3Packages.callPackage ../pkgs/python/CherryPy {};
            pygexf = prev.python3Packages.callPackage ../pkgs/python/pygexf {};
            PyPDF2 = prev.python3Packages.callPackage ../pkgs/python/PyPDF2 {};
            ipwhois = prev.python3Packages.callPackage ../pkgs/python/ipwhois {};
            secure = prev.python3Packages.callPackage ../pkgs/python/secure {};
            axelrod = prev.python3Packages.callPackage ../pkgs/python/axelrod {};
            fastai = prev.python3Packages.callPackage ../pkgs/python/fastai {};
            elastalert = prev.python3Packages.callPackage ../pkgs/python/elastalert {};
            jupyter_server = prev.python3Packages.callPackage ../pkgs/python/jupyter-server {};
            jupyterlab_git =  prev.pythonPackages.callPackage ../pkgs/python/jupyterlab-git {};
            jupyter_lsp =  prev.python3Packages.callPackage ../pkgs/python/jupyter-lsp {};
            textblob=  prev.python3Packages.callPackage ../pkgs/python/textblob {};
            #aiohttp = prev.python3Packages.callPackage ../pkgs/python/aiohttp {};
      };
}
