{ nixpkgs }:
''
  if [ $# -eq 0 ]
    then
      echo "Usage: generate-directory [EXTENSION]"
    else
      DIRECTORY="./jupyterlab"
      echo "Generating directory '$DIRECTORY' with extensions:"

      # we need to copy yarn.lock manually to the staging directory to get
      # write access this seems to be a bug in jupyterlab that doesn't
      # consider that it comes from a folder without read access only as in
      # Nix
      mkdir -p "$DIRECTORY"/staging
      cp ${nixpkgs.python3Packages.jupyterlab}/lib/python3.7/site-packages/jupyterlab/staging/yarn.lock "$DIRECTORY"/staging
      chmod +w "$DIRECTORY"/staging/yarn.lock

      for EXT in "$@"; do echo "- $EXT"; done
      ${nixpkgs.python3Packages.jupyterlab}/bin/jupyter-labextension install "$@" --app-dir="$DIRECTORY" --generate-config
      chmod -R +w "$DIRECTORY"/*
  fi
''
