#!/usr/bin/env bash


COMMONAPI_PATH=~/git/genivi/capicxx-core-runtime/build
COMMONAPI_SOMEIP=~/git/genivi/capicxx-someip-runtime/build
export LD_LIBRARY_PATH=${COMMONAPI_PATH}:${COMMONAPI_SOMEIP_PATH}:$LD_LIBRARY_PATH
export VSOMEIP_APPLICATION_NAME=service-sample
export VSOMEIP_CONFIGURATION=../config/vsomeip-service.json
export COMMONAPI_CONFIG=../config/commonapi.ini
../bin/MLService
