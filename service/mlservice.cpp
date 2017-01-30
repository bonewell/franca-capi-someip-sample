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

  _reply(messageStream.str());
}

void MLService::howMuch(const std::shared_ptr<CommonAPI::ClientId> _client,
                       howMuchReply_t _reply) {
  std::cout << "howMuch()\n";

  fireGetOutEvent("Bye!!!");

  _reply(300);
}
