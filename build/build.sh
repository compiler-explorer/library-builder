#!/bin/bash

set -ex

ROOT=$(pwd)
PATH=$PATH:/opt/compiler-explorer/cmake/bin

cd /tmp/build
git clone -b librarybuilding https://github.com/compiler-explorer/infra

cd /tmp/build/infra
cp /tmp/build/infra/init/settings.yml /root/.conan/settings.yml
make ce > ceinstall.log

#conan user ce -p -r=ceserver
bin/ce_install --enable=nightly --staging=/tmp/staging build libraries/c++/nightly
