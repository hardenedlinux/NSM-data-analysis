{ stdenv, fetchFromGitHub, python3 , python3Packages}:
with python3.pkgs;
let
fastcore = python3Packages.buildPythonPackage rec {
  pname = "fastcore";
  version = "0.1.15";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = pname;
    rev = "dd36d6fb921af5fa8dc23d54701c18b831576fd6";
    sha256 = "0pm4w47i444wfix5kmbmvrx59p19ccnmr3z7smxv75bnbrxybjf6";
  };

  propagatedBuildInputs = with python3Packages;[
    numpy
  ];

  dontUseSetuptoolsCheck = true;

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

python3Packages.buildPythonPackage rec {
  pname = "fastai2";
  version = "2020-03-01";

  src = fetchFromGitHub {
    owner = "fastai";
    repo = "fastai2";
    rev = "4c3556c3c3cdafef774f50613a51f09e653e0dc0";
    sha256 = "0zl7fgxs57spfvljwli96qvsx2q81pkmhhr1x55hfp8m8db8ga48";
  };

  propagatedBuildInputs = with python3Packages; [ pytorch
                                                  torchvision matplotlib pandas requests pyyaml
                                                  pillow scikitlearn scipy spacy fastcore fastprogress
                                                ];

  postPatch = ''
        substituteInPlace settings.ini \
         --replace "torch>=1.3.0" "torch" \
         --replace "torchvision>=0.5" "torchvision"
  '';
  dontUseSetuptoolsCheck = true;

  meta = with stdenv.lib; {
    description = "The fastai deep learning library";
    homepage = "https://github.com/fastai/fastai";
    license = licenses.asl20;
    maintainers = with maintainers; [ eadwu ];
  };
}
