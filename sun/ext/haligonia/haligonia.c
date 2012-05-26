#include <math.h>
#include <ruby.h>


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


typedef struct ANSIVector_s {
    double x,y;
} ANSIVector;


static void deallocate_vector(void *vector) {
    free(vector);
}

static VALUE allocate_vector(VALUE klass) {
    ANSIVector *vector = (ANSIVector *)malloc(sizeof(ANSIVector));
    return Data_Wrap_Struct(klass, NULL, deallocate_vector, vector);
}

static VALUE vector_initialize(VALUE self, VALUE rbx, VALUE rby) {
    ANSIVector *vector;
    Data_Get_Struct(self, ANSIVector, vector );
    vector->x = NUM2DBL(rbx);
    vector->y = NUM2DBL(rby);
    return self;
}

static VALUE vector_get_x(VALUE self) {
    ANSIVector *vector;
    Data_Get_Struct(self, ANSIVector, vector );

    return rb_float_new(vector->x);
}
static VALUE vector_set_x(VALUE self, VALUE x) {
    ANSIVector *vector;
    Data_Get_Struct(self, ANSIVector, vector );
    vector->x = NUM2DBL(x);
    return self;
}
static VALUE vector_get_y(VALUE self) {
    ANSIVector *vector;
    Data_Get_Struct(self, ANSIVector, vector );

    return rb_float_new(vector->y);
}
static VALUE vector_set_y(VALUE self, VALUE y) {
    ANSIVector *vector;
    Data_Get_Struct(self, ANSIVector, vector );
    vector->y = NUM2DBL(y);
    return self;
}

static void av_plus(ANSIVector *rv, ANSIVector *v1, ANSIVector *v2) {
    rv->x = v1->x + v2->x;
    rv->y = v1->y + v2->y;
}
static void av_minus(ANSIVector *rv, ANSIVector *v1, ANSIVector *v2) {
    rv->x = v1->x - v2->x;
    rv->y = v1->y - v2->y;
}
static double av_norm(ANSIVector *v) {
    return sqrt((v->x * v->x) + (v->y * v->y));
}
static double av_dot(ANSIVector *v1, ANSIVector *v2) {
    return (v1->x * v2->x) + (v1->y * v2->y);
}

static void av_scale(ANSIVector *rv, ANSIVector *vector, double scale) {
    rv->x = vector->x * scale;
    rv->y = vector->y * scale;
}

static VALUE vector_sum(VALUE self) {
    ANSIVector *v1;
    Data_Get_Struct(self, ANSIVector, v1 );
    return rb_float_new(v1->x + v1->y);
}
static VALUE vector_min(VALUE self) {
    ANSIVector *v1;
    Data_Get_Struct(self, ANSIVector, v1 );
    double m = v1->y > v1->x ? v1->x : v1->y;
    return rb_float_new(m);
}
static VALUE vector_max(VALUE self) {
    ANSIVector *v1;
    Data_Get_Struct(self, ANSIVector, v1 );
    double m = v1->y > v1->x ? v1->y : v1->x;
    return rb_float_new(m);
}


static VALUE vector_plus(VALUE self, VALUE dest, VALUE other) {
    ANSIVector *v1;
    ANSIVector *v2;
    ANSIVector *rv;
    Data_Get_Struct(self, ANSIVector, v1 );
    Data_Get_Struct(other, ANSIVector, v2 );
    Data_Get_Struct(dest, ANSIVector, rv );
    av_plus(rv, v1, v2);
    return rv;
}
static VALUE vector_minus(VALUE self, VALUE dest, VALUE other) {
    ANSIVector *v1;
    ANSIVector *v2;
    ANSIVector *rv;
    Data_Get_Struct(self, ANSIVector, v1 );
    Data_Get_Struct(other, ANSIVector, v2 );
    Data_Get_Struct(dest, ANSIVector, rv );

    av_minus(rv, v1, v2);
    return rv;
}
static VALUE vector_scale(VALUE self, VALUE dest, VALUE scale) {
    ANSIVector *v;
    ANSIVector *rv;
    Data_Get_Struct(self, ANSIVector, v );
    Data_Get_Struct(dest, ANSIVector, rv );

    av_scale(rv, v, NUM2DBL(scale));
    return rv;
}
static VALUE vector_distance_from(VALUE self, VALUE other) {
    ANSIVector *v1;
    ANSIVector *v2;
    ANSIVector tmp;
    Data_Get_Struct(self, ANSIVector, v1 );
    Data_Get_Struct(other, ANSIVector, v2 );
    av_minus(&tmp, v1, v2);
    double norm = av_norm(&tmp);

    return rb_float_new(norm);
}
static VALUE vector_norm(VALUE self) {
    ANSIVector *v;
    Data_Get_Struct(self, ANSIVector, v );
    return  rb_float_new(av_norm(v));
}
static VALUE vector_unit(VALUE self, VALUE dest) {
    ANSIVector *v;
    ANSIVector *rv;
    Data_Get_Struct(self, ANSIVector, v );
    Data_Get_Struct(dest, ANSIVector, rv );

    double norm = av_norm(v);
    if (norm == 0.0) return self;
    double scale_factor = 1.0/norm;

    av_scale(rv, v, scale_factor);

    return  rv;
}
static VALUE vector_dot(VALUE self, VALUE other) {
    ANSIVector *v1;
    ANSIVector *v2;
    Data_Get_Struct(self, ANSIVector, v1 );
    Data_Get_Struct(other, ANSIVector, v2 );

    return  rb_float_new(av_dot(v1, v2));
}
static VALUE rb_cANSIVector;
static VALUE rb_cGVector;

static VALUE vector_xy(VALUE self, VALUE x, VALUE y) {
    VALUE vector = allocate_vector(rb_cANSIVector);
    return vector_initialize(vector, x, y);
}
static VALUE vector_gvxy(VALUE self, VALUE x, VALUE y) {
    VALUE vector = allocate_vector(rb_cGVector);
    return vector_initialize(vector, x, y);
}


void Init_haligonia() {
    rb_cANSIVector = rb_define_class("ANSIVector", rb_cObject);
    rb_define_alloc_func(rb_cANSIVector, allocate_vector);
    rb_define_method(rb_cANSIVector, "initialize", vector_initialize, 2);
    rb_define_method(rb_cANSIVector, "x", vector_get_x, 0);
    rb_define_method(rb_cANSIVector, "x=", vector_set_x, 1);
    rb_define_method(rb_cANSIVector, "y", vector_get_y, 0);
    rb_define_method(rb_cANSIVector, "y=", vector_set_y, 1);
    rb_define_method(rb_cANSIVector, "plus", vector_plus, 2);
    rb_define_method(rb_cANSIVector, "minus", vector_minus, 2);
    rb_define_method(rb_cANSIVector, "distance_from", vector_distance_from, 1);
    rb_define_method(rb_cANSIVector, "scale", vector_scale, 2);
    rb_define_method(rb_cANSIVector, "norm", vector_norm, 0);
    rb_define_method(rb_cANSIVector, "sum2d", vector_sum, 0);
    rb_define_method(rb_cANSIVector, "min", vector_min, 0);
    rb_define_method(rb_cANSIVector, "max", vector_max, 0);
    rb_define_method(rb_cANSIVector, "unit", vector_unit, 1);
    rb_define_method(rb_cANSIVector, "dot", vector_dot, 1);
    rb_define_singleton_method(rb_cANSIVector, "xy", vector_xy, 2);

    rb_cGVector = rb_define_class("GVector", rb_cObject);
    rb_define_alloc_func(rb_cGVector, allocate_vector);
    rb_define_method(rb_cGVector, "initialize", vector_initialize, 2);
    rb_define_method(rb_cGVector, "x", vector_get_x, 0);
    rb_define_method(rb_cGVector, "x=", vector_set_x, 1);
    rb_define_method(rb_cGVector, "y", vector_get_y, 0);
    rb_define_method(rb_cGVector, "y=", vector_set_y, 1);
    rb_define_method(rb_cGVector, "plus", vector_plus, 2);
    rb_define_method(rb_cGVector, "minus", vector_minus, 2);
    rb_define_method(rb_cGVector, "distance_from", vector_distance_from, 1);
    rb_define_method(rb_cGVector, "scale", vector_scale, 2);
    rb_define_method(rb_cGVector, "norm", vector_norm, 0);
    rb_define_method(rb_cGVector, "sum2d", vector_sum, 0);
    rb_define_method(rb_cGVector, "min", vector_min, 0);
    rb_define_method(rb_cGVector, "max", vector_max, 0);
    rb_define_method(rb_cGVector, "unit", vector_unit, 1);
    rb_define_method(rb_cGVector, "dot", vector_dot, 1);
    rb_define_singleton_method(rb_cGVector, "xy", vector_gvxy, 2);


}


