{ buildPythonApplication, pyyaml }:
let
  content = builtins.readFile ./ansible2nix.sh {};
in
  writeShellScriptBin "ansible2nix" content
  buildPythonApplication {
    name = "ansible2nix";
    version = "0.1";
    buildInputs = [ pyyaml
    ];



  };

