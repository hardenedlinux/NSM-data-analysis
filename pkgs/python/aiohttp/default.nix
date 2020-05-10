{ stdenv
, python38Packages
, python3
, lib
}:
with python3.pkgs;
python38Packages.buildPythonPackage rec {
   pname = "aiohttp";
   version = "3.6.2";
    src = fetchPypi {
      inherit pname version;
       sha256 = "09pkw6f1790prnrq0k8cqgnf1qy57ll8lpmc6kld09q7zw4vi6i5";
    };
    doCheck = false;
    checkInputs = [
    pytestrunner pytest gunicorn async_generator pytest_xdist
    pytest-mock pytestcov trustme brotlipy freezegun
    ];

    propagatedBuildInputs =  with python38Packages; [ attrs chardet multidict async-timeout yarl ]
    ++ lib.optionals (pythonOlder "3.7") [ idna-ssl typing-extensions ];
}
