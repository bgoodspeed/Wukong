#include <math.h>
#include <ruby.h>


int pi_circle_line_segment_intersection(double cx, double cy,double cr, double ls1x, double ls1y, double ls2x, double ls2y) {
    double seg_vx = ls2x - ls1x;
    double seg_vy = ls2y - ls1y;

    double pt_vx = cx - ls1x;
    double pt_vy = cy - ls1y;

    double seg_v_norm = sqrt(seg_vx * seg_vx + seg_vy * seg_vy);
    double seg_vux = seg_vx/seg_v_norm;
    double seg_vuy = seg_vy/seg_v_norm;

    double proj_len = pt_vx * seg_vux + pt_vy * seg_vuy;
    double projx = seg_vux * proj_len;
    double projy = seg_vuy * proj_len;

    double closestx = -1;
    double closesty = -1;
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

    double dist_vx = cx - closestx;
    double dist_vy = cy - closesty;

    if ((dist_vx * dist_vx + dist_vy * dist_vy) <= cr * cr) return 1;
    return -1;
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
    return dest;
}
static VALUE vector_minus(VALUE self, VALUE dest, VALUE other) {
    ANSIVector *v1;
    ANSIVector *v2;
    ANSIVector *rv;
    Data_Get_Struct(self, ANSIVector, v1 );
    Data_Get_Struct(other, ANSIVector, v2 );
    Data_Get_Struct(dest, ANSIVector, rv );

    av_minus(rv, v1, v2);
    return dest;
}
static VALUE vector_scale(VALUE self, VALUE dest, VALUE scale) {
    ANSIVector *v;
    ANSIVector *rv;
    Data_Get_Struct(self, ANSIVector, v );
    Data_Get_Struct(dest, ANSIVector, rv );

    av_scale(rv, v, NUM2DBL(scale));
    return dest;
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

    return  dest;
}
static VALUE vector_dot(VALUE self, VALUE other) {
    ANSIVector *v1;
    ANSIVector *v2;
    Data_Get_Struct(self, ANSIVector, v1 );
    Data_Get_Struct(other, ANSIVector, v2 );

    return  rb_float_new(av_dot(v1, v2));
}
static VALUE rb_cGVector;
static VALUE rb_cSpatialHash;
static VALUE rb_cFoobar;
static VALUE rb_mPrimitiveIntersectionTests;

static VALUE vector_gvxy(VALUE self, VALUE x, VALUE y) {
    VALUE vector = allocate_vector(rb_cGVector);
    return vector_initialize(vector, x, y);
}

static int plus_forty_two(int x) {
    return x + 42;
}

static VALUE rb_plus_forty_two(VALUE self, VALUE x) {
    int rv = plus_forty_two(NUM2INT(x));
    return INT2NUM(rv);
}
static long sh_spatial_hash(long x,long y, long x_prime, long y_prime, long base_table_size) {
    unsigned long p = (x_prime * x) ^ (y_prime * y);
    long bt = base_table_size;
    long rv = p % bt;
    return  rv;
}
static VALUE rb_sh_spatial_hash(VALUE self, VALUE x,VALUE y, VALUE x_prime, VALUE y_prime, VALUE base_table_size) {
    long hash = sh_spatial_hash(NUM2LONG(x),NUM2LONG(y), NUM2LONG(x_prime), NUM2LONG(y_prime), NUM2LONG(base_table_size));
    return LONG2NUM(hash);
}
static long sh_cell_index_for(long e, long cs) {
    return (e/cs);
}

static VALUE rb_sh_cell_index_for(VALUE self, VALUE x, VALUE cs) {
    return LONG2NUM(sh_cell_index_for(NUM2LONG(x), NUM2LONG(cs)));
}

static VALUE rb_pi_circle_line_segment_intersection(VALUE self, VALUE cx,VALUE cy,VALUE cr, VALUE ls1x, VALUE ls1y,VALUE ls2x,VALUE ls2y) {
    int rv = pi_circle_line_segment_intersection(NUM2DBL(cx), NUM2DBL(cy), NUM2DBL(cr), NUM2DBL(ls1x), NUM2DBL(ls1y), NUM2DBL(ls2x), NUM2DBL(ls2y));
    if (rv < 0) {
        return Qfalse;
    }

    return Qtrue;
}


void Init_haligonia() {

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

    rb_cSpatialHash = rb_define_class("SpatialHash", rb_cObject);
    rb_define_method(rb_cSpatialHash, "spatial_hash", rb_sh_spatial_hash, 5);
    rb_define_method(rb_cSpatialHash, "cell_x_index_for", rb_sh_cell_index_for, 2);
    rb_define_method(rb_cSpatialHash, "cell_y_index_for", rb_sh_cell_index_for, 2);

    // TODO remove this:
    rb_cFoobar = rb_define_class("Foobar", rb_cObject);
    rb_define_method(rb_cFoobar, "plus_forty_two", rb_plus_forty_two, 2);
    rb_define_method(rb_cFoobar, "sh", rb_sh_spatial_hash, 5);

    rb_mPrimitiveIntersectionTests = rb_define_module("PrimitiveIntersectionTests");
    rb_define_method(rb_mPrimitiveIntersectionTests, "primitive_circle_line_segment_intersection?", rb_pi_circle_line_segment_intersection, 7);

}


