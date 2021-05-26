{ python3Packages
, python3
, fetchgit
}:
with python3.pkgs;
let
  beakerx-tabledisplay = python3Packages.buildPythonPackage rec {
    pname = "beakerx_tabledisplay";
    version = "master";
    src = fetchgit {
      url = "https://github.com/twosigma/beakerx";
      rev = "b527ac462b1e7569fe939a7fd09ec74fbbf96b07";
      sha256 = "0pm2ac9wrxflzv5y552qc075diiyp1ihznxrkl3vzd5gm1hf0f0x";
    };
    doCheck = false;
    postPatch = ''
      cd beakerx_tabledisplay
    '';
    propagatedBuildInputs = with python3Packages; [
      setuptools

      (
        let
          beakerx-base = python3Packages.buildPythonPackage rec {
            pname = "beakerx-base";
            version = "master";
            src = fetchgit {
              url = "https://github.com/twosigma/beakerx";
              rev = "b527ac462b1e7569fe939a7fd09ec74fbbf96b07";
              sha256 = "0pm2ac9wrxflzv5y552qc075diiyp1ihznxrkl3vzd5gm1hf0f0x";
            };
            doCheck = false;
            postPatch = ''
              cd  beakerx_base
              substituteInPlace setup.py \
              --replace "tornado>6" "tornado"

            '';
            propagatedBuildInputs = with python3Packages; [
              setuptools
              py4j
              ipywidgets
              pandas
              #(tornado.overridePythonAttrs (oldAttrs: {version = "6.0.4";}))
              # (python3Packages.buildPythonPackage rec {
              #   pname = "tornado";
              #   version = "6.0.3";
              #   src = python3Packages.fetchPypi {
              #     pname = "tornado";
              #     version = "6.0.3";
              #     sha256 = "1afpxpv75zi1zvj2b3s6d7r4s4p0z2byh7jv9h3i4sb1p8vdnif8";
              #   };
              #   doCheck = false;
              #   propagatedBuildInputs = with python3Packages; [ backports_abc  certifi singledispatch ];
              # })
              tornado
            ];
          };
        in
        [ beakerx-base ]
      )
      pandas
    ];
  };

  # beakerx-base = python3Packages.buildPythonPackage rec {
  #  pname = "beakerx-base";
  #  version = "master";
  #  src = fetchgit {
  #    url = "https://github.com/twosigma/beakerx";
  #    rev = "b527ac462b1e7569fe939a7fd09ec74fbbf96b07";
  #    sha256 = "0pm2ac9wrxflzv5y552qc075diiyp1ihznxrkl3vzd5gm1hf0f0x";
  #  };
  #  doCheck = false;
  #  postPatch = ''
  #      cd  beakerx_base
  #      substituteInPlace setup.py \
  #       --replace "tornado>6" "tornado"
  #    '';
  #  propagatedBuildInputs = with python3Packages; [ setuptools
  #                                                  py4j
  #                                                  ipywidgets
  #                                                  pandas
  #                                                  #(tornado.overridePythonAttrs(oldAttrs: {version = "6.0.4";}))
  #                                                  tornado
  #                                                ];
  #  };

in
python3Packages.buildPythonPackage rec {
  pname = "beakerx";
  version = "master";
  src = fetchgit {
    url = "https://github.com/twosigma/beakerx";
    rev = "b527ac462b1e7569fe939a7fd09ec74fbbf96b07";
    sha256 = "0pm2ac9wrxflzv5y552qc075diiyp1ihznxrkl3vzd5gm1hf0f0x";
  };
  doCheck = false;
  propagatedBuildInputs = with python3Packages; [
    beakerx-tabledisplay
  ];
  postPatch = ''
    cd beakerx
  '';
}
