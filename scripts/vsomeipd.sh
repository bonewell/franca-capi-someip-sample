#!/usr/bin/env bash

sudo route add -net 224.0.0.0/4 dev ens33
export LD_LIBRARY_PATH=../lib:$LD_LIBRARY_PATH
export VSOMEIP_APPLICATION_NAME=vsomeipd
export VSOMEIP_CONFIGURATION=../config/vsomeip-service.json
../bin/vsomeipd
