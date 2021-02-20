{ stdenv
, python3Packages
, python3
, fetchFromGitHub
}:
let
  nvidia-ml-py3 = python3Packages.buildPythonPackage rec {
    pname = "nvidia-ml-py3";
    version = "7.352.0";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0xqjypqj0cv7aszklyaad7x3fsqs0q0k3iwq7bk3zmz9ks8h43rr";
    };
    doCheck = false;

    propagatedBuildInputs = with python3Packages; [
    ];
  };

  fastprogress = python3Packages.buildPythonPackage rec {
    pname = "fastprogress";
    version = "0.2.3";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1vgg3wnbfij5kg2a0kx9rjymcwh1fs3fpicl9x6qwlzr9gab2g8d";
    };
    doCheck = false;

    propagatedBuildInputs = with python3Packages; [
    ];
  };
in
with python3.pkgs;
python3Packages.buildPythonPackage rec {
  pname = "fastai";
  version = "1.0.60";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1h96nkn02zbn6qd2nkfxkhbx6jspgj9y7d9cx6p645573f2cajza";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    pyarrow
    scikitimage
    pytest
    pytestrunner
    fastprogress
    torchvision
    nvidia-ml-py3
    spacy
    pytorch
  ];
}
