#include <memory>
#include <iostream>
#include <thread>
#include "CommonAPI/CommonAPI.hpp"
#include "mlservice.hpp"
#include "smartmlservice.hpp"
#include "buttonsservice.hpp"

int main() {
    std::string domain = "local";
    std::string instance = "com.ford.rnd.ML";
    std::shared_ptr<CommonAPI::Runtime> runtime = CommonAPI::Runtime::get();
    std::shared_ptr<MLService> myService = std::make_shared<MLService>();
    bool ret_ml = runtime->registerService(domain, instance, myService);
    if (ret_ml) {
      std::cout << "Successfully Registered Service!" << std::endl;
    } else {
      std::cerr << "Service is not registered!" << std::endl;
    }

    std::string b_instance = "com.ford.rnd.Buttons";
    std::shared_ptr<ButtonsService> Buttons = std::make_shared<ButtonsService>();
    bool ret_buttons = runtime->registerService(domain, b_instance, Buttons);
    if (ret_buttons) {
      std::cout << "Successfully Registered Buttons Service!" << std::endl;
    } else {
      std::cerr << "Buttons Service is not registered!" << std::endl;
    }

    std::string s_instance = "com.ford.rnd.SmartML";
    std::shared_ptr<SmartMLService> mySService = std::make_shared<SmartMLService>();
    bool ret_sml = runtime->registerService(domain, s_instance, mySService);
    if (ret_sml) {
      std::cout << "Successfully Registered Smart Service!" << std::endl;
    } else {
      std::cerr << "Smart Service is not registered!" << std::endl;
    }

    while (true) {
        std::cout << "Waiting for calls... (Abort with CTRL+C)" << std::endl;
        std::this_thread::sleep_for(std::chrono::seconds(30));
    }

    return 0;
 }
