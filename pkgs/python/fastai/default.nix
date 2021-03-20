{ stdenv, lib, fetchFromGitHub, python3, python3Packages }:
with python3.pkgs;
let
  fastcore = python3Packages.buildPythonPackage rec {
    pname = "fastcore";
    version = "1.3.6";

    src = fetchFromGitHub {
      owner = "fastai";
      repo = pname;
      rev = "0204823d0cd2e66d0f6ad3aa716a9c37d41859c3";
      sha256 = "sha256-GH9kmnt5DEQDb7lNscy0BSY4KqJcRzawMqDufMS7kRU=";
    };

    propagatedBuildInputs = with python3Packages;[
      numpy
      packaging
    ];

    dontUseSetuptoolsCheck = true;

  };
  fastprogress = python3Packages.buildPythonPackage rec {
    pname = "fastprogress";
    version = "1.0.0";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "sha256-ieKKwdKlQSqrGO4/Pf0e6LXB8vekTQrdDQ1PafAZG/4=";
    };
    doCheck = false;

    propagatedBuildInputs = with python3Packages; [
      numpy
    ];
  };

in
python3Packages.buildPythonPackage rec {
  pname = "fastai2";
  version = "2.1.5";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastai";
    rev = "e9d8aa82d9fafd662a3669c25e0cbc8f389ab236";
    sha256 = "sha256-1eO95riB+ffiCORgOyb5I5im8KlJRuIBlGQU/nBt7y0=";
  };

  propagatedBuildInputs = with python3Packages; [
    pytorch
    torchvision
    matplotlib
    pandas
    requests
    pyyaml
    pillow
    scikitlearn
    scipy
    spacy
    fastcore
    fastprogress
  ];

  postPatch = ''
    substituteInPlace settings.ini \
     --replace "torch>=1.7.0" "torch" \
     --replace "torchvision>=0.8" "torchvision"
  '';
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "The fastai deep learning library";
    homepage = "https://github.com/fastai/fastai";
    license = licenses.asl20;

  };
}
