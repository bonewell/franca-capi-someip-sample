#ifndef STUB_H_
#define STUB_H_

#include "CommonAPI/CommonAPI.hpp"
#include "v1/ford/rnd/MLStubDefault.hpp"

class Stub: public v1::ford::rnd::MLStubDefault {
public:
    Stub();
    virtual ~Stub();
    virtual void sayHello(const std::shared_ptr<CommonAPI::ClientId> _client, std::string _name, sayHelloReply_t _return);
};

#endif /* STUB_H_ */
