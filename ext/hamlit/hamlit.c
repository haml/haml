#include <ruby.h>
#include <ruby/encoding.h>
#include "houdini.h"

VALUE mAttributeBuilder;
static ID id_flatten, id_underscore;

static void
delete_falsey_values(VALUE values)
{
  VALUE value;
  long i;

  for (i = RARRAY_LEN(values) - 1; 0 <= i; i--) {
    value = rb_ary_entry(values, i);
    if (!RTEST(value)) {
      rb_ary_delete_at(values, i);
    }
  }
}

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
escape_attribute(VALUE escape_attrs, VALUE str)
{
  if (RTEST(escape_attrs)) {
    return escape_html(str);
  } else {
    return str;
  }
}

static VALUE
rb_escape_html(RB_UNUSED_VAR(VALUE self), VALUE str)
{
  return escape_html(rb_convert_type(str, T_STRING, "String", "to_s"));
}

static VALUE
hamlit_build_id(VALUE escape_attrs, VALUE values)
{
  VALUE attr_value;

  values = rb_funcall(values, id_flatten, 0);
  delete_falsey_values(values);

  attr_value = rb_ary_join(values, rb_const_get(mAttributeBuilder, id_underscore));
  return escape_attribute(escape_attrs, attr_value);
}

static VALUE
rb_hamlit_build_id(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 1, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 1, argv + 1, "*", &array);

  return hamlit_build_id(argv[0], array);
}

void
Init_hamlit(void)
{
  VALUE mHamlit, mUtils;

  mHamlit           = rb_define_module("Hamlit");
  mUtils            = rb_define_module_under(mHamlit, "Utils");
  mAttributeBuilder = rb_define_module_under(mHamlit, "AttributeBuilder");

  rb_define_singleton_method(mUtils, "escape_html", rb_escape_html, 1);
  rb_define_singleton_method(mAttributeBuilder, "build_id", rb_hamlit_build_id, -1);

  id_flatten    = rb_intern("flatten");
  id_underscore = rb_intern("UNDERSCORE");

  rb_const_set(mAttributeBuilder, id_underscore, rb_obj_freeze(rb_str_new_cstr("_")));
}
