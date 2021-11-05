import logging
import subprocess
import yaml
import argparse
from typing import List
import sys

log = logging.getLogger()
log.addHandler(logging.StreamHandler())

__version__ = "0.1"

LOG_LEVELS = {
    logging.getLevelName(level): level for level in [
        logging.DEBUG, logging.INFO, logging.ERROR
    ]
}

def gen_galaxy_url(name, version):
    nname = name.replace(".", "-")
    return f"https://galaxy.ansible.com/download/{nname}-{version}.tar.gz"



def gen_nix_expression(collection):
    log.debug("Generating nix code")
    name = collection['name']
    version = collection['version']
    tarball_url = gen_galaxy_url(name, version)
    cmd = ["nix-prefetch-url", tarball_url]


    out = subprocess.check_output(cmd)
    log.debug(out)
    sha = out.decode().strip()

    content = '''
        (fetchurl {{
            url = "{tarball_url}";
            sha256 = "{checksum}";
        }})
    '''.format(tarball_url=tarball_url, checksum=sha)
    return content


# def gen_nix_derivation(ansible_drv):
#     content = """
#     { ansibleGenerateCollection, {ansible} }:
#     """.format(ansible=ansible_drv,)
#     pass

def main(arguments: List[str] = None):
    if not arguments:
        arguments = sys.argv[1:]

    parser = argparse.ArgumentParser(
        description='Generate MPTCP (Multipath Transmission Control Protocol) stats & plots',
        epilog="You can report issues at https://github.com/teto/mptcpanalyzer",
    )

    parser.add_argument(
        "requirements",
        help="Path towards the 'requirements.yml'"
    )
    # parser.add_argument('ansible_drv', action='store', default="ansible")
    parser.add_argument('--version', action='version', version=str(__version__))
    parser.add_argument(
        "--debug", "-d", choices=LOG_LEVELS.keys(),
        default=logging.getLevelName(logging.ERROR),
        help="More verbose output, can be repeated to be even more "
        " verbose such as '-dddd'"
    )

    args = parser.parse_args(arguments)

    log.setLevel(LOG_LEVELS[args.debug])

    with open(args.requirements) as fd:
        content = yaml.safe_load(fd)

        nix_derivations = []
        for collection in content['collections']:
            nix_derivations.append(gen_nix_expression(collection))

        # for collection in collections:

        output = "[" + " ".join(nix_derivations) + "]"
        print(output)





if __name__ == '__main__':
    main()

