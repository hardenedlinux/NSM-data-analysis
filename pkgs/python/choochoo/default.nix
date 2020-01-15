{ stdenv
, python3Packages
, python3
}:
with python3.pkgs;
let
    textblob = python3Packages.buildPythonPackage rec {
    pname = "textblob";
    version = "0.15.3";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "7ff3c00cb5a85a30132ee6768b8c68cb2b9d76432fec18cd1b3ffe2f8594ec8c";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ nltk ];
    };
    
    sklearn = python3Packages.buildPythonPackage rec {
    pname = "sklearn";
    version = "0.0";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "e23001573aa194b834122d2b9562459bf5ae494a2d59ca6b8aa22c85a44c0e31";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ scikitlearn ];
    };

    pyGeoTile = python3Packages.buildPythonPackage rec {
    pname = "pyGeoTile";
    version = "1.0.6";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "64b1cfac77a392e81e2220412872cd0fb4988c25e136f8aed7c03ced59134ff9";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [  ];
    };


    sentinelsat = python3Packages.buildPythonPackage rec {
    pname = "sentinelsat";
    version = "0.13";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "a4ffd5d17b4a57928bb95104a0405f5de4c1d5dd00571023c3af97037ea18440";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ html2text geojson requests tqdm click
                                                    (python3Packages.buildPythonPackage rec {
                                                       pname = "geomet";
                                                       version = "0.2.1.post1";
                                                       src = python3Packages.fetchPypi {
                                                         inherit pname version;
                                                         sha256 = "91d754f7c298cbfcabd3befdb69c641c27fe75e808b27aa55028605761d17e95";
                                                       };
                                                       doCheck = false;
                                                       propagatedBuildInputs = with python3Packages; [ click six];
                                                    })
                                                  ];
    };
in
python3Packages.buildPythonPackage rec {

  pname = "choochoo";
  version = "0.28.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "d72b7627f778adf6a2cf952553a2433284d3e43fb30fac348dadf5b73be49f04";
  };  

  propagatedBuildInputs = with python3Packages; [ bokeh
                                                  cachetools
                                                  colorama
                                                  jupyter
                                                  matplotlib
                                                  numpy
                                                  pyGeoTile
                                                  sentinelsat
                                                  sklearn
                                                  openpyxl
                                                  pandas
                                                  pendulum
                                                  psutil
                                                  pyproj
                                                  rasterio
                                                  requests
                                                  scipy
                                                  scikitimage
                                                  shapely
                                                  sqlalchemy
                                                  urwid
                                                  textblob
                                                ];
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Data Science for Training'";
    homepage = "https://github.com/andrewcooke/choochoo";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
