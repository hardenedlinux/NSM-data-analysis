final: prev:
{
  choochoo-requirements = final.machlib.mkPython rec {
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
}
