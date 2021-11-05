{ stdenv, lib, pkgs }:
ansible: collections:

/* Install ansible collections
 *
 * Collections are downloaded, then each collection is installed with:
 * $ ansible-galaxy collection install <collection.tar.gz>.
 *
 * The resulting derivation is the ansible collections path.
 *
 * Example:
 *
 * Native collections are https://github.com/ansible-collections
 *
 * ANSIBLE_COLLECTIONS_PATH = callPackage ./ansible-collections.nix {} ansible_2_10 {
 *   "community-postgresql" = {
 *     version = "1.4.0";
 *     sha256 = "14izkq5knrch2xv4jx7jvxnq2lwhhdlyck7i7ga9mny3skrz9qfp";
 *   };
 * };
 */

let

  installCollections =
    lib.concatStringsSep "\n" (lib.mapAttrsToList installCollection collections);

  installCollection = name: versionAndSha256:
    "${ansible}/bin/ansible-galaxy collection install ${collection name versionAndSha256}/collection.tar.gz";

  # fetches
  # sur https://github.com/ansible-collections
  # le 'name' du module contient un "."; "community.postgresql"
  # pour les tarballs apparemment c'est le tiret
  collection = name: { version, sha256 ? null }:
    stdenv.mkDerivation {
      pname = name;
      version = version;

      # builtins.fetchGit is disabled in restricted eval
      # so one needs to use --impure
      # src = builtins.fetchGit {
      #   # https://github.com/ansible-collections
      #   url = "https://github.com/ansible-collections/${name}.git";
      #   ref = "refs/tags/${version}";
      # };

      src = builtins.fetchurl {
        name = name;
        url = "https://galaxy.ansible.com/download/${name}-${version}.tar.gz";

        # sha256 = sha256;
      };

      phases = [ "installPhase" ];

      installPhase = ''
        mkdir -p $out
        cp -r $src $out/collection.tar.gz
      '';
    };

in
pkgs.runCommand "ansible-collections" {} ''
  mkdir -p $out
  export HOME=./
  export ANSIBLE_COLLECTIONS_PATH=$out
  ${installCollections}
''

