# frozen_string_literal: true

describe Haml::RubyExpression do
  describe '.syntax_error?' do
    it { assert_equal(true,  Haml::RubyExpression.syntax_error?('{ hash }')) }
    it { assert_equal(false, Haml::RubyExpression.syntax_error?('{ a: b }')) }

    describe 'invalid expressions' do
      it { assert_equal(true, Haml::RubyExpression.syntax_error?(%q|"]|)) }
      it { assert_equal(true, Haml::RubyExpression.syntax_error?(%Q|'' \\ \n ''|)) }
    end
  end

  describe '.string_literal?' do
    def assert_literal(expected, code)
      actual = Haml::RubyExpression.string_literal?(code)
      assert_equal expected, actual
    end

    describe 'invalid expressions' do
      it { assert_literal(false, %q|{ hash }|) }
      it { assert_literal(false, %q|"hello".|) }
    end

    describe 'string literal' do
      it { assert_literal(true, %q|''|) }
      it { assert_literal(true, %q|""|) }
      it { assert_literal(true, %Q|'\n'|) }
      it { assert_literal(true, %q|'';   |) }
      it { assert_literal(true, %q|  ""  |) }
      it { assert_literal(true, %q|'hello world'|) }
      it { assert_literal(true, %q|"hello world"|) }
      it { assert_literal(true, %q|"h#{ %Q[e#{ "llo wor" }l] }d"|) }
      it { assert_literal(true, %q|%Q[nya]|) }
      it { assert_literal(true, %q|%Q[#{123}]|) }
      it { assert_literal(true, %q|%q(nya)|) }
      it { assert_literal(true, %q|%(nya)|) }
      it { assert_literal(true, %Q|<<~TEXT\n  nya\nTEXT|) }
    end

    describe 'not string literal' do
      it { assert_literal(false, %q|123|) }
      it { assert_literal(false, %q|'hello' + ''|) }
      it { assert_literal(false, %q|'hello'.to_s|) }
      it { assert_literal(false, %Q|'' \\ \n ''|) }
      it { assert_literal(false, %q|['']|) }
      it { assert_literal(false, %q|return ''|) }
      it { assert_literal(false, %q|:hello|) }
      it { assert_literal(false, %q|:"hello#{ world }"|) }
      it { assert_literal(false, %q|/hello/|) }
      it { assert_literal(false, %q|`hello`|) }
    end

    # The two cases below are a single String node for Prism, but neither has one
    # pair of quotes wrapping the whole expression for StringSplitter to split on.
    describe 'character literal' do
      it { assert_literal(false, %q|?a|) }
    end

    describe 'adjacent string concatenation' do
      it { assert_literal(false, %q|"hello" "world"|) }
      it { assert_literal(false, %q|"hello#{ world }" "!"|) }
    end

    describe 'multiple instructions' do
      it { assert_literal(false, %Q|''\n''|) }
    end
  end

  describe '.string_literal_node' do
    it { assert_kind_of(Prism::StringNode, Haml::RubyExpression.string_literal_node(%q|'nya'|)) }
    it { assert_kind_of(Prism::InterpolatedStringNode, Haml::RubyExpression.string_literal_node(%q|"n#{y}a"|)) }
    it { assert_nil(Haml::RubyExpression.string_literal_node(%q|?a|)) }
    it { assert_nil(Haml::RubyExpression.string_literal_node(%q|123|)) }

    # StringSplitter slices the code with this node's offsets, so they must not be shifted.
    it 'locates the literal in the code as given' do
      node = Haml::RubyExpression.string_literal_node(%q|  "nya"  |)
      assert_equal(%q|"nya"|, node.slice)
    end
  end
end
