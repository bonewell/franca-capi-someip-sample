#include "mlservice.hpp"

MLService::MLService() {
}
MLService::~MLService() {
}

void MLService::sayHello(const std::shared_ptr<CommonAPI::ClientId> _client,
                      std::string _name, sayHelloReply_t _reply) {
  std::stringstream messageStream;
  messageStream << "Hello " << _name << "!";
  std::cout << "sayHello('" << _name << "'): '" << messageStream.str() << "'\n";

  setNameAttribute(_name);

  _reply(messageStream.str());
}

void MLService::howMuch(const std::shared_ptr<CommonAPI::ClientId> _client,
                       howMuchReply_t _reply) {
  std::cout << "howMuch()\n";

  if (getNameAttribute() == "Kate") {
    _reply(0);
  } else {
    fireGetOutEvent("Bye!!!");
    _reply(300);
  }
}
