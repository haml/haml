#include <ruby.h>
#include <ruby/encoding.h>
#include "houdini.h"

VALUE mAttributeBuilder;
static ID id_flatten, id_uniq_bang;
static ID id_space, id_underscore;

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
to_s(VALUE value)
{
  return rb_convert_type(value, T_STRING, "String", "to_s");
}

static VALUE
space()
{
  return rb_const_get(mAttributeBuilder, id_space);
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
rb_escape_html(RB_UNUSED_VAR(VALUE self), VALUE value)
{
  return escape_html(to_s(value));
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
hamlit_build_single_class(VALUE escape_attrs, VALUE value)
{
  switch (TYPE(value)) {
    case T_STRING:
      break;
    case T_ARRAY:
      value = rb_funcall(value, id_flatten, 0);
      delete_falsey_values(value);
      value = rb_ary_join(value, space());
      break;
    default:
      if (RTEST(value)) {
        value = to_s(value);
      } else {
        return rb_str_new_cstr("");
      }
      break;
  }
  return escape_attribute(escape_attrs, value);
}

static VALUE
hamlit_build_multi_class(VALUE escape_attrs, VALUE values)
{
  long i, j;
  VALUE value, buf;

  buf = rb_ary_new2(RARRAY_LEN(values));

  for (i = 0; i < RARRAY_LEN(values); i++) {
    value = rb_ary_entry(values, i);
    switch (TYPE(value)) {
      case T_STRING:
        rb_ary_concat(buf, rb_str_split(value, " "));
        break;
      case T_ARRAY:
        value = rb_funcall(value, id_flatten, 0);
        delete_falsey_values(value);
        for (j = 0; j < RARRAY_LEN(value); j++) {
          rb_ary_push(buf, to_s(rb_ary_entry(value, j)));
        }
        break;
      default:
        if (RTEST(value)) {
          rb_ary_push(buf, to_s(value));
        }
        break;
    }
  }

  rb_ary_sort_bang(buf);
  rb_funcall(buf, id_uniq_bang, 0);

  return escape_attribute(escape_attrs, rb_ary_join(buf, space()));
}

static VALUE
rb_hamlit_build_id(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 1, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 1, argv + 1, "*", &array);

  return hamlit_build_id(argv[0], array);
}

static VALUE
rb_hamlit_build_class(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 1, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 1, argv + 1, "*", &array);

  if (RARRAY_LEN(array) == 1) {
    return hamlit_build_single_class(argv[0], rb_ary_entry(array, 0));
  } else {
    return hamlit_build_multi_class(argv[0], array);
  }
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
  rb_define_singleton_method(mAttributeBuilder, "build_class", rb_hamlit_build_class, -1);

  id_flatten   = rb_intern("flatten");
  id_uniq_bang = rb_intern("uniq!");

  id_space      = rb_intern("SPACE");
  id_underscore = rb_intern("UNDERSCORE");

  rb_const_set(mAttributeBuilder, id_space,      rb_obj_freeze(rb_str_new_cstr(" ")));
  rb_const_set(mAttributeBuilder, id_underscore, rb_obj_freeze(rb_str_new_cstr("_")));
}
