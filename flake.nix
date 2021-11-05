{
  description = "Converts ansible requirements.yml into nix expression";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-compat = {
      url = "github:teto/flake-compat/support-packages";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };

    in {
      packages = {
        ansible2nix = pkgs.ansible2nix;
        test = pkgs.callPackage ./tests/test.nix {};
      };

      defaultPackage = self.packages.${system}.ansible2nix;

      devShell = self.defaultPackage.${system}.overrideAttrs(oa: {
        postShellHook = ''
          export PYTHONPATH="$PWD:$PYTHONPATH"
        '';
      });
    }) // {

    overlay = final: prev: {
      ansible2nix = final.poetry2nix.mkPoetryApplication {
        projectDir = ./.;
        buildInputs = [ ];
      };

      # ansibleLib = {
        ansibleGenerateCollection = final.callPackage ./ansible.nix {};

        # getGalaxyUrl = "https://galaxy.ansible.com/download/${name}-${version}.tar.gz";
      # };

    };
  };
}
