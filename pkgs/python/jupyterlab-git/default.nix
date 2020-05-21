{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
      pname = "jupyterlab_git";
      version = "0.20.0";
      doCheck = false;

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "0qs3wrcils07xlz698xr7giqf9v63n2qb338mlh7wql93rmjg45i";
      };
    propagatedBuildInputs = with python3Packages; [ notebook  nbdime ];
}
