# -*- coding: utf-8 -*-
from setuptools import setup

packages = \
['ansible2nix']

package_data = \
{'': ['*']}

install_requires = \
['PyYAML>=6.0,<7.0']

entry_points = \
{'console_scripts': ['ansible2nix = ansible2nix.ansible2nix:main']}

setup_kwargs = {
    'name': 'ansible2nix',
    'version': '0.1.0',
    'description': 'convert requirements.yml into a nix expression',
    'long_description': None,
    'author': 'Matthieu Coudron',
    'author_email': 'mcoudron@hotmail.com',
    'maintainer': None,
    'maintainer_email': None,
    'url': None,
    'packages': packages,
    'package_data': package_data,
    'install_requires': install_requires,
    'entry_points': entry_points,
    'python_requires': '>=3.8,<4.0',
}


setup(**setup_kwargs)
