route add -net 224.0.0.0/4 default
VSOMEIP_PATH=../lib
export LD_LIBRARY_PATH=${VSOMEIP_PATH}:$LD_LIBRARY_PATH
export VSOMEIP_APPLICATION_NAME=vsomeipd
export VSOMEIP_CONFIGURATION=../config/vsomeip-service.json
../bin/vsomeipd
