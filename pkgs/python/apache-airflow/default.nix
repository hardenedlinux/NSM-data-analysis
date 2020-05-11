{ stdenv
, python3Packages
, python3
, lib
, fetchFromGitHub
, fetchpatch
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "apache-airflow";
  version = "1.10.5";
  disabled = (!isPy3k);

  src = fetchFromGitHub rec {
    owner = "apache";
    repo = "airflow";
    rev = version;
    sha256 = "14fmhfwx977c9jdb2kgm93i6acx43l45ggj30rb37r68pzpb6l6h";
  };

  patches = [
       # Not yet accepted: https://github.com/apache/airflow/pull/6562
     (fetchpatch {
       name = "avoid-warning-from-abc.collections";
       url = "https://patch-diff.githubusercontent.com/raw/apache/airflow/pull/6562.patch";
       sha256 = "0swpay1qlb7f9kgc56631s1qd9k82w4nw2ggvkm7jvxwf056k61z";
     })
       # Not yet accepted: https://github.com/apache/airflow/pull/6561
     (fetchpatch {
       name = "pendulum2-compatibility";
       url = "https://patch-diff.githubusercontent.com/raw/apache/airflow/pull/6561.patch";
       sha256 = "17hw8qyd4zxvib9zwpbn32p99vmrdz294r31gnsbkkcl2y6h9knk";
     })
  ];

    doCheck = false;

    propagatedBuildInputs =  with python3Packages; [
      alembic
    cached-property
    colorlog
    configparser
    croniter
    dill
    flask
    flask-admin
    flask-appbuilder
    flask-bcrypt
    flask-caching
    flask_login
    flask-swagger
    flask_wtf
    funcsigs
    future
    GitPython
      (python3Packages.buildPythonPackage rec {
        pname = "gunicorn";
        version = "19.10.0";

        src = fetchPypi {
          inherit pname version;
          sha256 = "1080jk1ly8j0rc6lv8i33sj94rxjaskd1732cdq5chdqb3ij9ppr";
        };

        propagatedBuildInputs = [ setuptools ];

        checkInputs = [ pytest mock pytestcov coverage ];

        prePatch = ''
    substituteInPlace requirements_test.txt --replace "==" ">=" \
      --replace "coverage>=4.0,<4.4" "coverage"
  '';

        # better than no tests
        checkPhase = ''
    $out/bin/gunicorn --help > /dev/null
  '';

        pythonImportsCheck = [ "gunicorn" ];
      })
    iso8601
    json-merge-patch
    jinja2
    ldap3
    lxml
    lazy-object-proxy
    markdown
      pandas
      (buildPythonPackage rec {
        pname = "pendulum";
        version = "1.4.4";

        src = fetchPypi {
          inherit pname version;
          sha256 = "0p5c7klnfjw8f63x258rzbhnl1p0hn83lqdnhhblps950k5m47k0";
        };

        propagatedBuildInputs = [ dateutil pytzdata
                                  (buildPythonPackage rec {
                                    pname = "tzlocal";
                                    version = "1.5.1";
                                    propagatedBuildInputs = [ pytz ];
                                    src = fetchPypi {
                                      inherit pname version;
                                      sha256 = "0kiciwiqx0bv0fbc913idxibc4ygg4cb7f8rcpd9ij2shi4bigjf";
                                    };

                                    # test fail (timezone test fail)
                                    doCheck = false;})

                                ] ++ lib.optional (pythonOlder "3.5") typing;
        doCheck = false;

      })
      psutil
      pygments
      python-daemon
      python-dateutil
      requests
      setproctitle
      sqlalchemy
      tabulate
      tenacity
      termcolor
      text-unidecode
    thrift
    unicodecsv
    werkzeug
    zope_deprecation
  ];

  checkInputs = [
    snakebite
    nose
  ];

  postPatch = ''

    substituteInPlace  airflow/settings.py \
    --replace "TIMEZONE = pendulum.timezone('UTC')"  "TIMEZONE = pendulum.timezone('Asia/Shanghai')"
    substituteInPlace setup.py \
      --replace "flask>=1.1.0, <2.0" "flask" \
      --replace "jinja2>=2.10.1, <2.11.0" "jinja2" \
      --replace "pandas>=0.17.1, <1.0.0" "pandas" \
      --replace "pendulum>=2" "pendulum" \
      --replace "flask-caching>=1.3.3, <1.4.0" "flask-caching" \
      --replace "flask-appbuilder>=1.12.5, <2.0.0" "flask-appbuilder" \
      --replace "cached_property~=1.5" "cached_property" \
      --replace "dill>=0.2.2, <0.3" "dill" \
      --replace "configparser>=3.5.0, <3.6.0" "configparser" \
      --replace "jinja2>=2.7.3, <=2.10.0" "jinja2" \
      --replace "colorlog==4.0.2" "colorlog" \
      --replace "funcsigs==1.0.0" "funcsigs" \
      --replace "flask-swagger==0.2.13" "flask-swagger" \
      --replace "python-daemon>=2.1.1, <2.2" "python-daemon" \
      --replace "alembic>=0.9, <1.0" "alembic" \
      --replace "markdown>=2.5.2, <3.0" "markdown" \
      --replace "future>=0.16.0, <0.17" "future" \
      --replace "tenacity==4.12.0" "tenacity" \
      --replace "text-unidecode==1.2" "text-unidecode" \
      --replace "tzlocal>=1.4,<2.0.0" "tzlocal" \
      --replace "sqlalchemy~=1.3" "sqlalchemy" \
      --replace "werkzeug>=0.14.1, <0.15.0" "werkzeug"

    # dumb-init is only needed for CI and Docker, not relevant for NixOS.
    substituteInPlace setup.py \
      --replace "'dumb-init>=1.2.2'," ""

    substituteInPlace tests/core.py \
      --replace "/bin/bash" "${stdenv.shell}"
  '';

  checkPhase = ''
   export HOME=$(mktemp -d)
   export AIRFLOW_HOME=$HOME
   export AIRFLOW__CORE__UNIT_TEST_MODE=True
   export AIRFLOW_DB="$HOME/airflow.db"
   airflow version
   airflow initdb
   airflow resetdb -y
   export PATH=$PATH:$out/bin
   nosetests tests.core.CoreTest
   ## all tests
   # nosetests --cover-package=airflow
  '';
}
