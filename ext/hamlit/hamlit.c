#include <ruby.h>
#include <ruby/encoding.h>
#include "houdini.h"

VALUE mAttributeBuilder;
static ID id_flatten, id_join;
static ID id_underscore;

static VALUE
escape_html(VALUE str)
{
  gh_buf buf = GH_BUF_INIT;

  Check_Type(str, T_STRING);

  if (houdini_escape_html0(&buf, (const uint8_t *)RSTRING_PTR(str), RSTRING_LEN(str), 0)) {
    str = rb_enc_str_new(buf.ptr, buf.size, rb_utf8_encoding());
    gh_buf_free(&buf);
  }

  return str;
}

static VALUE
rb_escape_html(RB_UNUSED_VAR(VALUE self), VALUE str)
{
  return escape_html(rb_convert_type(str, T_STRING, "String", "to_s"));
}

static VALUE
attr_build_id(VALUE escape_attrs, VALUE ids)
{
  VALUE truthy_ids, id, attr_value;
  int i, len;

  ids = rb_funcall(ids, id_flatten, 0);

  len = RARRAY_LEN(ids);
  truthy_ids = rb_ary_new2(len);
  for (i = 0; i < len; i++) {
    id = rb_ary_entry(ids, i);
    if (!NIL_P(id) && id != Qfalse) {
      rb_ary_push(truthy_ids, id);
    }
  }

  attr_value = rb_funcall(truthy_ids, id_join, 1, rb_const_get(mAttributeBuilder, id_underscore));
  if (RTEST(escape_attrs)) {
    attr_value = escape_html(attr_value);
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
  VALUE mHamlit, mUtils;

  mHamlit = rb_define_module("Hamlit");
  mUtils  = rb_define_module_under(mHamlit, "Utils");
  rb_define_singleton_method(mUtils, "escape_html", rb_escape_html, 1);

  mAttributeBuilder = rb_define_module_under(mHamlit, "AttributeBuilder");
  rb_define_singleton_method(mAttributeBuilder, "build_id", rb_attr_build_id, -1);

  id_flatten = rb_intern("flatten");
  id_join    = rb_intern("join");

  id_underscore = rb_intern("UNDERSCORE");
  rb_const_set(mAttributeBuilder, id_underscore, rb_obj_freeze(rb_str_new_cstr("_")));
}
