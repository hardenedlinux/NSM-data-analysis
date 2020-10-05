{ stdenv
, python3Packages
, fetchgit
, python3
, pillow, gfortran, glibcLocales
}:

with python3.pkgs;

python3Packages.buildPythonPackage rec {
  pname = "scikit-learn";
  version = "0.20.4";


  src = fetchPypi {
    inherit pname version;
    sha256 = "1z3w2c50dwwa297j88pr16pyrjysagsvdj7vrlq40q8777rs7a6z";
  };

  buildInputs = [ pillow gfortran glibcLocales ];
  propagatedBuildInputs = with python3Packages; [ numpy scipy numpy.blas ];
  checkInputs = with python3Packages; [ pytest ];

  LC_ALL="en_US.UTF-8";

  doCheck = false;
  # Skip test_feature_importance_regression - does web fetch
  checkPhase = ''
    cd $TMPDIR
    HOME=$TMPDIR OMP_NUM_THREADS=1 pytest -k "not test_feature_importance_regression" --pyargs sklearn
  '';
  meta = with stdenv.lib; {
    description = "A set of python modules for machine learning and data mining";
    homepage = "https://scikit-learn.org";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
