
require 'cases/test_base'

class ObjectReferenceTest < TestBase

  User = Struct.new('User', :id)
  CustomHamlClass = Struct.new(:id) do
    def haml_object_ref
      "my_thing"
    end
  end
  CpkRecord = Struct.new('CpkRecord', :id) do
    def to_key
      [*self.id] unless id.nil?
    end
  end

  def test_object_ref_with_nil_id
    user = User.new
    assert_equal("<p class='struct_user' id='struct_user_new'>New User</p>\n",
                 render("%p[user] New User", :locals => {:user => user}))
  end

  def test_object_ref_before_attrs
    user = User.new 42
    assert_equal("<p class='struct_user' id='struct_user_42' style='width: 100px;'>New User</p>\n",
                 render("%p[user]{:style => 'width: 100px;'} New User", :locals => {:user => user}))
  end

  def test_object_ref_with_custom_haml_class
    custom = CustomHamlClass.new 42
    assert_equal("<p class='my_thing' id='my_thing_42' style='width: 100px;'>My Thing</p>\n",
                 render("%p[custom]{:style => 'width: 100px;'} My Thing", :locals => {:custom => custom}))
  end

  def test_object_ref_with_multiple_ids
    cpk_record = CpkRecord.new([42,6,9])
    assert_equal("<p class='struct_cpk_record' id='struct_cpk_record_42_6_9' style='width: 100px;'>CPK Record</p>\n",
                 render("%p[cpk_record]{:style => 'width: 100px;'} CPK Record", :locals => {:cpk_record => cpk_record}))
  end

  def test_html_attributes_with_object_references
    foo = User.new(42)
    assert_equal("<div class='foo bar baz struct_user' id='struct_user_42'></div>\n",
                 render(".foo(class='bar'){:class => 'baz'}[foo]", :locals => {:foo => foo}))
    assert_equal("<div class='foo baz bar struct_user' id='struct_user_42'></div>\n",
                 render(".foo[foo](class='baz'){:class => 'bar'}", :locals => {:foo => foo}))
    assert_equal("<div class='foo baz bar struct_user' id='struct_user_42'></div>\n",
                 render(".foo[foo]{:class => 'bar'}(class='baz')", :locals => {:foo => foo}))

    # Test IDs too
    assert_equal("<div class='struct_user' id='foo_baz_bar_struct_user_42'></div>\n",
                 render("#foo(id='baz'){:id => 'bar'}[foo]", :locals => {:foo => foo}))
    assert_equal("<div class='struct_user' id='foo_baz_bar_struct_user_42'></div>\n",
                 render("#foo(id='baz')[foo]{:id => 'bar'}", :locals => {:foo => foo}))
    assert_equal("<div class='struct_user' id='foo_baz_bar_struct_user_42'></div>\n",
                 render("#foo[foo](id='baz'){:id => 'bar'}", :locals => {:foo => foo}))
    assert_equal("<div class='struct_user' id='foo_baz_bar_struct_user_42'></div>\n",
                 render("#foo[foo]{:id => 'bar'}(id='baz')", :locals => {:foo => foo}))
  end
end