#!/bin/sh

#  Automatic build script for libssl and libcrypto
#  for iPhoneOS and iPhoneSimulator
#
#  Created by Felix Schulze on 16.12.10.
#  Copyright 2010-2015 Felix Schulze. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################
#  Change values here                                                     #
#                                                                         #
VERSION="4.22"                                                          #
IOS_SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`                   #
CONFIG_OPTIONS=""                                                         #
CURL_OPTIONS=""                                                           #
#                                                                         #
###########################################################################
#                                                                         #
# Don't change anything under this line!                                  #
#                                                                         #
###########################################################################
spinner()
{
  local pid=$!
  local delay=0.75
  local spinstr='|/-\'
  while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
    local temp=${spinstr#?}
    printf " [%c]  " "$spinstr"
    local spinstr=$temp${spinstr%"$temp"}
    sleep $delay
    printf "\b\b\b\b\b\b"
  done
  printf "    \b\b\b\b"
}
if [ ! -e "src" ] 
then
git clone https://github.com/shadowsocks/libev.git -b master --single-branch --depth 1 src
fi
CURRENTPATH=`pwd`
ARCHS="i386 x86_64 armv7 armv7s arm64"
DEVELOPER=`xcode-select -print-path`
PLATFORMPATH="/Applications/Xcode.app/Contents/Developer/Platforms"
IOS_MIN_SDK_VERSION="6.0"
MACOS_MIN_SDK_VERSION="10.9"

SRC_DIR_NAME=libev-${VERSION}
SRC_DIR="${CURRENTPATH}/src"
mkdir -p lib
mkdir -p include
for ARCH in ${ARCHS}
do
  if [[ "$ARCH" == tv* ]]; then
    SDKVERSION=$TVOS_SDKVERSION
    MIN_SDK_VERSION=$TVOS_MIN_SDK_VERSION
  else
    SDKVERSION=$IOS_SDKVERSION
    MIN_SDK_VERSION=$IOS_MIN_SDK_VERSION
  fi
  MIN_VERSION=""
  if [[ "${ARCH}" == "i386" || "${ARCH}" == "x86_64" ]]; then
    PLATFORM="iPhoneSimulator"
  elif [ "${ARCH}" == "tv_x86_64" ]; then
    ARCH="x86_64"
    PLATFORM="AppleTVSimulator"
    MIN_VERSION="-mtvos-version-min=${MIN_SDK_VERSION}"
  elif [ "${ARCH}" == "tv_arm64" ]; then
    ARCH="arm64"
    PLATFORM="AppleTVOS"
    MIN_VERSION="-mtvos-version-min=${MIN_SDK_VERSION}"
  else
    PLATFORM="iPhoneOS"
    MIN_VERSION="-miphoneos-version-min=${MIN_SDK_VERSION}"
  fi
  export $PLATFORM
  export CROSS_TOP="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
  export CROSS_SDK="${PLATFORM}${SDKVERSION}.sdk"
  export BUILD_TOOLS="${DEVELOPER}"
  OUTPUT_PATH=${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk
  mkdir -p $OUTPUT_PATH
  LOG="${CURRENTPATH}/bin/${PLATFORM}${SDKVERSION}-${ARCH}.sdk/build-libev-${VERSION}.log"
  echo "Building libev-${VERSION} for ${PLATFORM} ${SDKVERSION} ${ARCH}"
  echo "  Logfile: $LOG"
  LOCAL_CONFIG_OPTIONS="${CONFIG_OPTIONS}"
  export CC="$(xcrun -sdk iphoneos -find clang)"
  export CPP="$CC -E"
  export CFLAGS="-arch ${ARCH} -isysroot $PLATFORMPATH/$PLATFORM.platform/Developer/SDKs/$PLATFORM$SDKVERSION.sdk ${MIN_VERSION}"
  export AR=$(xcrun -sdk iphoneos -find ar)
  export RANLIB=$(xcrun -sdk iphoneos -find ranlib)
  export CPPFLAGS="-arch ${ARCH} -isysroot $PLATFORMPATH/$PLATFORM.platform/Developer/SDKs/$PLATFORM$SDKVERSION.sdk ${MIN_VERSION}"
  export LDFLAGS="-arch ${ARCH} -isysroot $PLATFORMPATH/$PLATFORM.platform/Developer/SDKs/$PLATFORM$SDKVERSION.sdk"
  cd $SRC_DIR
  HOST=$ARCH
  if [[ $HOST == "arm64" ]]; then
    HOST="arm"
  elif [ "${ARCH}" == "tv_arm64" ]; then
    HOST="arm"
  fi
  OTHER_FLAGS=""
  if [[ "${ARCH}" == "tv_arm64" || "${ARCH}" == "tv_x86_64" ]]; then
    OTHER_FLAGS="--with-platform=tvos"
  fi
  echo "  Configure...\c $"
  set -e
  (./configure --host=$HOST-apple-darwin $OTHER_FLAGS> "${LOG}" 2>&1) & spinner
  echo "  Make...\c"
  make clean
  make
  cp .libs/libev.a $OUTPUT_PATH
  set +e
  echo "build done Done. ${ARCH}"
done
echo "build done Done."
echo "copying"

popd
lipo -create \
  ${CURRENTPATH}/bin/iPhoneSimulator${IOS_SDKVERSION}-i386.sdk/libev.a \
  ${CURRENTPATH}/bin/iPhoneSimulator${IOS_SDKVERSION}-x86_64.sdk/libev.a \
  ${CURRENTPATH}/bin/iPhoneOS${IOS_SDKVERSION}-armv7.sdk/libev.a \
  ${CURRENTPATH}/bin/iPhoneOS${IOS_SDKVERSION}-armv7s.sdk/libev.a \
  ${CURRENTPATH}/bin/iPhoneOS${IOS_SDKVERSION}-arm64.sdk/libev.a \
  -output ${CURRENTPATH}/lib/libev.a

cp -f $SRC_DIR/ev.h $SRC_DIR/ev_vars.h $SRC_DIR/ev_wrap.h $SRC_DIR/event.h  ${CURRENTPATH}/include/ 

echo "Clean Up... "
rm -rf ${CURRENTPATH}/bin
echo "Done."