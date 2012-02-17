#include <ruby.h>
#include <chipmunk/chipmunk.h>

#include <stdio.h>


VALUE cRipmunk;
VALUE cRipmunkSpace;

VALUE
make_rp_space(VALUE mod) {
    cpSpace *space = cpSpaceNew();

//    printf("rpm: integrations: %d\n", space->iterations);

    return (VALUE)space;
}

VALUE
get_iterations_from_space(VALUE mod, VALUE v_space) {
    cpSpace *space = (cpSpace*)v_space;
    
    return INT2NUM(space->iterations);
}

VALUE
space_get_iterations(VALUE cls) {
    // cpSpace *space = (cpSpace*)cls;
    cpSpace *space;
    Data_Get_Struct(cls, cpSpace, space);
//    printf("get iters: %d,%x\n", space->iterations, space);
    return INT2NUM(space->iterations);

}


static void space_mark(cpSpace *space) {
    // NOOP?
}
static void space_free(cpSpace *space) {
    if (space)
        cpSpaceFree(space);
    
}

static VALUE
space_allocate(VALUE cls) {
    cpSpace *space = cpSpaceNew();
//    printf("new called: %d, %p\n", space->iterations, space);
//    printf("rpm: integrations: %d\n", space->iterations);

    return Data_Wrap_Struct(cls, space_mark, space_free, space);
}

void Init_ripmunk()
{
  cRipmunk = rb_define_module("Ripmunk");

  // rb_define_alloc_func(cStree, allocate);
  rb_define_singleton_method(cRipmunk, "make_space", make_rp_space, 0);
  rb_define_singleton_method(cRipmunk, "get_iterations_from_space", get_iterations_from_space, 1);

  cRipmunkSpace = rb_define_class_under(cRipmunk, "Space", rb_cObject);
  rb_define_alloc_func(cRipmunkSpace, space_allocate);
  rb_define_method(cRipmunkSpace, "iterations", space_get_iterations, 0);
  //  rb_define_method(cStree, "longest_common_substr", longest_common_substr, 2);

  // Init_stree_stringset();
}