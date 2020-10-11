{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
let
    voila_env = import ./env/python.nix;
in
python3Packages.buildPythonPackage rec {
pname = "voila";
    version = "0.2.2";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-bbilQxBmoW0m7A2+rdn7NvbLdhEfNWnajwLClzDFGe0=";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ voila_env
                                                  ];

}
