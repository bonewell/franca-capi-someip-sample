#!/usr/bin/env bash

export LD_LIBRARY_PATH=~/git/vsomeip/build/lib
export VSOMEIP_APPLICATION_NAME=vsomeipd
export VSOMEIP_CONFIGURATION=~/git/franca-capi-someip-sample/fidl/vsomeip.json
~/git/vsomeip/build/bin/vsomeipd
