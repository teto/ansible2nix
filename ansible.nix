{ stdenv, lib, pkgs }:
ansible: collections:

/* Install ansible collections
 *
 * Collections are downloaded, then each collection is installed with:
 * $ ansible-galaxy collection install <collection.tar.gz>.
 *
 * The resulting derivation is the ansible collections path.
 * Example:
 *
 * Native collections are https://github.com/ansible-collections
 *
 * ANSIBLE_COLLECTIONS_PATH = callPackage ./ansible-collections.nix {} ansible_2_10 (./import requirements.nix {});
 * };
 */

let


  installCollections =
    lib.concatStringsSep "\n" (map installCollection collections);

  installCollection = tarball:
    "${ansible}/bin/ansible-galaxy collection install ${toString tarball}";
in
pkgs.runCommandNoCC "ansible-collections" {} ''
  mkdir -p $out
  export HOME=./
  export ANSIBLE_COLLECTIONS_PATH=$out
  ${installCollections}
''

