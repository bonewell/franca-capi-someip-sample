# franca-capi-someip-sample
Dependencies
* [capicxx-core-runtime](https://github.com/GENIVI/capicxx-core-runtime)
* [capicxx-core-tools](https://github.com/GENIVI/capicxx-core-tools)
* [capicxx-someip-runtime](https://github.com/GENIVI/capicxx-someip-runtime)
* [capicxx-someip-tools](https://github.com/GENIVI/capicxx-someip-tools)
* [vsomeip](https://github.com/GENIVI/vsomeip)

In order to have less issues while building and running this sample, do next:
* create `git` directory in your home directory
* clone all dependecies into this `git` directory
* create `build` directories into capicxx-core-runtime, capicxx-someip-runtime and vsomeip projects
* build capicxx-core-runtime, capicxx-someip-runtime and vsomeip projects in `build` directories (see manual for these projects)
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
Set up the sample for your network (see build/config/vsomeip-service.json and build/config/vsomeip-client.json)
Change `unicast` fields.

Steps to run:
On one of your hosts you have to run vsomeipd.sh and service.sh from build/scripts directory. Make `cd build/scripts` before run them.
On another of your hosts you have to run client.sh from build/scripts directory. Make `cd build/scripts` before run them.

**Warning:** unfortuantly, client works only once, next you need to reboot system. I'll investigate this issue.
