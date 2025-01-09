#!/bin/bash

set -ex

LANGUAGE=$1
LIBRARYTOBUILD=$2
FORCECOMPILER=$3

FORCECOMPILERPARAM=""
if [ "$FORCECOMPILER" = "popular-compilers-only" ]; then
  FORCECOMPILERPARAM="--popular-compilers-only"
elif [ "$FORCECOMPILER" != "all" ]; then
  FORCECOMPILERPARAM="--buildfor=$FORCECOMPILER"
fi

LIBRARYPARAM="libraries/$1"
if [ "$LIBRARYTOBUILD" != "all" ]; then
  LIBRARYPARAM="libraries/$1/$LIBRARYTOBUILD"
fi

PATH=$PATH:/opt/compiler-explorer/cmake/bin

cd /tmp/build
git clone https://github.com/compiler-explorer/infra

cd /tmp/build/infra

CONAN_HOME=$(conan config home)
cp /tmp/build/infra/init/settings.yml $CONAN_HOME/settings.yml
make ce > ceinstall.log

conan user ce -p -r=ceserver
bin/ce_install --staging-dir=/tmp/staging --enable=nightly build "$FORCECOMPILERPARAM" "$LIBRARYPARAM"
