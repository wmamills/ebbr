#!/bin/bash

cd $(dirname $0)

. /etc/os-release
cat /etc/os-release
TYPE=${ID_LIKE:-$ID}
VERSION_MAJOR=${VERSION_ID%%.*}
if [ $ID == "debian" -a $VERSION_MAJOR -lt 10 ]; then
        TYPE=old-debian
elif [ $ID == "ubuntu" -a $VERSION_MAJOR -lt 18 ]; then
        TYPE=old-debian
fi

echo setup type is $TYPE

case $TYPE in
*debian)
        apt-get update
        apt-get install -y make git
        apt-get install -y python3-sphinx texlive texlive-latex-extra libalgorithm-diff-perl \
                texlive-humanities latexmk
        ;;
fedora)
        dnf install -y make git
        dnf install -y python3-sphinx texlive texlive-capt-of texlive-draftwatermark \
              texlive-fncychap texlive-framed texlive-needspace \
              texlive-tabulary texlive-titlesec texlive-upquote \
              texlive-wrapfig texinfo latexmk
        ;;
esac

case $TYPE in
old-debian)
	apt-get install -y texlive-generic-recommended texlive-generic-extra
        apt-get install -y python3-pip
        pip3 install --user --upgrade Sphinx
        export SPHINXBUILD=~/.local/bin/sphinx-build
	;;
esac

if [ -d ./build/doctrees ]; then 
        rm -rf ./build; 
fi
make -e html
make -e singlehtml
make -e latexpdf
