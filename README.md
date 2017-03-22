# franca-capi-someip-sample
Dependencies
* [capicxx-core-runtime](https://github.com/GENIVI/capicxx-core-runtime)
* [capicxx-core-tools](https://github.com/GENIVI/capicxx-core-tools)
* [vsomeip](https://github.com/GENIVI/vsomeip)
* [capicxx-someip-runtime](https://github.com/GENIVI/capicxx-someip-runtime)
* [capicxx-someip-tools](https://github.com/GENIVI/capicxx-someip-tools)

In order to have less issues while building and running this sample, do next:
* create `git/genivi` directory in your home directory
* clone all dependecies into this `git/genivi` directory
* create `build` directories into capicxx-core-runtime, vsomeip and capicxx-someip-runtime projects
* build capicxx-core-runtime, vsomeip and capicxx-someip-runtimeprojects in `build` directories (see manual for these projects)
* make install for capicxx-core-runtime, vsomeip and capicxx-someip-runtime
* build generators capicxx-core-tools and capicxx-someip-tools (see manual for these projects)

Also you might read our [WiKi article](https://github.com/bonewell/franca-capi-someip-sample/wiki)

If you are interested in QNX 6.6 you might look at [Build for QNX 6.6](https://github.com/bonewell/franca-capi-someip-sample/wiki/Build-for-QNX-6.6)

Steps to build and install of this sample:
```Shell
cd /franca-capi-someip-sample
mkdir build
cd build
cmake ..
make
```

Build for QNX 6.6:
```Shell
source <QNX_SDP>/qnx660-env.sh
mkdir build
cd build
cmake -DCMAKE_TOOLCHAIN_FILE=../qnx_6.6.0_linux_x86.cmake -DCMAKE_INSTALL_PREFIX=deploy ..
make
make install
```

Deploy to QNX 6.6
```Shell
cp <your_path>/vsomeipd deploy/bin
cp <your_path>/libvsomeip* deploy/lib
cp <your_path>/libCommonAPI* deploy/lib
cp <your_path>/libCommonAPI-SomeIP* deploy/lib
tar -cf sample.tar deploy
scp sample.tar root@<target_ip>:~
```

In order to run the sample you need two hosts (two PC or two virtual machines).
Set up the sample for your network (see build/build/config/vsomeip-service.json and build/build/config/vsomeip-client.json)
Change `unicast` fields.
Also you have to change network device in bash scripts (see build/build/scripts/vsomeipd.sh and build/build/scripts/client.sh)
`sudo route add -net 224.0.0.0/4 dev ens33` or for QNX 6.6 `route add -net 224.0.0.0/4 default`

Steps to run:
On one of your hosts you have to run vsomeipd.sh and service.sh from build/scripts directory. Make `cd build/scripts` before run them.
On another of your hosts you have to run client.sh from build/scripts directory. Make `cd build/scripts` before run them.

