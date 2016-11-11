#include <iostream>
#include <thread>
#include "CommonAPI/CommonAPI.hpp"
#include "stub.hpp"

using namespace std;

int main() {
    std::string domain = "local";
    std::string instance = "ford.rnd.ML";
    std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();
    std::shared_ptr<Stub> myService = std::make_shared<Stub>();
    runtime->registerService(domain, instance, myService);
    std::cout << "Successfully Registered Service!" << std::endl;

    while (true) {
        std::cout << "Waiting for calls... (Abort with CTRL+C)" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(30));
    }

    return 0;
 }
