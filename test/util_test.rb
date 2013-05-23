require 'test_helper'

class UtilTest < MiniTest::Unit::TestCase
  include Haml::Util

  def test_powerset
    assert_equal([[].to_set].to_set,
      powerset([]))
    assert_equal([[].to_set, [1].to_set].to_set,
      powerset([1]))
    assert_equal([[].to_set, [1].to_set, [2].to_set, [1, 2].to_set].to_set,
      powerset([1, 2]))
    assert_equal([[].to_set, [1].to_set, [2].to_set, [3].to_set,
        [1, 2].to_set, [2, 3].to_set, [1, 3].to_set, [1, 2, 3].to_set].to_set,
      powerset([1, 2, 3]))
  end

  def test_silence_warnings
    old_stderr, $stderr = $stderr, StringIO.new
    warn "Out"
    assert_equal("Out\n", $stderr.string)
    silence_warnings {warn "In"}
    assert_equal("Out\n", $stderr.string)
  ensure
    $stderr = old_stderr
  end

  def test_caller_info
    assert_equal(["/tmp/foo.rb", 12, "fizzle"], caller_info("/tmp/foo.rb:12: in `fizzle'"))
    assert_equal(["/tmp/foo.rb", 12, nil], caller_info("/tmp/foo.rb:12"))
    assert_equal(["(haml)", 12, "blah"], caller_info("(haml):12: in `blah'"))
    assert_equal(["", 12, "boop"], caller_info(":12: in `boop'"))
    assert_equal(["/tmp/foo.rb", -12, "fizzle"], caller_info("/tmp/foo.rb:-12: in `fizzle'"))
    assert_equal(["/tmp/foo.rb", 12, "fizzle"], caller_info("/tmp/foo.rb:12: in `fizzle {}'"))
  end

  def test_def_static_method
    klass = Class.new
    def_static_method(klass, :static_method, [:arg1, :arg2],
      :sarg1, :sarg2, <<RUBY)
      s = "Always " + arg1
      s << " <% if sarg1 %>and<% else %>but never<% end %> " << arg2

      <% if sarg2 %>
        s << "."
      <% end %>
RUBY
    c = klass.new
    assert_equal("Always brush your teeth and comb your hair.",
      c.send(static_method_name(:static_method, true, true),
        "brush your teeth", "comb your hair"))
    assert_equal("Always brush your teeth and comb your hair",
      c.send(static_method_name(:static_method, true, false),
        "brush your teeth", "comb your hair"))
    assert_equal("Always brush your teeth but never play with fire.",
      c.send(static_method_name(:static_method, false, true),
        "brush your teeth", "play with fire"))
    assert_equal("Always brush your teeth but never play with fire",
      c.send(static_method_name(:static_method, false, false),
        "brush your teeth", "play with fire"))
  end

  def test_check_encoding_does_not_destoy_the_given_string
    string_with_bom = File.read(File.dirname(__FILE__) + '/templates/with_bom.haml', :encoding => Encoding::UTF_8)
    original = string_with_bom.dup
    check_encoding(string_with_bom)
    assert_equal(original, string_with_bom)
  end
end
