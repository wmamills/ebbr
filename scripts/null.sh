#!/bin/bash

sudo_it() {
        sudo ./$ME admin_setup  && prj_setup && prj_build
}

admin_setup() {
        apt update
        apt install -y sudo
        addgroup $MY_USER sudo_np
        echo "stopping at admin_setup"
        /bin/bash
}

prj_setup() {
        echo "stopping at prj_setup"
        /bin/bash
}

prj_build() {
        echo "stopping at prj_build"
        /bin/bash
}

$1