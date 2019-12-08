{stdenv, fetchgit, cmake, pandoc, gcc, caf, pkgconfig, arrow-cpp, openssl, doxygen, libpcap, gperftools}:


stdenv.mkDerivation rec {
    version = "0.2";
    name = "vast";
    src = fetchgit {
      url = "https://github.com/tenzir/vast.git";
      rev = "a4c6be45c12e4108dff96484ac66b6776581b0da";
      deepClone = true;
      sha256 = "0z170iv6hpkpcfrfiax91f42i9sdcph9szpf7i0dvgbixidrzhzx";
  };

  nativeBuildInputs = [ cmake pkgconfig openssl arrow-cpp];
  buildInputs = [ cmake gcc caf arrow-cpp openssl doxygen libpcap pandoc
                  gperftools];


  preConfigure = ''
  cmakeFlags="$cmakeFlags -DCAF_ROOT_DIR=${caf}
                          -DCAF_LIBRARY_OPENSSL=${openssl}
  "
'';

      postInstall = ''

  '';
   configureFlags = [

   ];
  enableParallelBuilding = true;

  
  meta = with stdenv.lib; {
    description = " Visibility Across Space and Time";
    homepage = http://vast.io;
    license = licenses.bsd3;
    maintainers = with maintainers; [ GTrunSec ];
    platforms = with platforms; linux;
  };
}
