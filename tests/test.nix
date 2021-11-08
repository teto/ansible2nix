{ stdenv, ansibleGenerateCollection, python3, ansible }:

let
  ansibleCollections = ansibleGenerateCollection ansible (import ./requirements.nix);

  myPythonEnv = python3.withPackages(p: with p;[
      boto3
      # psycopg2
      ansible
      # ansible-lint  # broken on unstable
  ]);
in
stdenv.mkDerivation {

  name = "test";
  ANSIBLE_COLLECTIONS_PATH = ansibleCollections;

  src = ./.;

  buildPhase = ":";
  installPhase = ''
    touch $out
  '';

  propagatedBuildInputs = [
    myPythonEnv
  ];

  # shellHook = ''
  #   source <(novops handler)
  # '';
}
