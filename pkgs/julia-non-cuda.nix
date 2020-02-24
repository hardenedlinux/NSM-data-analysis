{ pkgs ? import (builtins.fetchTarball "https://github.com/nixos/nixpkgs/tarball/f4c40e65d13052c8ca63684dc830e0282ced9d4b"){}
}:
let
  #issue https://github.com/NixOS/nixpkgs/pull/79174#issuecomment-590566953
  julia = pkgs.julia_13.overrideAttrs(oldAttrs: {checkTarget = "";});
  d = version: "v${pkgs.lib.concatStringsSep "." (pkgs.lib.take 2 (pkgs.lib.splitString "." version))}";
  extraLibs = with pkgs;[
    # IJulia.jl
    mbedtls
    zeromq3
    # ImageMagick.jl
    imagemagickBig
    # HDF5.jl
    hdf5
    # Cairo.jl
    cairo
    gettext
    pango.out
    glib.out
    # Gtk.jl
    gtk3
    gdk_pixbuf
    # GZip.jl # Required by DataFrames.jl
    gzip
    zlib
    # GR.jl # Runs even without Xrender and Xext, but cannot save files, so those are required
    xorg.libXt
    xorg.libX11
    xorg.libXrender
    xorg.libXext
    glfw
    freetype
    # Flux.jl
    git gitRepo gnupg autoconf curl
    procps gnumake utillinux m4 gperf unzip
    #libGLU_combined
    xorg.libXi xorg.libXmu freeglut
    xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
    ncurses5 stdenv.cc binutils
    # Arpack.jl
    arpack
    gfortran.cc
  ];
in
pkgs.stdenv.mkDerivation rec {
  name = "julia-env";
  version = julia.version;
  nativeBuildInputs = [ pkgs.makeWrapper pkgs.cacert pkgs.git pkgs.pkgconfig pkgs.which ];
  buildInputs = [
    julia
    /* jupyterEnv  # my custom jupyter */
  ] ++ extraLibs;
  phases = [ "installPhase" ];
  installPhase = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath extraLibs}
    # pushd $JULIA_PKGDIR/${d version}
    makeWrapper ${julia}/bin/julia $out/bin/julia \
        --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
        	--set JULIA_PKGDIR $JULIA_PKGDIR
        # --set JULIA_LOAD_PATH $JULIA_PKGDIR/${d version}
  '';
}
