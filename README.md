# franca-capi-someip-sample
Dependencies
* [capicxx-core-runtime](https://github.com/GENIVI/capicxx-core-runtime)
* [capicxx-core-tools](https://github.com/GENIVI/capicxx-core-tools)
* [capicxx-someip-runtime](https://github.com/GENIVI/capicxx-someip-runtime)
* [capicxx-someip-tools](https://github.com/GENIVI/capicxx-someip-tools)
* [vsomeip](https://github.com/GENIVI/vsomeip)

In order to have less issues while building and running this sample, do next:
* create `git/genivi` directory in your home directory
* clone all dependecies into this `git/genivi` directory
* create `build` directories into capicxx-core-runtime, capicxx-someip-runtime and vsomeip projects
* build capicxx-core-runtime, capicxx-someip-runtime and vsomeip projects in `build` directories (see manual for these projects)
* make install for capicxx-core-runtime, capicxx-someip-runtime and vsomeip
* build generators capicxx-core-tools and capicxx-someip-tools (see manual for these projects)

Steps to build and install of this sample:
```Shell
cd /franca-capi-someip-sample
mkdir build
cd build
cmake ..
make
make install
```

In order to run the sample you need two hosts (two PC or two virtual machines).
Set up the sample for your network (see build/build/config/vsomeip-service.json and build/build/config/vsomeip-client.json)
Change `unicast` fields.
Also you have to change network device in bash scripts (see build/build/scripts/vsomeipd.sh and build/build/scripts/client.sh)
`sudo route add -net 224.0.0.0/4 dev ens33`

Steps to run:
On one of your hosts you have to run vsomeipd.sh and service.sh from build/build/scripts directory. Make `cd build/build/scripts` before run them.
On another of your hosts you have to run client.sh from build/build/scripts directory. Make `cd build/build/scripts` before run them.

