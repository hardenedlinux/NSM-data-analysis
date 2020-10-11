{ stdenv
, python3Packages
, python3
, fetchFromGitHub
}:
with python3.pkgs;
let
  timesketch_dep = import ./python.nix;
in
python3Packages.buildPythonPackage rec {
      pname = "timesketch";
      version = "20201009";
      src = fetchFromGitHub {
        owner = "google";
        repo = "timesketch";
        rev = "9cb28767afc75d1b4a9b7e01f293d8e68bc3b783";
        sha256 = "sha256-a+wICOycA2LNODJBVuLm5jSuluI5R7E2jCY2JtGRiCU=";
      };
      doCheck = false;

      propagatedBuildInputs = with python3Packages; [ timesketch_dep
                                                    ];
      # postPatch = ''
      # substituteInPlace requirements.txt \
      #  --replace "sigmatools==0.14" "sigmatools" \
      #  --replace "flask_migrate==2.5.2" "flask-migrate" \
      #  --replace "elasticsearch==7.5.1" "elasticsearch" \
      #  --replace "numpy==1.16.6" "numpy" \
      #  --replace "tabulate==0.8.6" "tabulate" \
      #  --replace "flask_login==0.4.1" "flask-login" \
      #  --replace "SQLAlchemy==1.3.12" "SQLAlchemy" \
      #  --replace "gunicorn==19.10.0" "gunicorn" \
      #  --replace "Flask==1.1.1" "Flask" \
      #  --replace "alembic==1.3.2" "alembic" \
      #  --replace "requests==2.22.0" "requests" \
      #  --replace "cryptography==2.3" "cryptography" \
      #  --replace "WTForms==2.2.1" "WTForms" \
      #  --replace "celery==4.4.0" "celery" \
      #  --replace "flask_restful==0.3.7" "flask_restful" \
      #  --replace "redis==3.3.11" "redis" \
      #  --replace "altair==3.3.0" "altair" \
      #  --replace "flask_wtf==0.14.2" "flask-wtf" \
      #  --replace "python_dateutil==2.8.1" "python_dateutil" \
      #  --replace "pandas==0.24.2" "pandas" \
      #  --replace "PyYAML==5.3" "PyYAML" \
      #  --replace "google-auth==1.7.0" "google-auth" \
      #  --replace "Werkzeug==0.16.0" "Werkzeug"
      # '';
}
