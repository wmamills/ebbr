# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SPHINXPROJ    = EBBR
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

# build all the ones we use and combine them in one dir
# (for deploy to gh-pages etc)
all: html singlehtml latexpdf
	mkdir build/all
	cp -a build/html build/all
	cp -a build/singlehtml build/all/singlehtml
	cp -a build/latex/ebbr.pdf build/all/
	cp scripts/deploy_index.html build/all/index.html
	touch build/all/.nojekyll

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) --version
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
