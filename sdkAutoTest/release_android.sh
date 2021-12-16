#!/bin/bash

set -ex

if [[ -z ${NDK_ROOT} ]]; then
    NDK_ROOT=/Users/sunmu/Library/Android/sdk/ndk/21.0.6113669
fi

MM_HOME=$(cd $(dirname $0); pwd)
BUILD_DIR=${MM_HOME}/release_android

[[ -d ${BUILD_DIR} ]] && rm -r ${BUILD_DIR}

build() {
    arch=$1
    NDK_API_LEVEL=$2
    mkdir -p ${BUILD_DIR}/${arch}
    pushd ${BUILD_DIR}/${arch}
    cmake ${MM_HOME} \
        -G "Unix Makefiles" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE=${NDK_ROOT}/build/cmake/android.toolchain.cmake \
        -DANDROID_TOOLCHAIN=clang \
        -DANDROID_ABI=${arch} \
        -DANDROID_NATIVE_API_LEVEL=${NDK_API_LEVEL} \
        -DANDROID_STL=c++_static \
        -DPIXELFREE_BUILD_SHARED_LIB=ON
    make -j$(nproc) sdkTest
    popd
}

# build arm64-v8a 21
# build armeabi-v7a 18
build x86_64 21
# build x86 18
