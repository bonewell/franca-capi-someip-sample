#!/usr/bin/env bash

export LD_LIBRARY_PATH=../lib:$LD_LIBRARY_PATH
export VSOMEIP_APPLICATION_NAME=client-sample
export VSOMEIP_CONFIGURATION=../config/vsomeip-client.json
export COMMONAPI_CONFIG=../config/commonapi.ini
../bin/client
