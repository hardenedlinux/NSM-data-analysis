{ stdenv
, python3Packages
, fetchgit
, python-whois
, python3
}:

python3Packages.buildPythonPackage rec {

  pname = "clx";
  version = "0.2.0";
  src = fetchgit {
    url = "https://github.com/rapidsai/clx";
    rev = "6cbe4830ac2a5f151445df1f33404d1949716bfd";
    sha256 = "0mnh57p4jc9bjczbkyqqzfy4mpzdqz1ypmam2lyh61p0xrgqrvsr";
  };

  nativeBuildInputs = [ python3.pkgs.pytest  ];
  propagatedBuildInputs = with python3Packages; [    confluent-kafka
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
  meta = with stdenv.lib; {
    description = "A collection of RAPIDS examples for security analysts, data scientists, and engineers to quickly get started applying RAPIDS and GPU acceleration to real-world cybersecurity use cases.
";
    homepage = "https://github.com/rapidsai/clx";
    license = licenses.asl20;
    maintainers = with maintainers; [ gtrunsec ];
  };

}
