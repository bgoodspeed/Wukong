#include "rice/Data_Type.hpp"
#include "rice/Constructor.hpp"
#include "rice/Module.hpp"
#include "rice/Class.hpp"
#include "rice/String.hpp"

class Foo {
public:
    Foo() {};
    std::string hello();
};

using namespace Rice;



Object test_hello(Object /* self */) {
    String str("hello, world");
    return str;
}

extern "C"
void Init_ripmunk() {

    Class rb_cFoo =
            define_class<Foo>("Foo")
            .define_constructor(Constructor<Foo>())
            .define_method("hello", &test_hello);

}

