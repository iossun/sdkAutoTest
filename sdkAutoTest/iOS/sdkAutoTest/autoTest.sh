#!/bin/bash

set -ex

MM_HOME=$(cd $(dirname $0); pwd)
BUILD_DIR=${MM_HOME}/release_ios

cd ${MM_HOME}

[[ -d ${BUILD_DIR} ]] && rm -r ${BUILD_DIR}

BUILD_ARCHS="arm64" #armv7 armv7s x86_64
LIBS=""
IOS_TOOLCHAIN=${MM_HOME}/ios.toolchain.cmake
for arch in ${BUILD_ARCHS}; do
    mkdir -p ${BUILD_DIR}/${arch}
    pushd ${BUILD_DIR}/${arch}

    # enable bit code
    cmake ${MM_HOME} \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_TOOLCHAIN_FILE=${IOS_TOOLCHAIN} \
        -DCMAKE_OSX_ARCHITECTURES=${arch} \
        -DIOS=1 \
        -DENABLE_BITCODE=1 \
        -DIOS_DEPLOYMENT_TARGET=9.0 \
        -DMMFACE_BUILD_SHARED_LIB=OFF
    make -j$(nproc) PixelFree
    popd
    LIBS="${LIBS} ${BUILD_DIR}/${arch}/libPixelFree.a"
#    INTERFACE_LIBS="${INTERFACE_LIBS} ${BUILD_DIR}/${arch}/libfuai_interface.a"
done

[[ -d ${BUILD_DIR}/lib ]] || mkdir ${BUILD_DIR}/lib
lipo ${LIBS} -create -output ${BUILD_DIR}/lib/PixelFree.a
cp ${MM_HOME}/DetectFace/third_party/tensorflow/out/ios/libtensorflow-lite.a ${BUILD_DIR}/lib
cp ${MM_HOME}/DetectFace/third_party/ceres-solver/out/ios/libceres.a ${BUILD_DIR}/lib
libtool -static -o ${BUILD_DIR}/PixelFree.a ${BUILD_DIR}/lib/*.a

[[ -d ${BUILD_DIR}/Include ]] || mkdir ${BUILD_DIR}/Include
cp ${MM_HOME}/PixelFree/Include/SMPixelFree.h ${BUILD_DIR}/Include/SMPixelFree.h
cp ${MM_HOME}/PixelFree/Include/pixelFree_c.hpp ${BUILD_DIR}/Include/pixelFree_c.hpp
