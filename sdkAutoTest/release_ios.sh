!/bin/bash

set -ex

MM_HOME=$(cd $(dirname $0); pwd)
BUILD_DIR=${MM_HOME}/release_ios

cd ${MM_HOME}

[[ -d ${BUILD_DIR} ]] && rm -r ${BUILD_DIR}

BUILD_ARCHS="x86_64" #armv7 armv7s x86_64
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
    make -j$(nproc) sdkTest
    popd
    LIBS="${LIBS} ${BUILD_DIR}/${arch}/sdkTest.a"
#    INTERFACE_LIBS="${INTERFACE_LIBS} ${BUILD_DIR}/${arch}/libfuai_interface.a"
done

# [[ -d ${BUILD_DIR}/lib ]] || mkdir ${BUILD_DIR}/lib
# lipo ${LIBS} -create -output ${BUILD_DIR}/lib/sdkTest.a
# libtool -static -o ${BUILD_DIR}/sdkTest.a ${BUILD_DIR}/lib/*.a

#cp ./release_ios/x86_64/libsdkTest.a  ./iOS/sdkAutoTest/sdkAutoTest/Lib
#cd ./iOS/sdkAutoTest/ci/
#sh ./runUnitTest.sh



