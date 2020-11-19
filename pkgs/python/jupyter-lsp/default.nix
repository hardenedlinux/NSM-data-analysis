{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
      pname = "jupyter-lsp";
      version = "0.9.2";
      doCheck = false;

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "sha256-r8scGSMHWsHyISbnLDAilQmN/Jf4x+LclUcYmMQTgZs=";
      };
    propagatedBuildInputs = with python3Packages; [ notebook ];
}
