#include <ruby.h>
#include <ruby/encoding.h>
#ifndef TRUFFLERUBY
#include "hescape.h"
#include "string.h"

VALUE mAttributeBuilder, mObjectRef;
static ID id_flatten, id_keys, id_parse, id_prepend, id_tr, id_uniq_bang;
static ID id_xhtml;

static VALUE str_aria, str_data, str_equal, str_hyphen, str_space, str_underscore;

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

static int
str_eq(VALUE str, const char *cstr, long n)
{
  return RSTRING_LEN(str) == n && memcmp(RSTRING_PTR(str), cstr, n) == 0;
}

static VALUE
to_s(VALUE value)
{
  return rb_convert_type(value, T_STRING, "String", "to_s");
}

static VALUE
hyphenate(VALUE str)
{
  long i;

  if (OBJ_FROZEN(str)) str = rb_str_dup(str);

  for (i = 0; i < RSTRING_LEN(str); i++) {
    if (RSTRING_PTR(str)[i] == '_') {
      rb_str_update(str, i, 1, str_hyphen);
    }
  }
  return str;
}

static VALUE
escape_html(VALUE str)
{
  char *buf;
  unsigned int size;
  Check_Type(str, T_STRING);

  size = hesc_escape_html(&buf, RSTRING_PTR(str), RSTRING_LEN(str));
  if (size > RSTRING_LEN(str)) {
    str = rb_enc_str_new(buf, size, rb_utf8_encoding());
    free((void *)buf);
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
haml_build_id(VALUE escape_attrs, VALUE values)
{
  VALUE attr_value;

  values = rb_funcall(values, id_flatten, 0);
  delete_falsey_values(values);

  attr_value = rb_ary_join(values, str_underscore);
  return escape_attribute(escape_attrs, attr_value);
}

static VALUE
haml_build_single_class(VALUE escape_attrs, VALUE value)
{
  switch (TYPE(value)) {
    case T_STRING:
      break;
    case T_ARRAY:
      value = rb_funcall(value, id_flatten, 0);
      delete_falsey_values(value);
      value = rb_ary_join(value, str_space);
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
haml_build_multi_class(VALUE escape_attrs, VALUE values)
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

  rb_funcall(buf, id_uniq_bang, 0);

  return escape_attribute(escape_attrs, rb_ary_join(buf, str_space));
}

static VALUE
haml_build_class(VALUE escape_attrs, VALUE array)
{
  if (RARRAY_LEN(array) == 1) {
    return haml_build_single_class(escape_attrs, rb_ary_entry(array, 0));
  } else {
    return haml_build_multi_class(escape_attrs, array);
  }
}

struct merge_data_attrs_var {
  VALUE merged;
  VALUE key_str;
};

static int
merge_data_attrs_i(VALUE key, VALUE value, VALUE ptr)
{
  struct merge_data_attrs_var *arg = (struct merge_data_attrs_var *)ptr;
  VALUE merged = arg->merged;
  VALUE key_str = arg->key_str;

  if (NIL_P(key)) {
    rb_hash_aset(merged, key_str, value);
  } else {
    key = rb_str_concat(rb_str_concat(rb_str_dup(key_str), rb_str_new_cstr("-")), to_s(key));
    rb_hash_aset(merged, key, value);
  }
  return ST_CONTINUE;
}

static VALUE
merge_data_attrs(VALUE values, VALUE key_str)
{
  long i;
  VALUE value, merged = rb_hash_new();

  for (i = 0; i < RARRAY_LEN(values); i++) {
    struct merge_data_attrs_var arg;
    arg.merged = merged;
    arg.key_str = key_str;

    value = rb_ary_entry(values, i);
    switch (TYPE(value)) {
      case T_HASH:
        rb_hash_foreach(value, merge_data_attrs_i, (VALUE)&arg);
        break;
      default:
        rb_hash_aset(merged, key_str, value);
        break;
    }
  }
  return merged;
}

struct flatten_data_attrs_i2_arg {
  VALUE flattened;
  VALUE key;
};

static int
flatten_data_attrs_i2(VALUE k, VALUE v, VALUE ptr)
{
  VALUE key;
  struct flatten_data_attrs_i2_arg *arg = (struct flatten_data_attrs_i2_arg *)ptr;

  if (!RTEST(v)) return ST_CONTINUE;

  if (k == Qnil) {
    rb_hash_aset(arg->flattened, arg->key, v);
  } else {
    key = rb_str_dup(arg->key);
    rb_str_cat(key, "-", 1);
    rb_str_concat(key, to_s(k));

    rb_hash_aset(arg->flattened, key, v);
  }
  return ST_CONTINUE;
}

static VALUE flatten_data_attrs(VALUE attrs);

static int
flatten_data_attrs_i(VALUE key, VALUE value, VALUE flattened)
{
  struct flatten_data_attrs_i2_arg arg;
  key = hyphenate(to_s(key));

  switch (TYPE(value)) {
    case T_HASH:
      value = flatten_data_attrs(value);
      arg.key       = key;
      arg.flattened = flattened;
      rb_hash_foreach(value, flatten_data_attrs_i2, (VALUE)(&arg));
      break;
    default:
      if (RTEST(value)) rb_hash_aset(flattened, key, value);
      break;
  }
  return ST_CONTINUE;
}

static VALUE
flatten_data_attrs(VALUE attrs)
{
  VALUE flattened = rb_hash_new();
  rb_hash_foreach(attrs, flatten_data_attrs_i, flattened);

  return flattened;
}

static VALUE
haml_build_data(VALUE escape_attrs, VALUE quote, VALUE values, VALUE key_str)
{
  long i;
  VALUE attrs, buf, keys, key, value;

  attrs = merge_data_attrs(values, key_str);
  attrs = flatten_data_attrs(attrs);
  keys  = rb_ary_sort_bang(rb_funcall(attrs, id_keys, 0));
  buf   = rb_str_new("", 0);

  for (i = 0; i < RARRAY_LEN(keys); i++) {
    key   = rb_ary_entry(keys, i);
    value = rb_hash_aref(attrs, key);

    switch (value) {
      case Qtrue:
        rb_str_concat(buf, str_space);
        rb_str_concat(buf, key);
        break;
      case Qnil:
        break; // noop
      case Qfalse:
        break; // noop
      default:
        rb_str_concat(buf, str_space);
        rb_str_concat(buf, key);
        rb_str_concat(buf, str_equal);
        rb_str_concat(buf, quote);
        rb_str_concat(buf, escape_attribute(escape_attrs, to_s(value)));
        rb_str_concat(buf, quote);
        break;
    }
  }

  return buf;
}

static VALUE
parse_object_ref(VALUE object_ref)
{
  return rb_funcall(mObjectRef, id_parse, 1, object_ref);
}

static int
merge_all_attrs_i(VALUE key, VALUE value, VALUE merged)
{
  VALUE array;

  key = to_s(key);
  if (str_eq(key, "id", 2) || str_eq(key, "class", 5) || str_eq(key, "data", 4) || str_eq(key, "aria", 4)) {
    array = rb_hash_aref(merged, key);
    if (NIL_P(array)) {
      array = rb_ary_new2(1);
      rb_hash_aset(merged, key, array);
    }
    rb_ary_push(array, value);
  } else {
    rb_hash_aset(merged, key, value);
  }
  return ST_CONTINUE;
}

static VALUE
merge_all_attrs(VALUE hashes)
{
  long i;
  VALUE hash, merged = rb_hash_new();

  for (i = 0; i < RARRAY_LEN(hashes); i++) {
    hash = rb_ary_entry(hashes, i);
    if (!RB_TYPE_P(hash, T_HASH)) {
      rb_raise(rb_eArgError, "Non-hash object is given to attributes!");
    }
    rb_hash_foreach(hash, merge_all_attrs_i, merged);
  }
  return merged;
}

int
is_boolean_attribute(VALUE key, VALUE boolean_attributes)
{
  if (str_eq(rb_str_substr(key, 0, 5), "data-", 5)) return 1;
  if (str_eq(rb_str_substr(key, 0, 5), "aria-", 5)) return 1;
  return RTEST(rb_ary_includes(boolean_attributes, key));
}

void
haml_build_for_id(VALUE escape_attrs, VALUE quote, VALUE buf, VALUE values)
{
  rb_str_cat(buf, " id=", 4);
  rb_str_concat(buf, quote);
  rb_str_concat(buf, haml_build_id(escape_attrs, values));
  rb_str_concat(buf, quote);
}

void
haml_build_for_class(VALUE escape_attrs, VALUE quote, VALUE buf, VALUE values)
{
  rb_str_cat(buf, " class=", 7);
  rb_str_concat(buf, quote);
  rb_str_concat(buf, haml_build_class(escape_attrs, values));
  rb_str_concat(buf, quote);
}

void
haml_build_for_data(VALUE escape_attrs, VALUE quote, VALUE buf, VALUE values)
{
  rb_str_concat(buf, haml_build_data(escape_attrs, quote, values, str_data));
}

void
haml_build_for_aria(VALUE escape_attrs, VALUE quote, VALUE buf, VALUE values)
{
  rb_str_concat(buf, haml_build_data(escape_attrs, quote, values, str_aria));
}

void
haml_build_for_others(VALUE escape_attrs, VALUE quote, VALUE buf, VALUE key, VALUE value)
{
  rb_str_cat(buf, " ", 1);
  rb_str_concat(buf, key);
  rb_str_cat(buf, "=", 1);
  rb_str_concat(buf, quote);
  rb_str_concat(buf, escape_attribute(escape_attrs, to_s(value)));
  rb_str_concat(buf, quote);
}

void
haml_build_for_boolean(VALUE escape_attrs, VALUE quote, VALUE format, VALUE buf, VALUE key, VALUE value)
{
  switch (value) {
    case Qtrue:
      rb_str_cat(buf, " ", 1);
      rb_str_concat(buf, key);
      if ((TYPE(format) == T_SYMBOL || TYPE(format) == T_STRING) && rb_to_id(format) == id_xhtml) {
        rb_str_cat(buf, "=", 1);
        rb_str_concat(buf, quote);
        rb_str_concat(buf, key);
        rb_str_concat(buf, quote);
      }
      break;
    case Qfalse:
      break; // noop
    case Qnil:
      break; // noop
    default:
      haml_build_for_others(escape_attrs, quote, buf, key, value);
      break;
  }
}

static VALUE
haml_build(VALUE escape_attrs, VALUE quote, VALUE format, VALUE boolean_attributes, VALUE object_ref, VALUE hashes)
{
  long i;
  VALUE attrs, buf, key, keys, value;

  if (!NIL_P(object_ref)) rb_ary_push(hashes, parse_object_ref(object_ref));
  attrs = merge_all_attrs(hashes);
  buf   = rb_str_new("", 0);
  keys  = rb_ary_sort_bang(rb_funcall(attrs, id_keys, 0));

  for (i = 0; i < RARRAY_LEN(keys); i++) {
    key   = rb_ary_entry(keys, i);
    value = rb_hash_aref(attrs, key);
    if (str_eq(key, "id", 2)) {
      haml_build_for_id(escape_attrs, quote, buf, value);
    } else if (str_eq(key, "class", 5)) {
      haml_build_for_class(escape_attrs, quote, buf, value);
    } else if (str_eq(key, "data", 4)) {
      haml_build_for_data(escape_attrs, quote, buf, value);
    } else if (str_eq(key, "aria", 4)) {
      haml_build_for_aria(escape_attrs, quote, buf, value);
    } else if (is_boolean_attribute(key, boolean_attributes)) {
      haml_build_for_boolean(escape_attrs, quote, format, buf, key, value);
    } else {
      haml_build_for_others(escape_attrs, quote, buf, key, value);
    }
  }

  return buf;
}

static VALUE
rb_haml_build_id(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 1, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 1, argv + 1, "*", &array);

  return haml_build_id(argv[0], array);
}

static VALUE
rb_haml_build_class(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 1, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 1, argv + 1, "*", &array);

  return haml_build_class(argv[0], array);
}

static VALUE
rb_haml_build_aria(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 2, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 2, argv + 2, "*", &array);

  return haml_build_data(argv[0], argv[1], array, str_aria);
}

static VALUE
rb_haml_build_data(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 2, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 2, argv + 2, "*", &array);

  return haml_build_data(argv[0], argv[1], array, str_data);
}

static VALUE
rb_haml_build(int argc, VALUE *argv, RB_UNUSED_VAR(VALUE self))
{
  VALUE array;

  rb_check_arity(argc, 5, UNLIMITED_ARGUMENTS);
  rb_scan_args(argc - 5, argv + 5, "*", &array);

  return haml_build(argv[0], argv[1], argv[2], argv[3], argv[4], array);
}

void
Init_haml(void)
{
  VALUE mHaml;

  mHaml             = rb_define_module("Haml");
  mObjectRef        = rb_define_module_under(mHaml, "ObjectRef");
  mAttributeBuilder = rb_define_module_under(mHaml, "AttributeBuilder");

  rb_define_singleton_method(mAttributeBuilder, "build", rb_haml_build, -1);
  rb_define_singleton_method(mAttributeBuilder, "build_id", rb_haml_build_id, -1);
  rb_define_singleton_method(mAttributeBuilder, "build_class", rb_haml_build_class, -1);
  rb_define_singleton_method(mAttributeBuilder, "build_aria", rb_haml_build_aria, -1);
  rb_define_singleton_method(mAttributeBuilder, "build_data", rb_haml_build_data, -1);

  id_flatten   = rb_intern("flatten");
  id_keys      = rb_intern("keys");
  id_parse     = rb_intern("parse");
  id_prepend   = rb_intern("prepend");
  id_tr        = rb_intern("tr");
  id_uniq_bang = rb_intern("uniq!");
  id_xhtml     = rb_intern("xhtml");

  // Consider using rb_interned_str() once we stop supporting Ruby 2.7.
  rb_gc_register_mark_object(str_aria       = rb_obj_freeze(rb_str_new_cstr("aria")));
  rb_gc_register_mark_object(str_data       = rb_obj_freeze(rb_str_new_cstr("data")));
  rb_gc_register_mark_object(str_equal      = rb_obj_freeze(rb_str_new_cstr("=")));
  rb_gc_register_mark_object(str_hyphen     = rb_obj_freeze(rb_str_new_cstr("-")));
  rb_gc_register_mark_object(str_space      = rb_obj_freeze(rb_str_new_cstr(" ")));
  rb_gc_register_mark_object(str_underscore = rb_obj_freeze(rb_str_new_cstr("_")));
}
#endif
