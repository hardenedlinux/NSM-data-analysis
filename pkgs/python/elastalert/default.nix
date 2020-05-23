{ stdenv
, python3Packages
, fetchgit
, python3
}:

let
    aws-requests-auth = python3Packages.buildPythonPackage rec {
    pname = "aws-requests-auth";
    version = "0.4.2";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "087pd76g5x7vpbfb2qk3b4l7p5xn2n31d1qsgs7y40cajgz8ab0i";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ requests ];
    };

    exotel = python3Packages.buildPythonPackage rec {
    pname = "exotel";
    version = "0.1.5";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1x3bhkpablbm6ps897db1ylkyyax0xf7gik4fd2xl575b6vf95nv";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [  ];
    };

    PyStaticConfiguration = python3Packages.buildPythonPackage rec {
    pname = "PyStaticConfiguration";
    version = "0.10.5";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "0dswd655kb46g0hnvsaxrvczycsbc0fai14ywza800flwq4svhba";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [ six ];
    };

    envparse = python3Packages.buildPythonPackage rec {
    pname = "envparse";
    version = "0.2.0";
    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "1dvf0m2jc49s3150b6hwi644apn0zq3g1bdl9q97zljmpckrlfsg";
    };
    doCheck = false;
    propagatedBuildInputs = with python3Packages; [  ];
    };

    stomp-py = python3Packages.buildPythonPackage rec {
      pname = "stomp.py";
      version = "6.0.0";
      src = python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "06y0qcmxbsmdc4z9pldqfr14df0yl4li165vn2c8wa5akbp9yqsf";
      };
      doCheck = false;
      propagatedBuildInputs = with python3Packages; [ docopt ];
    };

in
python3Packages.buildPythonPackage rec {

  pname = "elastalert";
  version = "master";
  src = fetchgit {
    url = "https://github.com/Yelp/elastalert";
    rev = "c6524a3c8dac223a022658f30e5926f5bb124cea";
    sha256 = "0h8mcbj6fij3byb6sy0m5nlkxx396z2r252xn0v4rds52cvvxnhn";
  };

  nativeBuildInputs = [ python3.pkgs.pytest  ];
  propagatedBuildInputs = with python3Packages; [    APScheduler
                                                     aws-requests-auth
                                                     blist
                                                     boto3
                                                     cffi
                                                     configparser
                                                     croniter
                                                     elasticsearch
                                                     envparse
                                                     exotel
                                                     jira
                                                     jsonschema
                                                     mock
                                                     prison
                                                     PyStaticConfiguration
                                                     python-dateutil
                                                     python_magic
                                                     pyyaml
                                                     requests
                                                     stomp-py
                                                     texttable
                                                     twilio

                                                ];
  doCheck = false;

  postPatch = ''
  substituteInPlace setup.py \
  --replace "python-dateutil>=2.6.0,<2.7.0" "python-dateutil" \
  --replace "elasticsearch==7.0.0" "elasticsearch" \
  --replace "twilio>=6.0.0,<6.1" "twilio"

      '';
  meta = with stdenv.lib; {
    description = "Easy & Flexible Alerting With ElasticSearch";
    homepage = "https://github.com/Yelp/elastalert";
    license = licenses.asl20;
  };
}
