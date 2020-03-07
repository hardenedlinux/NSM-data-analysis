{stdenv, fetchFromGitHub, fetchgit, cmake, gcc, python3, cudatoolkit, git, cacert}:
let

  googletest = fetchFromGitHub{
    url = "https://github.com/google/googletest.git";
    owner = "google";
    repo = "googletest";
    rev = "e588eb1ff9ff6598666279b737b27f983156ad85";
    sha256 = "17fd11mk31s72cyirp4c3pmddxz4wl07447kg44kc5jn1zawffwn";
  };
in
stdenv.mkDerivation rec {

  name = "rmm";
  version = "0.13.0";
  src = fetchFromGitHub{
    url = "https://github.com/GTrunSec/rmm.git";
    owner = "GTrunSec";
    repo = "rmm";
    rev = "538c3079d555f36d2aaf2952c32cb4624532a5d0";
    sha256 = "0b3y1cll4jrsljfx7dac4dl37b155gixdr3imklzc4d6dpiwy3f4";
    fetchSubmodules = true;
  };


  ## replace git clone gtest to 3rdparty. Do not downlaod when using cmake
  nativeBuildInputs = [ cmake ];
  buildInputs = [ cmake gcc cudatoolkit git];

  patches = [ ./cmake.patch ];

  preConfigure = ''
      export CUDA_HOME=${cudatoolkit}
         '';

  preferLocalBuild = true;
  SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";

  enableParallelBuilding = true;

  #impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  meta = with stdenv.lib; {
    description = "RAPIDS Memory Manager";
    homepage = https://github.com/rapidsai/rmm;
    license = licenses.bsd3;
    maintainers = with maintainers; [ GTrunSec ];
  };
}
