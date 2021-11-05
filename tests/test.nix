{ stdenv, ansibleGenerateCollection, python3 }:

let
  ansibleCollections = import ./requirements.nix;
  myPythonEnv = python3.withPackages(p: with p;[
      boto3
      # psycopg2
      ansible
      # ansible-lint  # broken on unstable
  ]);
in
stdenv.mkDerivation {

  name = "gitops-platform";
  ANSIBLE_COLLECTIONS_PATH = ansibleCollections;

  buildInputs = [
    myPythonEnv
  ];

  # shellHook = ''
  #   source <(novops handler)
  # '';
}
