{pkgs}:
let
  pypi_fetcher_src = pkgs.fetchgit {
    name = "nix-pypi-fetcher";
    url = "https://github.com/DavHau/nix-pypi-fetcher";
    rev = "236f107a1f36a2cf91e502edb8b06a526768f1c7";
    # Hash obtained using `nix-prefetch-url --unpack <url>`
    sha256 = "1jkllah8z8zb34k4322n7fadxvjh3a2gkfgam5hpdkxyrv4ylv0r";
  };
  fetchPypi = (import pypi_fetcher_src).fetchPypi;
  fetchPypiWheel = (import pypi_fetcher_src).fetchPypiWheel;
  try_get = obj: name:
    if builtins.hasAttr name obj
    then obj."${name}"
    else [];
  select_pkgs = ps: with ps; [
    alembic
    altair
    celery
    cryptography
    datasketch
    elasticsearch
    flask
    flask-bcrypt
    flask_login
    flask_migrate
    flask-restful-own
    flask_script
    flask_sqlalchemy
    flask_wtf
    google_auth
    google-auth-oauthlib
    gunicorn
    mans-to-es
    neo4jrestclient
    numpy
    oauthlib
    pandas
    pyjwt
    python-dateutil
    pyyaml
    redis
    requests
    sigmatools
    six
    sqlalchemy
    tabulate
    werkzeug
    wtforms
    xlrd 
  ];
  overrides = manylinux1: autoPatchelfHook: python-self: python-super: rec {
    alembic = python-self.buildPythonPackage {
      name = "alembic-1.0.0";
      src = fetchPypiWheel "alembic" "1.0.0" "alembic-1.0.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ Mako python-dateutil python-editor sqlalchemy ];
    };
    altair = python-self.buildPythonPackage {
      name = "altair-4.1.0";
      src = fetchPypiWheel "altair" "4.1.0" "altair-4.1.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ entrypoints jinja2 jsonschema numpy pandas toolz ];
    };
    amqp = python-self.buildPythonPackage {
      name = "amqp-2.5.2";
      src = fetchPypiWheel "amqp" "2.5.2" "amqp-2.5.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ vine ];
    };
    aniso8601 = python-self.buildPythonPackage {
      name = "aniso8601-8.0.0";
      src = fetchPypiWheel "aniso8601" "8.0.0" "aniso8601-8.0.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    attrs = python-self.buildPythonPackage {
      name = "attrs-19.3.0";
      src = fetchPypiWheel "attrs" "19.3.0" "attrs-19.3.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    bcrypt = python-super.bcrypt.overridePythonAttrs ( oldAttrs: {
      name = "bcrypt-3.1.7";
      src = fetchPypi "bcrypt" "3.1.7";
      buildInputs = with python-self; (try_get oldAttrs "buildInputs") ++ [ cffi ];
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ cffi six ];
      doCheck = false;
      doInstallCheck = false;
    });
    billiard = python-self.buildPythonPackage {
      name = "billiard-3.6.3.0";
      src = fetchPypiWheel "billiard" "3.6.3.0" "billiard-3.6.3.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    cachetools = python-self.buildPythonPackage {
      name = "cachetools-4.1.0";
      src = fetchPypiWheel "cachetools" "4.1.0" "cachetools-4.1.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    celery = python-self.buildPythonPackage {
      name = "celery-4.4.2";
      src = fetchPypiWheel "celery" "4.4.2" "celery-4.4.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ billiard kombu pytz vine ];
    };
    certifi = python-self.buildPythonPackage {
      name = "certifi-2020.4.5.1";
      src = fetchPypiWheel "certifi" "2020.4.5.1" "certifi-2020.4.5.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    cffi = python-self.buildPythonPackage {
      name = "cffi-1.14.0";
      src = fetchPypiWheel "cffi" "1.14.0" "cffi-1.14.0-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ pycparser ];
    };
    chardet = python-self.buildPythonPackage {
      name = "chardet-3.0.4";
      src = fetchPypiWheel "chardet" "3.0.4" "chardet-3.0.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    ciso8601 = python-self.buildPythonPackage {
      name = "ciso8601-2.1.1";
      src = fetchPypi "ciso8601" "2.1.1";
      doCheck = false;
      doInstallCheck = false;
    };
    click = python-self.buildPythonPackage {
      name = "click-7.1.2";
      src = fetchPypiWheel "click" "7.1.2" "click-7.1.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    cryptography = python-super.cryptography.overridePythonAttrs ( oldAttrs: {
      name = "cryptography-2.9.2";
      src = fetchPypi "cryptography" "2.9.2";
      buildInputs = with python-self; (try_get oldAttrs "buildInputs") ++ [ cffi ];
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ cffi six ];
      doCheck = false;
      doInstallCheck = false;
    });
    datasketch = python-self.buildPythonPackage {
      name = "datasketch-1.5.0";
      src = fetchPypiWheel "datasketch" "1.5.0" "datasketch-1.5.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ numpy ];
    };
    deprecated = python-self.buildPythonPackage {
      name = "deprecated-1.2.9";
      src = fetchPypiWheel "deprecated" "1.2.9" "Deprecated-1.2.9-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ wrapt ];
    };
    elasticsearch = python-self.buildPythonPackage {
      name = "elasticsearch-7.0.2";
      src = fetchPypiWheel "elasticsearch" "7.0.2" "elasticsearch-7.0.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ urllib3 ];
    };
    entrypoints = python-self.buildPythonPackage {
      name = "entrypoints-0.3";
      src = fetchPypiWheel "entrypoints" "0.3" "entrypoints-0.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    flask = python-self.buildPythonPackage {
      name = "flask-1.1.2";
      src = fetchPypiWheel "flask" "1.1.2" "Flask-1.1.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ click itsdangerous jinja2 werkzeug ];
    };
    flask-bcrypt = python-super.flask-bcrypt.overridePythonAttrs ( oldAttrs: {
      name = "flask-bcrypt-0.7.1";
      src = fetchPypi "flask-bcrypt" "0.7.1";
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ bcrypt flask ];
      doCheck = false;
      doInstallCheck = false;
    });
    flask_login = python-self.buildPythonPackage {
      name = "flask-login-0.5.0";
      src = fetchPypiWheel "flask-login" "0.5.0" "Flask_Login-0.5.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ flask ];
    };
    flask_migrate = python-self.buildPythonPackage {
      name = "flask-migrate-2.5.3";
      src = fetchPypiWheel "flask-migrate" "2.5.3" "Flask_Migrate-2.5.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ alembic flask flask_sqlalchemy ];
    };
    flask-restful-own = python-self.buildPythonPackage {
      name = "flask-restful-0.3.8";
      src = fetchPypi "flask-restful" "0.3.8";
      propagatedBuildInputs = with python-self; [  flask six pytz aniso8601 pycrypto
                                                ];
      doCheck = false;
      doInstallCheck = false;
    };
    flask_script = python-super.flask_script.overridePythonAttrs ( oldAttrs: {
      name = "flask-script-2.0.6";
      src = fetchPypi "flask-script" "2.0.6";
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ flask ];
      doCheck = false;
      doInstallCheck = false;
    });
    flask_sqlalchemy = python-self.buildPythonPackage {
      name = "flask-sqlalchemy-2.4.1";
      src = fetchPypiWheel "flask-sqlalchemy" "2.4.1" "Flask_SQLAlchemy-2.4.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ flask sqlalchemy ];
    };
    flask_wtf = python-self.buildPythonPackage {
      name = "flask-wtf-0.14.3";
      src = fetchPypiWheel "flask-wtf" "0.14.3" "Flask_WTF-0.14.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ flask itsdangerous wtforms ];
    };
    google_auth = python-self.buildPythonPackage {
      name = "google-auth-1.14.1";
      src = fetchPypiWheel "google-auth" "1.14.1" "google_auth-1.14.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ cachetools pyasn1-modules rsa setuptools six ];
    };
    google-auth-oauthlib = python-self.buildPythonPackage {
      name = "google-auth-oauthlib-0.4.1";
      src = fetchPypiWheel "google-auth-oauthlib" "0.4.1" "google_auth_oauthlib-0.4.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ google_auth requests_oauthlib ];
    };
    gunicorn = python-self.buildPythonPackage {
      name = "gunicorn-20.0.4";
      src = fetchPypiWheel "gunicorn" "20.0.4" "gunicorn-20.0.4-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ setuptools ];
    };
    idna = python-self.buildPythonPackage {
      name = "idna-2.9";
      src = fetchPypiWheel "idna" "2.9" "idna-2.9-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    importlib-metadata = python-self.buildPythonPackage {
      name = "importlib-metadata-1.6.0";
      src = fetchPypiWheel "importlib-metadata" "1.6.0" "importlib_metadata-1.6.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ zipp ];
    };
    itsdangerous = python-self.buildPythonPackage {
      name = "itsdangerous-1.1.0";
      src = fetchPypiWheel "itsdangerous" "1.1.0" "itsdangerous-1.1.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    jinja2 = python-self.buildPythonPackage {
      name = "jinja2-2.11.2";
      src = fetchPypiWheel "jinja2" "2.11.2" "Jinja2-2.11.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    jsonschema = python-self.buildPythonPackage {
      name = "jsonschema-3.2.0";
      src = fetchPypiWheel "jsonschema" "3.2.0" "jsonschema-3.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ attrs importlib-metadata pyrsistent setuptools six ];
    };
    kombu = python-self.buildPythonPackage {
      name = "kombu-4.6.8";
      src = fetchPypiWheel "kombu" "4.6.8" "kombu-4.6.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ amqp importlib-metadata ];
    };
    Mako = python-self.buildPythonPackage {
      name = "mako-1.1.2";
      src = fetchPypiWheel "mako" "1.1.2" "Mako-1.1.2-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    mans-to-es = python-self.buildPythonPackage {
      name = "mans-to-es-1.4";
      src = fetchPypiWheel "mans-to-es" "1.4" "mans_to_es-1.4-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ certifi ciso8601 elasticsearch numpy pandas python-dateutil pytz six urllib3 xmltodict ];
    };
    markupsafe = python-self.buildPythonPackage {
      name = "markupsafe-1.1.1";
      src = fetchPypiWheel "markupsafe" "1.1.1" "MarkupSafe-1.1.1-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    neo4jrestclient = python-self.buildPythonPackage {
      name = "neo4jrestclient-2.1.1";
      src = fetchPypi "neo4jrestclient" "2.1.1";
      propagatedBuildInputs = with python-self; [ requests ];
      doCheck = false;
      doInstallCheck = false;
    };
    numpy = python-self.buildPythonPackage {
      name = "numpy-1.16.4";
      src = fetchPypiWheel "numpy" "1.16.4" "numpy-1.16.4-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    oauthlib = python-self.buildPythonPackage {
      name = "oauthlib-3.1.0";
      src = fetchPypiWheel "oauthlib" "3.1.0" "oauthlib-3.1.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    pandas = python-self.buildPythonPackage {
      name = "pandas-0.25.0";
      src = fetchPypiWheel "pandas" "0.25.0" "pandas-0.25.0-cp37-cp37m-manylinux1_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [ numpy python-dateutil pytz ];
    };
    progressbar2 = python-self.buildPythonPackage {
      name = "progressbar2-3.47.0";
      src = fetchPypiWheel "progressbar2" "3.47.0" "progressbar2-3.47.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ python-utils six ];
    };
    progressbar = python-self.progressbar2;
    progressbar33 = python-self.progressbar2;
    pyasn1 = python-self.buildPythonPackage {
      name = "pyasn1-0.4.8";
      src = fetchPypiWheel "pyasn1" "0.4.8" "pyasn1-0.4.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    pyasn1-modules = python-self.buildPythonPackage {
      name = "pyasn1-modules-0.2.8";
      src = fetchPypiWheel "pyasn1-modules" "0.2.8" "pyasn1_modules-0.2.8-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ pyasn1 ];
    };
    pycparser = python-self.buildPythonPackage {
      name = "pycparser-2.20";
      src = fetchPypiWheel "pycparser" "2.20" "pycparser-2.20-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    pyjwt = python-self.buildPythonPackage {
      name = "pyjwt-1.7.1";
      src = fetchPypiWheel "pyjwt" "1.7.1" "PyJWT-1.7.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    pymisp = python-self.buildPythonPackage {
      name = "pymisp-2.4.121.1";
      src = fetchPypiWheel "pymisp" "2.4.121.1" "pymisp-2.4.121.1-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ deprecated jsonschema python-dateutil requests six ];
    };
    pyrsistent = python-super.pyrsistent.overridePythonAttrs ( oldAttrs: {
      name = "pyrsistent-0.16.0";
      src = fetchPypi "pyrsistent" "0.16.0";
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ six ];
      doCheck = false;
      doInstallCheck = false;
    });
    python-dateutil = python-self.buildPythonPackage {
      name = "python-dateutil-2.8.0";
      src = fetchPypiWheel "python-dateutil" "2.8.0" "python_dateutil-2.8.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ six ];
    };
    python-editor = python-self.buildPythonPackage {
      name = "python-editor-1.0.4";
      src = fetchPypiWheel "python-editor" "1.0.4" "python_editor-1.0.4-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    python-utils = python-super.python-utils.overridePythonAttrs ( oldAttrs: {
      name = "python-utils-2.4.0";
      src = fetchPypi "python-utils" "2.4.0";
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ six ];
      doCheck = false;
      doInstallCheck = false;
    });
    pytz = python-self.buildPythonPackage {
      name = "pytz-2019.1";
      src = fetchPypiWheel "pytz" "2019.1" "pytz-2019.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    pyyaml = python-super.pyyaml.overridePythonAttrs ( oldAttrs: {
      name = "pyyaml-5.3.1";
      src = fetchPypi "pyyaml" "5.3.1";
      doCheck = false;
      doInstallCheck = false;
    });
    pyyaml_3 = python-self.pyyaml;
    redis = python-self.buildPythonPackage {
      name = "redis-3.5.0";
      src = fetchPypiWheel "redis" "3.5.0" "redis-3.5.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    requests = python-self.buildPythonPackage {
      name = "requests-2.23.0";
      src = fetchPypiWheel "requests" "2.23.0" "requests-2.23.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ certifi chardet idna urllib3 ];
    };
    requests_oauthlib = python-self.buildPythonPackage {
      name = "requests-oauthlib-1.3.0";
      src = fetchPypiWheel "requests-oauthlib" "1.3.0" "requests_oauthlib-1.3.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ oauthlib requests ];
    };
    rsa = python-super.rsa.overridePythonAttrs ( oldAttrs: {
      name = "rsa-4.0";
      src = fetchPypi "rsa" "4.0";
      propagatedBuildInputs = with python-self; (try_get oldAttrs "propagatedBuildInputs") ++ [ pyasn1 ];
      doCheck = false;
      doInstallCheck = false;
    });
    sigmatools = python-self.buildPythonPackage {
      name = "sigmatools-0.16.0";
      src = fetchPypiWheel "sigmatools" "0.16.0" "sigmatools-0.16.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ progressbar2 pymisp pyyaml ];
    };
    six = python-self.buildPythonPackage {
      name = "six-1.12.0";
      src = fetchPypiWheel "six" "1.12.0" "six-1.12.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    sqlalchemy = python-self.buildPythonPackage {
      name = "sqlalchemy-1.3.16";
      src = fetchPypiWheel "sqlalchemy" "1.3.16" "SQLAlchemy-1.3.16-cp37-cp37m-manylinux2010_x86_64.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      nativeBuildInputs = [ autoPatchelfHook ];
      autoPatchelfIgnoreNotFound = true;
      propagatedBuildInputs = with python-self; manylinux1 ++ [  ];
    };
    tabulate = python-self.buildPythonPackage {
      name = "tabulate-0.8.7";
      src = fetchPypiWheel "tabulate" "0.8.7" "tabulate-0.8.7-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    toolz = python-super.toolz.overridePythonAttrs ( oldAttrs: {
      name = "toolz-0.10.0";
      src = fetchPypi "toolz" "0.10.0";
      doCheck = false;
      doInstallCheck = false;
    });
    urllib3 = python-self.buildPythonPackage {
      name = "urllib3-1.25.3";
      src = fetchPypiWheel "urllib3" "1.25.3" "urllib3-1.25.3-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    vine = python-self.buildPythonPackage {
      name = "vine-1.3.0";
      src = fetchPypiWheel "vine" "1.3.0" "vine-1.3.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    werkzeug = python-self.buildPythonPackage {
      name = "werkzeug-1.0.1";
      src = fetchPypiWheel "werkzeug" "1.0.1" "Werkzeug-1.0.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    wrapt = python-super.wrapt.overridePythonAttrs ( oldAttrs: {
      name = "wrapt-1.12.1";
      src = fetchPypi "wrapt" "1.12.1";
      doCheck = false;
      doInstallCheck = false;
    });
    wtforms = python-self.buildPythonPackage {
      name = "wtforms-2.3.1";
      src = fetchPypiWheel "wtforms" "2.3.1" "WTForms-2.3.1-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
      propagatedBuildInputs = with python-self; [ markupsafe ];
    };
    xlrd = python-self.buildPythonPackage {
      name = "xlrd-1.2.0";
      src = fetchPypiWheel "xlrd" "1.2.0" "xlrd-1.2.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    xmltodict = python-self.buildPythonPackage {
      name = "xmltodict-0.12.0";
      src = fetchPypiWheel "xmltodict" "0.12.0" "xmltodict-0.12.0-py2.py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
    zipp = python-self.buildPythonPackage {
      name = "zipp-3.1.0";
      src = fetchPypiWheel "zipp" "3.1.0" "zipp-3.1.0-py3-none-any.whl";
      format = "wheel";
      doCheck = false;
      doInstallCheck = false;
    };
  };
in
{ inherit overrides select_pkgs; }
