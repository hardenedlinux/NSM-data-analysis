{ stdenv
, python3Packages
, python3
, fetchgit
}:
with python3.pkgs;
python3Packages.buildPythonPackage rec {
pname = "voila";
    version = "0.1.21";
    src = fetchgit {
      url = "https://github.com/voila-dashboards/voila";
      rev = "0ecb4183bd7559ef52a61a4c4f4b6f1916c6f2b0";
      sha256 = "1asr4inrqaisvzgpw5im2fx7xxzdyqi3y0kfzq2n7y977hxwdr3f";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ async_generator
                                                    jupyter_server
                                                  ];
}
