#!/bin/bash

set -ex

LIBRARYTOBUILD=$1
FORCECOMPILER=$2

FORCECOMPILERPARAM=""
if [ "$FORCECOMPILER" != "all" ]; then
  FORCECOMPILERPARAM="--buildfor=$FORCECOMPILER"
fi

LIBRARYPARAM="libraries/c++"
if [ "$LIBRARYTOBUILD" != "all" ]; then
  LIBRARYPARAM="libraries/c++/$LIBRARYTOBUILD"
fi

ROOT=$(pwd)
PATH=$PATH:/opt/compiler-explorer/cmake/bin

cd /tmp/build
git clone https://github.com/compiler-explorer/infra

cd /tmp/build/infra
cp /tmp/build/infra/init/settings.yml /root/.conan/settings.yml
make ce > ceinstall.log

conan user ce -p -r=ceserver
bin/ce_install --staging=/tmp/staging --debug --enable=nightly $FORCECOMPILERPARAM build "$LIBRARYPARAM"
