{ stdenv
, fetchurl
, gnome3
, libdrm
, glib
, gtk3
, cairo
, atk
, gdk-pixbuf
, at-spi2-atk
, dbus
, dconf
, xorg
, nss
, nspr
, alsaLib
, cups
, fontconfig
, expat
, lib
, mesa
, wrapGAppsHook
, autoPatchelfHook
, makeWrapper
, dpkg
, libudev0-shim
, glibc
, nixpkgs-hardenedlinux-sources
}:
stdenv.mkDerivation rec {
  inherit (nixpkgs-hardenedlinux-sources.brim) pname version src;

  buildInputs = [
    gnome3.gsettings_desktop_schemas
    libdrm
    mesa
    glib
    gtk3
    cairo
    atk
    gdk-pixbuf
    at-spi2-atk
    dbus
    dconf
    xorg.libX11
    xorg.libxcb
    xorg.libXi
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXrandr
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    xorg.libXrender
    xorg.libXtst
    xorg.libXScrnSaver
    nss
    nspr
    alsaLib
    cups
    fontconfig
    expat
  ];

  nativeBuildInputs = [
    wrapGAppsHook
    autoPatchelfHook
    makeWrapper
    dpkg
  ];


  runtimeLibs = lib.makeLibraryPath [ libudev0-shim glibc ];

  unpackPhase = "dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/brim
    mkdir -p $out/bin
    mkdir -p $out/lib

    mv usr/lib/brim/* $out/share/brim
    mv $out/share/brim/*.so $out/lib/
    mv usr/share/* $out/share/
    ln -s $out/share/brim/Brim $out/bin/brim

    substituteInPlace $out/share/applications/brim.desktop  \
      --replace "brim %U" "$out/bin/brim $U"

    runHook preInstall
  '';

  preFixup = ''
    gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : "${runtimeLibs}" )
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Desktop application to efficiently search large packet captures and Zeek logs.";
    homepage = "https://github.com/brimdata/brim";
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}
