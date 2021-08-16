#!/bin/bash

mkdir -p _build
pushd _build

# link librt to get clock_gettime on older glibc versions
if [ "$(uname)" == "Linux" ]; then
	export LDFLAGS="-lrt ${LDFLAGS}"
fi

# configure
cmake \
	${SRC_DIR} \
	${CMAKE_ARGS} \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=true \
;

# build
cmake --build . --parallel ${CPU_COUNT} --verbose

# test
ctest --parallel ${CPU_COUNT} --verbose

# install
cmake --build . --parallel ${CPU_COUNT} --verbose --target install
