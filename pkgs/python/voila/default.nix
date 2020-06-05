{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
pname = "voila";
    version = "0.1.21";
    src = fetchPypi {
      inherit pname version;
      sha256 = "1asr4inrqaisvzgpw5im2fx7xxzdyqi3y0kfzq2n7y977hxwdr3f";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ async_generator
                                                    jupyter_server
                                                  ];
}
