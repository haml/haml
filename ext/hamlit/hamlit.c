#include <ruby.h>

VALUE mAttributeBuilder;
static ID id_temple, id_utils, id_escape_html;
static ID id_flatten, id_join;
static ID id_underscore;

static VALUE
attr_build_id(VALUE escape_attrs, VALUE ids)
{
  VALUE truthy_ids, id, attr_value, mUtils;
  int i, len;

  ids = rb_funcall(ids, id_flatten, 0);

  truthy_ids = rb_ary_new();
  len = RARRAY_LEN(ids);
  for (i = 0; i < len; i++) {
    id = rb_ary_entry(ids, i);
    if (!NIL_P(id) && id != Qfalse) {
      rb_ary_push(truthy_ids, id);
    }
  }

  attr_value = rb_funcall(truthy_ids, id_join, 1, rb_const_get(mAttributeBuilder, id_underscore));
  if (RTEST(escape_attrs)) {
    mUtils = rb_const_get(rb_const_get(rb_cObject, id_temple), id_utils);
    attr_value = rb_funcall(mUtils, id_escape_html, 1, attr_value);
  }

  return attr_value;
}

static VALUE
rb_attr_build_id(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 1, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 1, argv + 1, "*", &array);

  return attr_build_id(argv[0], array);
}

void
Init_hamlit(void)
{
  VALUE mHamlit;

  mHamlit           = rb_define_module("Hamlit");
  mAttributeBuilder = rb_define_module_under(mHamlit, "AttributeBuilder");
  rb_define_singleton_method(mAttributeBuilder, "build_id", rb_attr_build_id, -1);

  id_temple      = rb_intern("Temple");
  id_utils       = rb_intern("Utils");
  id_escape_html = rb_intern("escape_html");

  id_flatten = rb_intern("flatten");
  id_join    = rb_intern("join");

  id_underscore = rb_intern("UNDERSCORE");
  rb_const_set(mAttributeBuilder, id_underscore, rb_obj_freeze(rb_str_new_cstr("_")));
}
