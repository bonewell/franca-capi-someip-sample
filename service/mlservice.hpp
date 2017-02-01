#ifndef MLSERVICE_H_
#define MLSERVICE_H_

#include "CommonAPI/CommonAPI.hpp"
#include "v1/ford/rnd/MLStubDefault.hpp"

class MLService : public v1::ford::rnd::MLStubDefault {
 public:
  MLService();
  virtual ~MLService();
  virtual void sayHello(const std::shared_ptr<CommonAPI::ClientId> _client,
                        std::string _name, sayHelloReply_t _reply);
  virtual void howMuch(const std::shared_ptr<CommonAPI::ClientId> _client,
                       howMuchReply_t _reply);
  virtual void getDeviceType(const std::shared_ptr<CommonAPI::ClientId> _client,
                             getDeviceTypeReply_t _reply);
  virtual void getConnectionType(
      const std::shared_ptr<CommonAPI::ClientId> _client,
      getConnectionTypeReply_t _reply);

 private:
  typedef std::map<std::size_t, std::string> ClientList;
  ClientList clients_;
};

#endif /* MLSERVICE_H_ */
