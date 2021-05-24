{ lib, fetchFromGitHub, python3, python3Packages }:
with python3.pkgs;
let
  fastcore = python3Packages.buildPythonPackage rec {
    version = "2021-02-04";
    pname = "fastcore";

    src = fetchFromGitHub {
      owner = "fastai";
      repo = "fastcore";
      rev = "875988a7ed359a3eb16fd2166bf8fb42b190881c";
      sha256 = "031526i4wj9n124079r6gm4dqncf8vvpz9x6if4k9gw3hppa36c4";
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
  pname = "fastai";
  version = "2021-03-19";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastai";
    rev = "186e02d2b20ca3ad295b4a0c101632364eeabe5c";
    sha256 = "1fsclvr4kl11087q0yvz465aiwh8ml1dns5yq2322daf2gd0ljq8";
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
     --replace "torch>=1.7.0,<1.8" "torch" \
     --replace "torchvision>=0.8,<0.9" "torchvision"
  '';
  dontUseSetuptoolsCheck = true;

  meta = with lib; {
    description = "The fastai deep learning library";
    homepage = "https://github.com/fastai/fastai";
    license = licenses.asl20;

  };
}
