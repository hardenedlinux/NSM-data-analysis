final: prev:
with prev.python3Packages;
rec {
  packageOverrides = selfPythonPackages: pythonPackages: {
    beakerx = callPackage ../pkgs/python/beakerx { };
    zqd = callPackage ../pkgs/python/zqd { };
    btest = callPackage ../pkgs/python/btest { };
    rmm = callPackage ../pkgs/python/rmm { };
    clx = callPackage ../pkgs/python/clx { };
    cudf = callPackage ../pkgs/python/cudf { };
    libclx = callPackage ./pkgs-lib/libclx { };
    zat = callPackage ../pkgs/python/zat { };
    choochoo = callPackage ../pkgs/python/choochoo { };
    service_identity = callPackage ../pkgs/python/service_identity { };
    editdistance = callPackage ../pkgs/python/editdistance { };
    IPy = callPackage ../pkgs/python/IPy { };
    tldextract = callPackage ../pkgs/python/tldextract { };
    pyshark = callPackage ../pkgs/python/pyshark { };
    cefpython3 = callPackage ../pkgs/python/cefpython3 { };
    pyvis = callPackage ../pkgs/python/pyvis { };
    yarapython = callPackage ../pkgs/python/yara-python { };
    python-pptx = callPackage ../pkgs/python/python-pptx { };
    adblockparser = callPackage ../pkgs/python/adblockparser { };
    python-whois = callPackage ../pkgs/python/python-whois { };
    CherryPy = callPackage ../pkgs/python/CherryPy { };
    pygexf = callPackage ../pkgs/python/pygexf { };
    PyPDF2 = callPackage ../pkgs/python/PyPDF2 { };
    ipwhois = callPackage ../pkgs/python/ipwhois { };
    secure = callPackage ../pkgs/python/secure { };
    axelrod = callPackage ../pkgs/python/axelrod { };
    fastai = callPackage ../pkgs/python/fastai { };
    elastalert = callPackage ../pkgs/python/elastalert { };
    jupyter_server = callPackage ../pkgs/python/jupyter-server { };
    jupyterlab_git = prev.pythonPackages.callPackage ../pkgs/python/jupyterlab-git { };
    jupyter_lsp = callPackage ../pkgs/python/jupyter-lsp { };
    textblob = callPackage ../pkgs/python/textblob { };
  };
}
