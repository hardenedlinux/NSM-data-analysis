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
    else [];
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
          {}
        else
          python."${pname}".passthru)); 
      in
        if result.success then result.value else {}
    else {};
  select_pkgs = ps: [
    ps."alembic"
    ps."altair"
    ps."celery"
    ps."cryptography"
    ps."datasketch"
    ps."elasticsearch"
    ps."flask"
    ps."flask-bcrypt"
    ps."flask_login"
    ps."flask_migrate"
    ps."flask-restful"
    ps."flask_script"
    ps."flask_sqlalchemy"
    ps."flask_wtf"
    ps."google_auth"
    ps."google-auth-oauthlib"
    ps."gunicorn"
    ps."markdown"
    ps."neo4jrestclient"
    ps."numpy"
    ps."oauthlib"
    ps."pandas"
    ps."pip"
    ps."pyjwt"
    ps."python-dateutil"
    ps."pyyaml"
    ps."redis"
    ps."requests"
    ps."sigmatools"
    ps."six"
    ps."sqlalchemy"
    ps."tabulate"
    ps."werkzeug"
    ps."wtforms"
    ps."xlrd"
  ];
  overrides = manylinux1: autoPatchelfHook: python-self: python-super: {
    "alembic" = python-self.buildPythonPackage {
      pname = "alembic";
      version = "1.4.3";
      src = fetchPypiWheel "alembic" "1.4.3" "alembic-1.4.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "alembic") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ Mako python-dateutil python-editor sqlalchemy ];
    };
    "altair" = python-self.buildPythonPackage {
      pname = "altair";
      version = "4.1.0";
      src = fetchPypiWheel "altair" "4.1.0" "altair-4.1.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "altair") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ entrypoints jinja2 jsonschema numpy pandas toolz ];
    };
    "amqp" = python-self.buildPythonPackage {
      pname = "amqp";
      version = "2.6.1";
      src = fetchPypiWheel "amqp" "2.6.1" "amqp-2.6.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "amqp") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ vine ];
    };
    "aniso8601" = python-self.buildPythonPackage {
      pname = "aniso8601";
      version = "8.0.0";
      src = fetchPypiWheel "aniso8601" "8.0.0" "aniso8601-8.0.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "aniso8601") // { provider = "wheel"; };
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
    "bcrypt" = python-self.buildPythonPackage {
      pname = "bcrypt";
      version = "3.2.0";
      src = fetchPypiWheel "bcrypt" "3.2.0" "bcrypt-3.2.0-cp36-abi3-manylinux2010_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "bcrypt") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ cffi six ];
    };
    "billiard" = python-self.buildPythonPackage {
      pname = "billiard";
      version = "3.6.3.0";
      src = fetchPypiWheel "billiard" "3.6.3.0" "billiard-3.6.3.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "billiard") // { provider = "wheel"; };
    };
    "cachetools" = python-self.buildPythonPackage {
      pname = "cachetools";
      version = "4.1.1";
      src = fetchPypiWheel "cachetools" "4.1.1" "cachetools-4.1.1-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "cachetools") // { provider = "wheel"; };
    };
    "celery" = python-self.buildPythonPackage {
      pname = "celery";
      version = "4.4.7";
      src = fetchPypiWheel "celery" "4.4.7" "celery-4.4.7-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "celery") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ billiard kombu pytz vine ];
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
    "click" = python-self.buildPythonPackage {
      pname = "click";
      version = "7.1.2";
      src = fetchPypiWheel "click" "7.1.2" "click-7.1.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "click") // { provider = "wheel"; };
    };
    "cryptography" = python-self.buildPythonPackage {
      pname = "cryptography";
      version = "3.1";
      src = fetchPypiWheel "cryptography" "3.1" "cryptography-3.1-cp35-abi3-manylinux2010_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "cryptography") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ cffi six ];
    };
    "datasketch" = python-self.buildPythonPackage {
      pname = "datasketch";
      version = "1.5.1";
      src = fetchPypiWheel "datasketch" "1.5.1" "datasketch-1.5.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "datasketch") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ numpy ];
    };
    "deprecated" = python-self.buildPythonPackage {
      pname = "deprecated";
      version = "1.2.10";
      src = fetchPypiWheel "deprecated" "1.2.10" "Deprecated-1.2.10-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "deprecated") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ wrapt ];
    };
    "elasticsearch" = python-self.buildPythonPackage {
      pname = "elasticsearch";
      version = "7.9.1";
      src = fetchPypiWheel "elasticsearch" "7.9.1" "elasticsearch-7.9.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "elasticsearch") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ certifi urllib3 ];
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
    "flask" = python-self.buildPythonPackage {
      pname = "flask";
      version = "1.1.2";
      src = fetchPypiWheel "flask" "1.1.2" "Flask-1.1.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "flask") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ click itsdangerous jinja2 werkzeug ];
    };
    "flask-bcrypt" = override python-super.flask-bcrypt ( oldAttrs: {
      pname = "flask-bcrypt";
      version = "0.7.1";
      passthru = (get_passthru python-super "flask-bcrypt") // { provider = "sdist"; };
      src = fetchPypi "flask-bcrypt" "0.7.1";
      propagatedBuildInputs = with python-self; (filter_deps oldAttrs "propagatedBuildInputs") ++ [ bcrypt flask ];
      doCheck = false;
      doInstallCheck = false;
    });
    "flask_login" = python-self.buildPythonPackage {
      pname = "flask-login";
      version = "0.5.0";
      src = fetchPypiWheel "flask-login" "0.5.0" "Flask_Login-0.5.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "flask_login") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ flask ];
    };
    "flask_migrate" = python-self.buildPythonPackage {
      pname = "flask-migrate";
      version = "2.5.3";
      src = fetchPypiWheel "flask-migrate" "2.5.3" "Flask_Migrate-2.5.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "flask_migrate") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ alembic flask flask_sqlalchemy ];
    };
    "flask-restful" = python-self.buildPythonPackage {
      pname = "flask-restful";
      version = "0.3.8";
      src = fetchPypiWheel "flask-restful" "0.3.8" "Flask_RESTful-0.3.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "flask-restful") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ aniso8601 flask pytz six ];
    };
    "flask_script" = override python-super.flask_script ( oldAttrs: {
      pname = "flask-script";
      version = "2.0.6";
      passthru = (get_passthru python-super "flask_script") // { provider = "sdist"; };
      src = fetchPypi "flask-script" "2.0.6";
      propagatedBuildInputs = with python-self; (filter_deps oldAttrs "propagatedBuildInputs") ++ [ flask ];
      doCheck = false;
      doInstallCheck = false;
    });
    "flask_sqlalchemy" = python-self.buildPythonPackage {
      pname = "flask-sqlalchemy";
      version = "2.4.4";
      src = fetchPypiWheel "flask-sqlalchemy" "2.4.4" "Flask_SQLAlchemy-2.4.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "flask_sqlalchemy") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ flask sqlalchemy ];
    };
    "flask_wtf" = python-self.buildPythonPackage {
      pname = "flask-wtf";
      version = "0.14.3";
      src = fetchPypiWheel "flask-wtf" "0.14.3" "Flask_WTF-0.14.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "flask_wtf") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ flask itsdangerous wtforms ];
    };
    "google_auth" = python-self.buildPythonPackage {
      pname = "google-auth";
      version = "1.21.2";
      src = fetchPypiWheel "google-auth" "1.21.2" "google_auth-1.21.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "google_auth") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ cachetools pyasn1-modules rsa setuptools six ];
    };
    "google-auth-oauthlib" = python-self.buildPythonPackage {
      pname = "google-auth-oauthlib";
      version = "0.4.1";
      src = fetchPypiWheel "google-auth-oauthlib" "0.4.1" "google_auth_oauthlib-0.4.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "google-auth-oauthlib") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ google_auth requests_oauthlib ];
    };
    "gunicorn" = python-self.buildPythonPackage {
      pname = "gunicorn";
      version = "20.0.4";
      src = fetchPypiWheel "gunicorn" "20.0.4" "gunicorn-20.0.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "gunicorn") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ setuptools ];
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
    "itsdangerous" = python-self.buildPythonPackage {
      pname = "itsdangerous";
      version = "1.1.0";
      src = fetchPypiWheel "itsdangerous" "1.1.0" "itsdangerous-1.1.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "itsdangerous") // { provider = "wheel"; };
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
    "kombu" = python-self.buildPythonPackage {
      pname = "kombu";
      version = "4.6.11";
      src = fetchPypiWheel "kombu" "4.6.11" "kombu-4.6.11-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "kombu") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ amqp importlib-metadata ];
    };
    "Mako" = python-self.buildPythonPackage {
      pname = "mako";
      version = "1.1.3";
      src = fetchPypiWheel "mako" "1.1.3" "Mako-1.1.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "Mako") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    "markdown" = python-self.buildPythonPackage {
      pname = "markdown";
      version = "3.2.2";
      src = fetchPypiWheel "markdown" "3.2.2" "Markdown-3.2.2-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "markdown") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ importlib-metadata ];
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
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "neo4jrestclient" = python-self.buildPythonPackage {
      pname = "neo4jrestclient";
      version = "2.1.1";
      src = fetchPypi "neo4jrestclient" "2.1.1";
      passthru = (get_passthru python-super "neo4jrestclient") // { provider = "sdist"; };
      propagatedBuildInputs = with python-self; [ requests ];
      doCheck = false;
      doInstallCheck = false;
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
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "oauthlib" = python-self.buildPythonPackage {
      pname = "oauthlib";
      version = "3.1.0";
      src = fetchPypiWheel "oauthlib" "3.1.0" "oauthlib-3.1.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "oauthlib") // { provider = "wheel"; };
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
    "pip" = override python-super.pip ( oldAttrs: {
      pname = "pip";
      version = "20.1.1";
      passthru = (get_passthru python-super "pip") // { provider = "nixpkgs"; };
      doCheck = false;
      doInstallCheck = false;
    });
    "progressbar2" = python-self.buildPythonPackage {
      pname = "progressbar2";
      version = "3.53.1";
      src = fetchPypiWheel "progressbar2" "3.53.1" "progressbar2-3.53.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "progressbar2") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ python-utils six ];
    };
    "pyasn1" = python-self.buildPythonPackage {
      pname = "pyasn1";
      version = "0.4.8";
      src = fetchPypiWheel "pyasn1" "0.4.8" "pyasn1-0.4.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pyasn1") // { provider = "wheel"; };
    };
    "pyasn1-modules" = python-self.buildPythonPackage {
      pname = "pyasn1-modules";
      version = "0.2.8";
      src = fetchPypiWheel "pyasn1-modules" "0.2.8" "pyasn1_modules-0.2.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pyasn1-modules") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyasn1 ];
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
    "pyjwt" = python-self.buildPythonPackage {
      pname = "pyjwt";
      version = "1.7.1";
      src = fetchPypiWheel "pyjwt" "1.7.1" "PyJWT-1.7.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pyjwt") // { provider = "wheel"; };
    };
    "pymisp" = python-self.buildPythonPackage {
      pname = "pymisp";
      version = "2.4.131";
      src = fetchPypiWheel "pymisp" "2.4.131" "pymisp-2.4.131-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "pymisp") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ deprecated jsonschema python-dateutil requests ];
    };
    "pyrsistent" = override python-super.pyrsistent ( oldAttrs: {
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
    "python-editor" = python-self.buildPythonPackage {
      pname = "python-editor";
      version = "1.0.4";
      src = fetchPypiWheel "python-editor" "1.0.4" "python_editor-1.0.4-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "python-editor") // { provider = "wheel"; };
    };
    "python-utils" = python-self.buildPythonPackage {
      pname = "python-utils";
      version = "2.4.0";
      src = fetchPypiWheel "python-utils" "2.4.0" "python_utils-2.4.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "python-utils") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ six ];
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
    "pyyaml" = override python-super.pyyaml ( oldAttrs: {
      pname = "pyyaml";
      version = "5.3.1";
      passthru = (get_passthru python-super "pyyaml") // { provider = "sdist"; };
      src = fetchPypi "pyyaml" "5.3.1";
      doCheck = false;
      doInstallCheck = false;
    });
    "redis" = python-self.buildPythonPackage {
      pname = "redis";
      version = "3.5.3";
      src = fetchPypiWheel "redis" "3.5.3" "redis-3.5.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "redis") // { provider = "wheel"; };
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
    "requests_oauthlib" = python-self.buildPythonPackage {
      pname = "requests-oauthlib";
      version = "1.3.0";
      src = fetchPypiWheel "requests-oauthlib" "1.3.0" "requests_oauthlib-1.3.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "requests_oauthlib") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ oauthlib requests ];
    };
    "rsa" = python-self.buildPythonPackage {
      pname = "rsa";
      version = "4.6";
      src = fetchPypiWheel "rsa" "4.6" "rsa-4.6-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "rsa") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ pyasn1 ];
    };
    "setuptools" = override python-super.setuptools ( oldAttrs: {
      pname = "setuptools";
      version = "47.3.1";
      passthru = (get_passthru python-super "setuptools") // { provider = "nixpkgs"; };
      doCheck = false;
      doInstallCheck = false;
    });
    "sigmatools" = python-self.buildPythonPackage {
      pname = "sigmatools";
      version = "0.18.1";
      src = fetchPypiWheel "sigmatools" "0.18.1" "sigmatools-0.18.1-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "sigmatools") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ progressbar2 pymisp pyyaml ];
    };
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
    "sqlalchemy" = python-self.buildPythonPackage {
      pname = "sqlalchemy";
      version = "1.3.19";
      src = fetchPypiWheel "sqlalchemy" "1.3.19" "SQLAlchemy-1.3.19-cp37-cp37m-manylinux2010_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "sqlalchemy") // { provider = "wheel"; };
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    "tabulate" = python-self.buildPythonPackage {
      pname = "tabulate";
      version = "0.8.7";
      src = fetchPypiWheel "tabulate" "0.8.7" "tabulate-0.8.7-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "tabulate") // { provider = "wheel"; };
    };
    "toolz" = override python-super.toolz ( oldAttrs: {
      pname = "toolz";
      version = "0.10.0";
      passthru = (get_passthru python-super "toolz") // { provider = "sdist"; };
      src = fetchPypi "toolz" "0.10.0";
      doCheck = false;
      doInstallCheck = false;
    });
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
    "vine" = python-self.buildPythonPackage {
      pname = "vine";
      version = "1.3.0";
      src = fetchPypiWheel "vine" "1.3.0" "vine-1.3.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "vine") // { provider = "wheel"; };
    };
    "werkzeug" = python-self.buildPythonPackage {
      pname = "werkzeug";
      version = "1.0.1";
      src = fetchPypiWheel "werkzeug" "1.0.1" "Werkzeug-1.0.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "werkzeug") // { provider = "wheel"; };
    };
    "wrapt" = override python-super.wrapt ( oldAttrs: {
      pname = "wrapt";
      version = "1.12.1";
      passthru = (get_passthru python-super "wrapt") // { provider = "sdist"; };
      src = fetchPypi "wrapt" "1.12.1";
      doCheck = false;
      doInstallCheck = false;
    });
    "wtforms" = python-self.buildPythonPackage {
      pname = "wtforms";
      version = "2.3.3";
      src = fetchPypiWheel "wtforms" "2.3.3" "WTForms-2.3.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "wtforms") // { provider = "wheel"; };
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    "xlrd" = python-self.buildPythonPackage {
      pname = "xlrd";
      version = "1.2.0";
      src = fetchPypiWheel "xlrd" "1.2.0" "xlrd-1.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      dontStrip = true;
      passthru = (get_passthru python-super "xlrd") // { provider = "wheel"; };
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
