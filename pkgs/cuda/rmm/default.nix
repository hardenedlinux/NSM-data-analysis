{stdenv, fetchFromGitHub, cmake, gcc, python3, cudatoolkit, git, cacert}:

stdenv.mkDerivation rec {

  name = "rmm";
  version = "0.13.0";
  src = fetchFromGitHub{
    owner = "rapidsai";
    repo = "rmm";
    rev = "264672ffaba81028752f3391e0c244daa5a1376a";
    sha256 = "0cm9izkim88w4yrlx0gi2z59nyns1i1a482msxn6cqhw3mi0m66c";
  };


  ## replace git clone gtest to 3rdparty
  nativeBuildInputs = [ cmake ];
  buildInputs = [ cmake gcc cudatoolkit git];
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
