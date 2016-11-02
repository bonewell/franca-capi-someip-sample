#include <iostream>
#include <string>
#include <unistd.h>
#include <CommonAPI/CommonAPI.hpp>
#include <v1/ford/rnd/MLProxy.hpp>
 
using namespace v1_0::ford::rnd;
 
int main() {
    std::string domain = "local";
    std::string instance = "ford.rnd.ML";
    std::shared_ptr < CommonAPI::Runtime > runtime = CommonAPI::Runtime::get();
    std::shared_ptr<MLProxy<>> myProxy = runtime->buildProxy<MLProxy>(domain, instance);
 
    if (!myProxy) {
        std::cout << "Could not build proxy" << std::endl;
        return 1;
    }
    std::cout << "Checking availability!" << std::endl;
    while (!myProxy->isAvailable())
        usleep(10);
    std::cout << "Available..." << std::endl;
 
    CommonAPI::CallStatus callStatus;
    std::string returnMessage;
    myProxy->sayHello("Bob", callStatus, returnMessage);
    std::cout << "Got message: '" << returnMessage << "'\n";
     
    return 0;
} 
