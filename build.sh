#!/bin/bash
if [ -z $LIB_BUILDER_PATH ]; then
       	LIB_BUILDER_PATH=.
fi
source $LIB_BUILDER_PATH/tools/config.sh

if [ -e "$AR_TOOLS" ]; then
        rm -rf "$AR_TOOLS"
fi
if [ -e "$AR_SDK" ]; then
        rm -rf "$AR_SDK"
fi

#Build esp32
export PRODUCT=esp32
cp $LIB_BUILDER_PATH/sdkconfig.$PRODUCT $LIB_BUILDER_PATH/sdkconfig
$IDF_PATH/tools/idf.py fullclean
$IDF_PATH/tools/idf.py build
if [ $? -ne 0 ]; then exit 1; fi
$LIB_BUILDER_PATH/tools/prepare-libs.sh
if [ $? -ne 0 ]; then exit 1; fi
$LIB_BUILDER_PATH/tools/build-bootloaders.sh
if [ $? -ne 0 ]; then exit 1; fi

#Build esp32s2
cp $LIB_BUILDER_PATH/sdkconfig.esp32s2 $LIB_BUILDER_PATH/sdkconfig
$IDF_PATH/tools/idf.py fullclean
$IDF_PATH/tools/idf.py build
if [ $? -ne 0 ]; then exit 1; fi
$LIB_BUILDER_PATH/tools/prepare-libs.sh
if [ $? -ne 0 ]; then exit 1; fi
$LIB_BUILDER_PATH/tools/build-bootloaders.sh
if [ $? -ne 0 ]; then exit 1; fi

# archive the build
$LIB_BUILDER_PATH/tools/archive-build.sh
if [ $? -ne 0 ]; then exit 1; fi

