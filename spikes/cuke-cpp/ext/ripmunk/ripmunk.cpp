#include "rice/Data_Type.hpp"
#include "rice/Constructor.hpp"
#include "rice/Module.hpp"
#include "rice/Class.hpp"
#include "rice/String.hpp"

#include <cmath>
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
int primitive_circle_line_segment_intersection_cpp(float cx, float cy,float cr, float ls1x, float ls1y, float ls2x, float ls2y) {
    float seg_vx = ls2x - ls1x;
    float seg_vy = ls2y - ls1y;

    float pt_vx = cx - ls1x;
    float pt_vy = cy - ls1y;

    float seg_v_norm = sqrt(seg_vx * seg_vx + seg_vy * seg_vy);
    float seg_vux = seg_vx/seg_v_norm;
    float seg_vuy = seg_vy/seg_v_norm;

    float proj_len = pt_vx * seg_vux + pt_vy * seg_vuy;
    float projx = seg_vux * proj_len;
    float projy = seg_vuy * proj_len;

    float closestx = -1;
    float closesty = -1;
    if (proj_len < 0) {
      closestx = ls1x;
      closesty = ls1y;
    } else if (proj_len > seg_v_norm) {
      closestx = ls2x;
      closesty = ls2y;
    } else {
      closestx = ls1x + projx;
      closesty = ls1y + projy;
    }

    float dist_vx = cx - closestx;
    float dist_vy = cy - closesty;

    return (dist_vx * dist_vx + dist_vy * dist_vy) <= cr * cr;
}

extern "C"
void Init_ripmunk() {

    Class rb_cFoo =
            define_class<Foo>("Foo")
            .define_constructor(Constructor<Foo>())
            .define_method("hello", &test_hello);

    Module rb_mPrimitiveOpsCpp =
            define_module("PrimitiveOpsCpp")
            .define_method("hello", &test_hello)
            .define_method("primitive_circle_line_segment_intersection_cpp", &primitive_circle_line_segment_intersection_cpp);


}

