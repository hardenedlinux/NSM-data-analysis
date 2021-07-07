{ stdenv
, lib
, python3Packages
, nixpkgs-hardenedlinux-sources
}:

python3Packages.buildPythonPackage rec {

  inherit (nixpkgs-hardenedlinux-sources.clx) pname version src;

  nativeBuildInputs = with python3Packages; [ pytest ];

  propagatedBuildInputs = with python3Packages; [
    confluent-kafka
    cython
    transformers
    requests
    mockito
    python-whois
  ];
  doCheck = false;

  postPatch = ''
    cd python
    pytest
  '';
  meta = with lib; {
    description = "A collection of RAPIDS examples for security analysts, data scientists, and engineers to quickly get started applying RAPIDS and GPU acceleration to real-world cybersecurity use cases.
";
    homepage = "https://github.com/rapidsai/clx";
    license = licenses.asl20;

  };

}
