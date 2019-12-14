{ mkDerivation, base, fetchFromGitHub, hmatrix, mtl, random-fu, stdenv }:
mkDerivation {
  pname = "random-fu-multivariate";
  version = "0.1.2.1";
  src = fetchFromGitHub {
    owner = "idontgetoutmuch";
    repo = "random-fu-multivariate";
    rev = "c28715921b42e9631c5b72b8716b330e89edd145";
    sha256 = "0mxiwhfjyjrfy9x76flmgjjr9y52vlm2k25zqf4m6gwsf3m5dz07";
  };
  libraryHaskellDepends = [ base hmatrix mtl random-fu ];
  testHaskellDepends = [ base ];
  homepage = "https://github.com/idontgetoutmuch/random-fu-multivariate";
  description = "Multivariate distributions for random-fu";
  license = stdenv.lib.licenses.bsd3;
}
