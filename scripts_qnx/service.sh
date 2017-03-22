export LD_LIBRARY_PATH=../lib:$LD_LIBRARY_PATH
export VSOMEIP_APPLICATION_NAME=service-sample
export VSOMEIP_CONFIGURATION=../config/vsomeip-service.json
export COMMONAPI_CONFIG=../config/commonapi.ini
../bin/MLService
