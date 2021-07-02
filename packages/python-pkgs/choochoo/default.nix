{ lib
, python3Packages
, nixpkgs-hardenedlinux-sources
, machlib
}:
let
  choochoo-requirements = machlib.mkPython rec {
    requirements = ''
      bokeh
      cachetools
      colorama
      colorlog
      geoalchemy2
      jupyterlab
      matplotlib
      openpyxl
      pandas
      pendulum
      psutil
      psycopg2
      pyGeoTile
      pyproj
      rasterio
      requests
      scipy
      sklearn
      sqlalchemy-utils
      sqlalchemy
      uritools
      werkzeug
    '';
  };
in
python3Packages.buildPythonPackage rec {
  inherit (nixpkgs-hardenedlinux-sources.choochoo) pname version src;
  preConfigure = ''
    cd py
  '';

  propagatedBuildInputs = with python3Packages; [
    choochoo-requirements
    (shapely.overridePythonAttrs (oldAttrs: { propagatedBuildInputs = [ ]; }))
  ];

  postPatch = ''
    substituteInPlace py/setup.py \
    --replace "jupyter" "jupyterlab"
  '';

  doCheck = false;

  meta = with lib; {
    description = "Data Science for Training'";
    homepage = "https://github.com/andrewcooke/choochoo";
    license = licenses.asl20;
  };

}
