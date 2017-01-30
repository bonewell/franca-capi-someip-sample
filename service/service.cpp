#include <memory>
#include <iostream>
#include <thread>
#include "CommonAPI/CommonAPI.hpp"
#include "mlservice.hpp"
#include "smartmlservice.hpp"

int main() {
    std::string domain = "local";
    std::string instance = "ford.rnd.ML";
    std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();
    std::shared_ptr<MLService> myService = std::make_shared<MLService>();
    bool ret_ml = runtime->registerService(domain, instance, myService);
    if (ret_ml) {
      std::cout << "Successfully Registered Service!" << std::endl;
    }

    std::string s_instance = "ford.rnd.SmartML";
    std::shared_ptr<SmartMLService> mySService = std::make_shared<SmartMLService>();
    bool ret_sml = runtime->registerService(domain, s_instance, mySService);
    if (ret_sml) {
      std::cout << "Successfully Registered Smart Service!" << std::endl;
    }

    while (true) {
        std::cout << "Waiting for calls... (Abort with CTRL+C)" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(30));
    }

    return 0;
 }
