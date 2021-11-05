.PHONY: setup.py
setup.py:
	poetry build -v --format sdist && tar --wildcards -xvf dist/*.tar.gz -O '*/setup.py' > setup.py

