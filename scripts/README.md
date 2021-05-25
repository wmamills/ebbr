# scripts/setup.sh

The `scripts/setup.sh` file if for automated setup of a container or other bare build host.  It always takes one argument as follows:

- `scripts/setup.sh admin_setup`

    do all project setup that require root privilege

- `scripts/setup.sh prj_setup`

    do all project setup for this user (does not include admin_setup)

- `scripts/setup.sh prj_build`

    do the default project build steps

- `scripts/setup.sh all_setup`

    do admin_setup via sudo and then prj_setup

- `scripts/setup.sh all`

    do all_setup and then prj_build

The scripts/setup.sh file is used in the CI configuration.

You may also use it on your own machine to build in a container.

```
$ docker -v
Docker version _blah_._blah_._blah_
$ pwd
/home/joeuser/somewhere/ebbr
$ git clone https://github.com/wmamills/dockit.git ../dockit
$ ../dockit/dockit --distro fedora:34
$ ../dockit/dockit --distro ubuntu:18.04
$ ../dockit/dockit --distro debian:10
$ ../dockit/dockit
```

The above commands do the `all` target on the specified distro and version.  If no distro is specified the default is `ubuntu:20.04`.

If you are brave, you could also use this to setup your own machine for this project.

./script/setup.sh all_setup

It will use sudo so may prompt for a password.
