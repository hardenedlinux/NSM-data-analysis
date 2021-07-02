{ lib, fetchFromGitHub, python3, python3Packages, nixpkgs-hardenedlinux-sources }:
with python3.pkgs;
let
  fastcore = python3Packages.buildPythonPackage rec {
    inherit (nixpkgs-hardenedlinux-sources.fastcore) pname version src;
    propagatedBuildInputs = with python3Packages;[
      numpy
      packaging
    ];

    dontUseSetuptoolsCheck = true;

  };

  fastprogress = python3Packages.buildPythonPackage rec {
    inherit (nixpkgs-hardenedlinux-sources.fastprogress) pname version src;
    doCheck = false;

    propagatedBuildInputs = with python3Packages; [
      numpy
    ];
  };

in
python3Packages.buildPythonPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.fastai) pname version src;

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
