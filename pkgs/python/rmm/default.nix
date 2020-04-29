{ stdenv
, python3Packages
, fetchgit
, cudatoolkit
}:

python3Packages.buildPythonPackage rec {

  pname = "rmm";
  version = "0.2.0";
  src = fetchgit {
    url = "https://github.com/rapidsai/rmm";
    rev = "83f474b7f222de9e4c8f970cc26c32b94cd9c52b";
    sha256 = "071m9mh51gmy2y65c4c790zr4fwr0s3fn0p8b77sms20rr0nx4gs";
  };

  nativeBuildInputs = [ cudatoolkit  ];
  propagatedBuildInputs = with python3Packages; [
                                                     cython
                                                ];
  doCheck = false;
  postPatch = ''
    cd python
      '';
  meta = with stdenv.lib; {
    description = "RAPIDS Memory Manager";
    homepage = "https://github.com/rapidsai/rmm";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
