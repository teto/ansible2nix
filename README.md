# ansible2nix

This tool converts a requirements.yml such as:
```
collections:
- name: community.kubernetes
  version: 1.1.1
- name: amazon.aws
  version: 1.4.1
```
into a nix expression.


# Usage

`ansible2nix <REQUIREMENTS_YAML>`

Example:
```
ansible2nix requirements.yml > requirements.nix

nix-build -A 
```
add to your derivation:
```
ANSIBLE_COLLECTIONS_PATH = ansibleGenerateCollection pkgs.ansible (import ./requirements.nix);
```
