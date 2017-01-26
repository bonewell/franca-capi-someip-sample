#!/usr/bin/env bash

sudo route add -net 224.0.0.0/4 dev ens33
VSOMEIP_PATH=~/git/genivi/vsomeip/build
export LD_LIBRARY_PATH=${VSOMEIP_PATH}:$LD_LIBRARY_PATH
export VSOMEIP_APPLICATION_NAME=vsomeipd
export VSOMEIP_CONFIGURATION=../config/vsomeip-service.json
${VSOMEIP_PATH}/bin/vsomeipd
