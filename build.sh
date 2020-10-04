#!/bin/bash
if ! [ -x "$(command -v python)" ]; then
        echo "ERROR: python is not installed! Please install python first."
        exit 1
fi

if ! [ -x "$(command -v git)" ]; then
        echo "ERROR: git is not installed! Please install git first."
        exit 1
fi

if ! [ -x "$(command -v make)" ]; then
        echo "ERROR: Make is not installed! Please install Make first."
        exit 1
fi

if ! [ -x "$(command -v flex)" ]; then
        echo "ERROR: flex is not installed! Please install flex first."
        exit 1
fi

if ! [ -x "$(command -v bison)" ]; then
        echo "ERROR: bison is not installed! Please install bison first."
        exit 1
fi

if ! [ -x "$(command -v gperf)" ]; then
        echo "ERROR: gperf is not installed! Please install gperf first."
        exit 1
fi

if ! [ -x "$(command -v stat)" ]; then
        echo "ERROR: stat is not installed! Please install stat first."
        exit 1
fi

source $(dirname $0)/tools/config.sh

# clone/update repositories from git
$AR_ROOT/tools/pull-repos.sh
if [ $? -ne 0 ]; then exit 1; fi

if [ -e "$AR_TOOLS" ]; then
        rm -rf "$AR_TOOLS"
fi
if [ -e "$AR_SDK" ]; then
        rm -rf "$AR_SDK"
fi

source $IDF_PATH/export.sh

builder esp32
$AR_ROOT/tools/prepare-libs.sh
if [ $? -ne 0 ]; then exit 1; fi
$AR_ROOT/tools/build-bootloaders.sh
if [ $? -ne 0 ]; then exit 1; fi

builder esp32s2
$AR_ROOT/tools/prepare-libs.sh
if [ $? -ne 0 ]; then exit 1; fi
$AR_ROOT/tools/build-bootloaders.sh
if [ $? -ne 0 ]; then exit 1; fi

# archive the build
$AR_ROOT/tools/archive-build.sh
if [ $? -ne 0 ]; then exit 1; fi

