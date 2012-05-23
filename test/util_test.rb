require 'test_helper'

class UtilTest < MiniTest::Unit::TestCase
  include Haml::Util

  class Dumpable
    attr_reader :arr
    def initialize; @arr = []; end
    def _before_dump; @arr << :before; end
    def _after_dump; @arr << :after; end
    def _around_dump
      @arr << :around_before
      yield
      @arr << :around_after
    end
    def _after_load; @arr << :loaded; end
  end

  def test_scope
    assert(File.exist?(scope("Rakefile")))
  end

  def test_to_hash
    assert_equal({
        :foo => 1,
        :bar => 2,
        :baz => 3
      }, to_hash([[:foo, 1], [:bar, 2], [:baz, 3]]))
  end

  def test_map_keys
    assert_equal({
        "foo" => 1,
        "bar" => 2,
        "baz" => 3
      }, map_keys({:foo => 1, :bar => 2, :baz => 3}) {|k| k.to_s})
  end

  def test_map_hash
    assert_equal({
        "foo" => "1",
        "bar" => "2",
        "baz" => "3"
      }, map_hash({:foo => 1, :bar => 2, :baz => 3}) {|k, v| [k.to_s, v.to_s]})
  end

  def test_powerset
    return unless Set[Set[]] == Set[Set[]] # There's a bug in Ruby 1.8.6 that breaks nested set equality
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

  def test_has
    assert(has?(:instance_method, String, :chomp!))
    assert(has?(:private_instance_method, Haml::Engine, :set_locals))
  end

  def test_enum_with_index
    assert_equal(%w[foo0 bar1 baz2],
      enum_with_index(%w[foo bar baz]).map {|s, i| "#{s}#{i}"})
  end

  def test_enum_cons
    assert_equal(%w[foobar barbaz],
      enum_cons(%w[foo bar baz], 2).map {|s1, s2| "#{s1}#{s2}"})
  end

  def test_ord
    assert_equal(102, ord("f"))
    assert_equal(98, ord("bar"))
  end

  def test_caller_info
    assert_equal(["/tmp/foo.rb", 12, "fizzle"], caller_info("/tmp/foo.rb:12: in `fizzle'"))
    assert_equal(["/tmp/foo.rb", 12, nil], caller_info("/tmp/foo.rb:12"))
    assert_equal(["(haml)", 12, "blah"], caller_info("(haml):12: in `blah'"))
    assert_equal(["", 12, "boop"], caller_info(":12: in `boop'"))
    assert_equal(["/tmp/foo.rb", -12, "fizzle"], caller_info("/tmp/foo.rb:-12: in `fizzle'"))
    assert_equal(["/tmp/foo.rb", 12, "fizzle"], caller_info("/tmp/foo.rb:12: in `fizzle {}'"))
  end

  def test_version_gt
    assert_version_gt("2.0.0", "1.0.0")
    assert_version_gt("1.1.0", "1.0.0")
    assert_version_gt("1.0.1", "1.0.0")
    assert_version_gt("1.0.0", "1.0.0.rc")
    assert_version_gt("1.0.0.1", "1.0.0.rc")
    assert_version_gt("1.0.0.rc", "0.9.9")
    assert_version_gt("1.0.0.beta", "1.0.0.alpha")

    assert_version_eq("1.0.0", "1.0.0")
    assert_version_eq("1.0.0", "1.0.0.0")
  end

  def assert_version_gt(v1, v2)
    #assert(version_gt(v1, v2), "Expected #{v1} > #{v2}")
    assert(!version_gt(v2, v1), "Expected #{v2} < #{v1}")
  end

  def assert_version_eq(v1, v2)
    assert(!version_gt(v1, v2), "Expected #{v1} = #{v2}")
    assert(!version_gt(v2, v1), "Expected #{v2} = #{v1}")
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
end
