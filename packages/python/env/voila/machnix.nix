with builtins;
let
  pypi_fetcher_src = builtins.fetchTarball {
    name = "nix-pypi-fetcher";
    url = "https://github.com/DavHau/nix-pypi-fetcher/tarball/ee15c7ad091761b5e2ca1d26a42974e6bafb1180";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "014vb7x2nrbab82r79cxw44nc0v952z1apbbr0qap2i9p6hqdxxz";
  };
  fetchPypi = (import pypi_fetcher_src).fetchPypi;
  fetchPypiWheel = (import pypi_fetcher_src).fetchPypiWheel;
  try_get = obj: name:
    if hasAttr name obj
    then obj."${name}"
    else [ ];
  is_py_module = pkg:
    isAttrs pkg && hasAttr "pythonModule" pkg;
  filter_deps = oldAttrs: inputs_type:
    filter (pkg: ! is_py_module pkg) (try_get oldAttrs inputs_type);
  override = pkg:
    if hasAttr "overridePythonAttrs" pkg then
      pkg.overridePythonAttrs
    else
      pkg.overrideAttrs;
  get_passthru = python: pname:
    if hasAttr "${pname}" python then
      let result = (tryEval
        (if isNull python."${pname}" then
          { }
        else
          python."${pname}".passthru));
      in
      if result.success then result.value else { }
    else { };
  select_pkgs = ps: [
    ps."bqplot"
    ps."ipympl"
    ps."ipyvolume"
    ps."scipy"
    ps."voila"
  ];
  overrides = manylinux1: autoPatchelfHook: python-self: python-super: {
    "argon2_cffi" = python-self.buildPythonPackage {
      pname = "argon2-cffi";
      version = "20.1.0";
      src = fetchPypiWheel "argon2-cffi" "20.1.0" "argon2_cffi-20.1.0-cp35-abi3-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "argon2_cffi") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ cffi six ];
    };
    "async_generator" = python-self.buildPythonPackage {
      pname = "async-generator";
      version = "1.10";
      src = fetchPypiWheel "async-generator" "1.10" "async_generator-1.10-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "async_generator") // { provider = "wheel"; };
    };
    "attrs" = python-self.buildPythonPackage {
      pname = "attrs";
      version = "20.2.0";
      src = fetchPypiWheel "attrs" "20.2.0" "attrs-20.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "attrs") // { provider = "wheel"; };
    };
    "backcall" = python-self.buildPythonPackage {
      pname = "backcall";
      version = "0.2.0";
      src = fetchPypiWheel "backcall" "0.2.0" "backcall-0.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "backcall") // { provider = "wheel"; };
    };
    "bleach" = python-self.buildPythonPackage {
      pname = "bleach";
      version = "3.2.1";
      src = fetchPypiWheel "bleach" "3.2.1" "bleach-3.2.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "bleach") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ packaging six webencodings ];
    };
    "bqplot" = python-self.buildPythonPackage {
      pname = "bqplot";
      version = "0.12.17";
      src = fetchPypiWheel "bqplot" "0.12.17" "bqplot-0.12.17-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "bqplot") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipywidgets numpy pandas traitlets traittypes ];
    };
    "certifi" = python-self.buildPythonPackage {
      pname = "certifi";
      version = "2020.6.20";
      src = fetchPypiWheel "certifi" "2020.6.20" "certifi-2020.6.20-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "certifi") // { provider = "wheel"; };
    };
    "cffi" = python-self.buildPythonPackage {
      pname = "cffi";
      version = "1.14.3";
      src = fetchPypiWheel "cffi" "1.14.3" "cffi-1.14.3-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "cffi") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ pycparser ];
    };
    "chardet" = python-self.buildPythonPackage {
      pname = "chardet";
      version = "3.0.4";
      src = fetchPypiWheel "chardet" "3.0.4" "chardet-3.0.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "chardet") // { provider = "wheel"; };
    };
    "cycler" = python-self.buildPythonPackage {
      pname = "cycler";
      version = "0.10.0";
      src = fetchPypiWheel "cycler" "0.10.0" "cycler-0.10.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "cycler") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ six ];
    };
    "decorator" = python-self.buildPythonPackage {
      pname = "decorator";
      version = "4.4.2";
      src = fetchPypiWheel "decorator" "4.4.2" "decorator-4.4.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "decorator") // { provider = "wheel"; };
    };
    "defusedxml" = python-self.buildPythonPackage {
      pname = "defusedxml";
      version = "0.6.0";
      src = fetchPypiWheel "defusedxml" "0.6.0" "defusedxml-0.6.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "defusedxml") // { provider = "wheel"; };
    };
    "entrypoints" = python-self.buildPythonPackage {
      pname = "entrypoints";
      version = "0.3";
      src = fetchPypiWheel "entrypoints" "0.3" "entrypoints-0.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "entrypoints") // { provider = "wheel"; };
    };
    "idna" = python-self.buildPythonPackage {
      pname = "idna";
      version = "2.10";
      src = fetchPypiWheel "idna" "2.10" "idna-2.10-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "idna") // { provider = "wheel"; };
    };
    "importlib-metadata" = python-self.buildPythonPackage {
      pname = "importlib-metadata";
      version = "1.7.0";
      src = fetchPypiWheel "importlib-metadata" "1.7.0" "importlib_metadata-1.7.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "importlib-metadata") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ zipp ];
    };
    "ipydatawidgets" = python-self.buildPythonPackage {
      pname = "ipydatawidgets";
      version = "4.0.1";
      src = fetchPypiWheel "ipydatawidgets" "4.0.1" "ipydatawidgets-4.0.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipydatawidgets") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipywidgets numpy six traittypes ];
    };
    "ipykernel" = python-self.buildPythonPackage {
      pname = "ipykernel";
      version = "5.3.4";
      src = fetchPypiWheel "ipykernel" "5.3.4" "ipykernel-5.3.4-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipykernel") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipython jupyter_client tornado traitlets ];
    };
    "ipympl" = python-self.buildPythonPackage {
      pname = "ipympl";
      version = "0.5.8";
      src = fetchPypiWheel "ipympl" "0.5.8" "ipympl-0.5.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipympl") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipykernel ipywidgets matplotlib ];
    };
    "ipython" = python-self.buildPythonPackage {
      pname = "ipython";
      version = "7.18.1";
      src = fetchPypiWheel "ipython" "7.18.1" "ipython-7.18.1-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipython") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ backcall decorator jedi pexpect pickleshare prompt_toolkit pygments setuptools traitlets ];
    };
    "ipython_genutils" = python-self.buildPythonPackage {
      pname = "ipython-genutils";
      version = "0.2.0";
      src = fetchPypiWheel "ipython-genutils" "0.2.0" "ipython_genutils-0.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipython_genutils") // { provider = "wheel"; };
    };
    "ipyvolume" = python-self.buildPythonPackage {
      pname = "ipyvolume";
      version = "0.5.2";
      src = fetchPypiWheel "ipyvolume" "0.5.2" "ipyvolume-0.5.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipyvolume") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipywebrtc ipywidgets numpy pillow pythreejs requests traitlets traittypes ];
    };
    "ipywebrtc" = python-self.buildPythonPackage {
      pname = "ipywebrtc";
      version = "0.5.0";
      src = fetchPypiWheel "ipywebrtc" "0.5.0" "ipywebrtc-0.5.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipywebrtc") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipywidgets ];
    };
    "ipywidgets" = python-self.buildPythonPackage {
      pname = "ipywidgets";
      version = "7.5.1";
      src = fetchPypiWheel "ipywidgets" "7.5.1" "ipywidgets-7.5.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ipywidgets") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipykernel ipython nbformat traitlets widgetsnbextension ];
    };
    "jedi" = python-self.buildPythonPackage {
      pname = "jedi";
      version = "0.17.2";
      src = fetchPypiWheel "jedi" "0.17.2" "jedi-0.17.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jedi") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ parso ];
    };
    "jinja2" = python-self.buildPythonPackage {
      pname = "jinja2";
      version = "2.11.2";
      src = fetchPypiWheel "jinja2" "2.11.2" "Jinja2-2.11.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jinja2") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    "jsonschema" = python-self.buildPythonPackage {
      pname = "jsonschema";
      version = "3.2.0";
      src = fetchPypiWheel "jsonschema" "3.2.0" "jsonschema-3.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jsonschema") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ attrs importlib-metadata pyrsistent setuptools six ];
    };
    "jupyter_client" = python-self.buildPythonPackage {
      pname = "jupyter-client";
      version = "6.1.7";
      src = fetchPypiWheel "jupyter-client" "6.1.7" "jupyter_client-6.1.7-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jupyter_client") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ jupyter_core python-dateutil pyzmq tornado traitlets ];
    };
    "jupyter_core" = python-self.buildPythonPackage {
      pname = "jupyter-core";
      version = "4.6.3";
      src = fetchPypiWheel "jupyter-core" "4.6.3" "jupyter_core-4.6.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jupyter_core") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ traitlets ];
    };
    "jupyter-server" = python-self.buildPythonPackage {
      pname = "jupyter-server";
      version = "0.3.0";
      src = fetchPypiWheel "jupyter-server" "0.3.0" "jupyter_server-0.3.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jupyter-server") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipykernel ipython_genutils jinja2 jupyter_client jupyter_core nbconvert nbformat prometheus_client pyzmq send2trash terminado tornado traitlets ];
    };
    "jupyterlab-pygments" = python-self.buildPythonPackage {
      pname = "jupyterlab-pygments";
      version = "0.1.1";
      src = fetchPypiWheel "jupyterlab-pygments" "0.1.1" "jupyterlab_pygments-0.1.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "jupyterlab-pygments") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pygments ];
    };
    "kiwisolver" = python-self.buildPythonPackage {
      pname = "kiwisolver";
      version = "1.2.0";
      src = fetchPypiWheel "kiwisolver" "1.2.0" "kiwisolver-1.2.0-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "kiwisolver") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ ];
    };
    "markupsafe" = python-self.buildPythonPackage {
      pname = "markupsafe";
      version = "1.1.1";
      src = fetchPypiWheel "markupsafe" "1.1.1" "MarkupSafe-1.1.1-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "markupsafe") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ ];
    };
    "matplotlib" = python-self.buildPythonPackage {
      pname = "matplotlib";
      version = "3.3.2";
      src = fetchPypiWheel "matplotlib" "3.3.2" "matplotlib-3.3.2-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "matplotlib") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ certifi cycler kiwisolver numpy pillow pyparsing python-dateutil ];
    };
    "mistune" = python-self.buildPythonPackage {
      pname = "mistune";
      version = "0.8.4";
      src = fetchPypiWheel "mistune" "0.8.4" "mistune-0.8.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "mistune") // { provider = "wheel"; };
    };
    "nbclient" = python-self.buildPythonPackage {
      pname = "nbclient";
      version = "0.5.0";
      src = fetchPypiWheel "nbclient" "0.5.0" "nbclient-0.5.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "nbclient") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ async_generator jupyter_client nbformat nest-asyncio traitlets ];
    };
    "nbconvert" = python-self.buildPythonPackage {
      pname = "nbconvert";
      version = "6.0.3";
      src = fetchPypiWheel "nbconvert" "6.0.3" "nbconvert-6.0.3-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "nbconvert") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ bleach defusedxml entrypoints jinja2 jupyter_core jupyterlab-pygments mistune nbclient nbformat pandocfilters pygments testpath traitlets ];
    };
    "nbformat" = python-self.buildPythonPackage {
      pname = "nbformat";
      version = "5.0.7";
      src = fetchPypiWheel "nbformat" "5.0.7" "nbformat-5.0.7-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "nbformat") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipython_genutils jsonschema jupyter_core traitlets ];
    };
    "nest-asyncio" = python-self.buildPythonPackage {
      pname = "nest-asyncio";
      version = "1.4.0";
      src = fetchPypiWheel "nest-asyncio" "1.4.0" "nest_asyncio-1.4.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "nest-asyncio") // { provider = "wheel"; };
    };
    "notebook" = python-self.buildPythonPackage {
      pname = "notebook";
      version = "6.1.4";
      src = fetchPypiWheel "notebook" "6.1.4" "notebook-6.1.4-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "notebook") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ argon2_cffi ipykernel ipython_genutils jinja2 jupyter_client jupyter_core nbconvert nbformat prometheus_client pyzmq send2trash terminado tornado traitlets ];
    };
    "numpy" = python-self.buildPythonPackage {
      pname = "numpy";
      version = "1.19.2";
      src = fetchPypiWheel "numpy" "1.19.2" "numpy-1.19.2-cp37-cp37m-manylinux2010_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "numpy") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ ];
    };
    "packaging" = python-self.buildPythonPackage {
      pname = "packaging";
      version = "20.4";
      src = fetchPypiWheel "packaging" "20.4" "packaging-20.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "packaging") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyparsing six ];
    };
    "pandas" = python-self.buildPythonPackage {
      pname = "pandas";
      version = "1.1.2";
      src = fetchPypiWheel "pandas" "1.1.2" "pandas-1.1.2-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pandas") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ numpy python-dateutil pytz ];
    };
    "pandocfilters" = override python-super.pandocfilters (oldAttrs: {
      pname = "pandocfilters";
      version = "1.4.2";
      passthru = (get_passthru python-super "pandocfilters") // { provider = "sdist"; };
      src = fetchPypi "pandocfilters" "1.4.2";
      doCheck = false;
      doInstallCheck = false;
    });
    "parso" = python-self.buildPythonPackage {
      pname = "parso";
      version = "0.7.1";
      src = fetchPypiWheel "parso" "0.7.1" "parso-0.7.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "parso") // { provider = "wheel"; };
    };
    "pexpect" = python-self.buildPythonPackage {
      pname = "pexpect";
      version = "4.8.0";
      src = fetchPypiWheel "pexpect" "4.8.0" "pexpect-4.8.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pexpect") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ptyprocess ];
    };
    "pickleshare" = python-self.buildPythonPackage {
      pname = "pickleshare";
      version = "0.7.5";
      src = fetchPypiWheel "pickleshare" "0.7.5" "pickleshare-0.7.5-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pickleshare") // { provider = "wheel"; };
    };
    "pillow" = python-self.buildPythonPackage {
      pname = "pillow";
      version = "7.2.0";
      src = fetchPypiWheel "pillow" "7.2.0" "Pillow-7.2.0-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pillow") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ ];
    };
    "prometheus_client" = python-self.buildPythonPackage {
      pname = "prometheus-client";
      version = "0.8.0";
      src = fetchPypiWheel "prometheus-client" "0.8.0" "prometheus_client-0.8.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "prometheus_client") // { provider = "wheel"; };
    };
    "prompt_toolkit" = python-self.buildPythonPackage {
      pname = "prompt-toolkit";
      version = "3.0.7";
      src = fetchPypiWheel "prompt-toolkit" "3.0.7" "prompt_toolkit-3.0.7-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "prompt_toolkit") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ wcwidth ];
    };
    "ptyprocess" = python-self.buildPythonPackage {
      pname = "ptyprocess";
      version = "0.6.0";
      src = fetchPypiWheel "ptyprocess" "0.6.0" "ptyprocess-0.6.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "ptyprocess") // { provider = "wheel"; };
    };
    "pycparser" = python-self.buildPythonPackage {
      pname = "pycparser";
      version = "2.20";
      src = fetchPypiWheel "pycparser" "2.20" "pycparser-2.20-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pycparser") // { provider = "wheel"; };
    };
    "pygments" = python-self.buildPythonPackage {
      pname = "pygments";
      version = "2.7.1";
      src = fetchPypiWheel "pygments" "2.7.1" "Pygments-2.7.1-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pygments") // { provider = "wheel"; };
    };
    "pyparsing" = python-self.buildPythonPackage {
      pname = "pyparsing";
      version = "2.4.7";
      src = fetchPypiWheel "pyparsing" "2.4.7" "pyparsing-2.4.7-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pyparsing") // { provider = "wheel"; };
    };
    "pyrsistent" = override python-super.pyrsistent (oldAttrs: {
      pname = "pyrsistent";
      version = "0.17.3";
      passthru = (get_passthru python-super "pyrsistent") // { provider = "sdist"; };
      src = fetchPypi "pyrsistent" "0.17.3";
      doCheck = false;
      doInstallCheck = false;
    });
    "python-dateutil" = python-self.buildPythonPackage {
      pname = "python-dateutil";
      version = "2.8.1";
      src = fetchPypiWheel "python-dateutil" "2.8.1" "python_dateutil-2.8.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "python-dateutil") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ six ];
    };
    "pythreejs" = python-self.buildPythonPackage {
      pname = "pythreejs";
      version = "2.2.0";
      src = fetchPypiWheel "pythreejs" "2.2.0" "pythreejs-2.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pythreejs") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipydatawidgets ipywidgets numpy ];
    };
    "pytz" = python-self.buildPythonPackage {
      pname = "pytz";
      version = "2020.1";
      src = fetchPypiWheel "pytz" "2020.1" "pytz-2020.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pytz") // { provider = "wheel"; };
    };
    "pyzmq" = python-self.buildPythonPackage {
      pname = "pyzmq";
      version = "19.0.2";
      src = fetchPypiWheel "pyzmq" "19.0.2" "pyzmq-19.0.2-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pyzmq") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ ];
    };
    "requests" = python-self.buildPythonPackage {
      pname = "requests";
      version = "2.24.0";
      src = fetchPypiWheel "requests" "2.24.0" "requests-2.24.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "requests") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ certifi chardet idna urllib3 ];
    };
    "scipy" = python-self.buildPythonPackage {
      pname = "scipy";
      version = "1.5.2";
      src = fetchPypiWheel "scipy" "1.5.2" "scipy-1.5.2-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "scipy") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ numpy ];
    };
    "send2trash" = python-self.buildPythonPackage {
      pname = "send2trash";
      version = "1.5.0";
      src = fetchPypiWheel "send2trash" "1.5.0" "Send2Trash-1.5.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "send2trash") // { provider = "wheel"; };
    };
    "setuptools" = override python-super.setuptools (oldAttrs: {
      pname = "setuptools";
      version = "47.3.1";
      passthru = (get_passthru python-super "setuptools") // { provider = "nixpkgs"; };
      doCheck = false;
      doInstallCheck = false;
    });
    "six" = python-self.buildPythonPackage {
      pname = "six";
      version = "1.15.0";
      src = fetchPypiWheel "six" "1.15.0" "six-1.15.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "six") // { provider = "wheel"; };
    };
    "terminado" = python-self.buildPythonPackage {
      pname = "terminado";
      version = "0.9.0";
      src = fetchPypiWheel "terminado" "0.9.0" "terminado-0.9.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "terminado") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ptyprocess tornado ];
    };
    "testpath" = python-self.buildPythonPackage {
      pname = "testpath";
      version = "0.4.4";
      src = fetchPypiWheel "testpath" "0.4.4" "testpath-0.4.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "testpath") // { provider = "wheel"; };
    };
    "tornado" = override python-super.tornado (oldAttrs: {
      pname = "tornado";
      version = "6.0.4";
      passthru = (get_passthru python-super "tornado") // { provider = "sdist"; };
      src = fetchPypi "tornado" "6.0.4";
      doCheck = false;
      doInstallCheck = false;
    });
    "traitlets" = python-self.buildPythonPackage {
      pname = "traitlets";
      version = "5.0.4";
      src = fetchPypiWheel "traitlets" "5.0.4" "traitlets-5.0.4-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "traitlets") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ ipython_genutils ];
    };
    "traittypes" = python-self.buildPythonPackage {
      pname = "traittypes";
      version = "0.2.1";
      src = fetchPypiWheel "traittypes" "0.2.1" "traittypes-0.2.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "traittypes") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ traitlets ];
    };
    "urllib3" = python-self.buildPythonPackage {
      pname = "urllib3";
      version = "1.25.10";
      src = fetchPypiWheel "urllib3" "1.25.10" "urllib3-1.25.10-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "urllib3") // { provider = "wheel"; };
    };
    "voila" = python-self.buildPythonPackage {
      pname = "voila";
      version = "0.2.2";
      src = fetchPypiWheel "voila" "0.2.2" "voila-0.2.2-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "voila") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ jupyter-server jupyter_client nbclient nbconvert ];
    };
    "wcwidth" = python-self.buildPythonPackage {
      pname = "wcwidth";
      version = "0.2.5";
      src = fetchPypiWheel "wcwidth" "0.2.5" "wcwidth-0.2.5-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "wcwidth") // { provider = "wheel"; };
    };
    "webencodings" = python-self.buildPythonPackage {
      pname = "webencodings";
      version = "0.5.1";
      src = fetchPypiWheel "webencodings" "0.5.1" "webencodings-0.5.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "webencodings") // { provider = "wheel"; };
    };
    "widgetsnbextension" = python-self.buildPythonPackage {
      pname = "widgetsnbextension";
      version = "3.5.1";
      src = fetchPypiWheel "widgetsnbextension" "3.5.1" "widgetsnbextension-3.5.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "widgetsnbextension") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ notebook ];
    };
    "zipp" = python-self.buildPythonPackage {
      pname = "zipp";
      version = "3.1.0";
      src = fetchPypiWheel "zipp" "3.1.0" "zipp-3.1.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "zipp") // { provider = "wheel"; };
    };
  };
in
{ inherit overrides select_pkgs; }
