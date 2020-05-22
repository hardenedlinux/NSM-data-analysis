{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
      pname = "jupyter-lsp";
      version = "0.8.0";
      doCheck = false;

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "0cyk4iqr40x21d7dgc4sac2h1kdny9x5kgisclrb3xm393n21gis";
      };
    propagatedBuildInputs = with python3Packages; [ notebook ];
}
