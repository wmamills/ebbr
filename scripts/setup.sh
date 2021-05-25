#!/bin/bash
# scripts/setup.sh for EBBR spec
# automatic machine/container/VM setup for building this project

set -xe

cd $(dirname $0)/..
ME=$0

first_word() {
        echo $1
}

get_distro_type() {
        . /etc/os-release
        cat /etc/os-release
        TYPE=${ID_LIKE:-$ID}
        TYPE=$(first_word $TYPE)
        VERSION_MAJOR=${VERSION_ID%%.*}
        if   [ "$ID" = "debian" -a $VERSION_MAJOR -lt 10 ]; then
                TYPE=old-debian
        elif [ "$ID" = "ubuntu" -a $VERSION_MAJOR -lt 18 ]; then
                TYPE=old-debian
        fi

        echo distro type is $TYPE
}

debian_common() {
        apt-get update

        # install things people assume come with any builder but are not in
        # minimal conatiners
        apt-get install -y make git

        # install doc dependecies common to new and old debian/ubuntu
        apt-get install -y \
                latexmk \
                libalgorithm-diff-perl \
                texlive \
                texlive-latex-extra \
                texlive-humanities
}

rh_common() {
        $PKG install -y make git
        $PKG install -y python3-sphinx texlive texlive-capt-of texlive-draftwatermark \
                texlive-fncychap texlive-framed texlive-needspace \
                texlive-tabulary texlive-titlesec texlive-upquote \
                texlive-wrapfig texinfo latexmk
}

# project specfic setup done w/ root
do_admin_setup() {
        get_distro_type

        case $TYPE in
        debian)
                debian_common
                apt-get install -y texlive-plain-generic python3-sphinx
                ;;
        # this was tested with debian 9 and ubuntu 14.04 and 16.04
        old-debian)
                debian_common
                apt-get install -y texlive-generic-recommended texlive-generic-extra
                apt-get install -y python3-pip
                ;;
        # below tested for fedora:34
        fedora)
                PKG=dnf
                rh_common
                ;;
        # below was tested for centos:7 and 8, no rhel tests done
        rhel)
                PKG=yum
                rh_common
                ;;
        *)
                echo "Don't know how to handle distro $TYPE"
                exit 2
        esac
}

# project specific setup, user context
do_prj_setup() {
        get_distro_type
        case $TYPE in
        old-debian)
                pip3 install --user --upgrade mako
                pip3 install --user --upgrade typing
                pip3 install --user --upgrade Sphinx==2.4.4
                export SPHINXBUILD=~/.local/bin/sphinx-build
                ;;
        esac
}

# project specific build, user context
do_prj_build() {
        if [ ! -d ./.git ]; then 
                echo ".git directory NOT PRESENT!!!!"
        fi
        if [ -d ./build/doctrees ]; then
                rm -rf ./build;
        fi
        make -e all
}

# all in one go for machines with password less sudo or very trusting users
do_all_setup() {
        sudo $ME admin_setup && prj_setup
}

# all setup and default build
do_all() {
        do_all_setup && prj_build
}

# be a _little_ helpful
case $1 in
admin_setup|prj_setup|prj_build|all|all_setup)
        do_$1
        ;;
sudo_it)
        # alias to support old command API
        do_all
        ;;
*)
        echo "Must supply a sub command: "
        echo "    admin_setup, prj_setup, prj_build, all_setup, or all"
        exit 2
        ;;
esac
