# frozen_string_literal: true

require_relative '../test_helper'

describe 'optimization' do
  include RenderHelper

  def compiled_code(haml)
    Haml::Engine.new.call(haml)
  end

  # "fewer than RUNS objects" in an assertion reads as "no longer one per call".
  RUNS = 1000

  # The runtime path, what AttributeCompiler#runtime_compile emits for unresolvable hashes.
  def build(*hashes)
    build_as(:html, *hashes)
  end

  # Positional format: as a keyword, a bare build(href: 'x') would arrive as keywords.
  def build_as(format, *hashes)
    Haml::AttributeBuilder.build(true, '"', format, nil, *hashes)
  end

  def allocations
    GC.start
    before = GC.stat(:total_allocated_objects)
    RUNS.times { yield }
    GC.stat(:total_allocated_objects) - before
  end

  def skip_unless_cruby(subject)
    skip "#{subject} is CRuby-specific" unless RUBY_ENGINE == 'ruby'
  end

  describe 'static analysis' do
    it 'renders static value for href statically' do
      haml = %|%a{ href: 1 }|
      assert_equal true, compiled_code(haml).include?("href=\\\"1\\\"")
    end

    it 'renders html attributes statically' do
      haml = %|%span(data-boolean data-string="str")|
      assert_equal true, compiled_code(haml).include?("<span data-boolean data-string=\\\"str\\\">")
    end

    it 'renders static script statically' do
      haml = <<-HAML.unindent
        %span
          1
      HAML
      assert_equal true, compiled_code(haml).include?(%q|<span>\n1\n</span>|)
    end

    it 'renders inline static script statically' do
      haml = %|%span= 1|
      assert_equal true, compiled_code(haml).include?(%|<span>1</span>|)
    end
  end

  describe 'string interpolation' do
    it 'renders a static part of string literal statically' do
      haml = %q|%input{ value: "jruby#{9000}#{dynamic}" }|
      assert_equal true, compiled_code(haml).include?("value=\\\"jruby9000")

      haml = %q|%span= "jruby#{9000}#{dynamic}"|
      assert_equal true, compiled_code(haml).include?(%|<span>jruby9000|)
    end

    it 'optimizes script' do
      haml = %q|= "jruby#{ "#{9000}" }#{dynamic}"|
      assert_equal true, compiled_code(haml).include?(%|jruby9000|)
    end

    it 'detects a static part recursively' do
      haml = %q|%input{ value: "#{ "hello#{ hello }" }" }|
      assert_equal true, compiled_code(haml).include?("value=\\\"hello")
    end

    it 'leaves adjacent string concatenation alone' do
      assert_render(%|<span>hello world</span>\n|, %q|%span= "hello" " world"|)
    end
  end

  describe 'boolean attributes' do
    def with_custom_attributes(*attributes)
      old_attributes = Haml::BOOLEAN_ATTRIBUTES.dup
      Haml::BOOLEAN_ATTRIBUTES.push(*attributes)
      reset_boolean_attributes
      yield
    ensure
      Haml::BOOLEAN_ATTRIBUTES.replace(old_attributes)
      reset_boolean_attributes
    end

    # The Set is derived once, on first use, so a list changed after that is not picked up.
    def reset_boolean_attributes
      Haml::AttributeBuilder.instance_variable_set(:@boolean_attributes, nil)
    end

    it 'omits a known boolean attribute whose value is false or nil' do
      assert_equal ' disabled', build('disabled' => true)
      assert_equal '', build('disabled' => false)
      assert_equal '', build('disabled' => nil)
      assert_equal ' disabled="disabled"', build_as(:xhtml, 'disabled' => true)
    end

    it 'treats data- and aria- prefixed attributes as boolean' do
      assert_equal ' data-foo', build('data-foo' => true)
      assert_equal ' aria-foo', build('aria-foo' => true)
      assert_equal '', build('data-foo' => false)
      assert_equal '', build('aria-foo' => false)
    end

    it 'keeps other attributes non-boolean' do
      assert_equal ' href="true"', build('href' => true)
      assert_equal ' href="false"', build('href' => false)
      # The prefixes are anchored: only a leading data-/aria- counts.
      assert_equal ' datax="false"', build('datax' => false)
      assert_equal ' x-data-foo="false"', build('x-data-foo' => false)
    end

    it 'picks up attributes added to BOOLEAN_ATTRIBUTES before the first build' do
      assert_equal ' custom="false"', build('custom' => false)
      with_custom_attributes('custom') do
        assert_equal '', build('custom' => false)
        assert_equal ' custom', build('custom' => true)
      end
      assert_equal ' custom="false"', build('custom' => false)
    end
  end

  describe 'attribute keys' do
    it 'treats a Symbol key the same as the equivalent String key' do
      assert_equal build('href' => '/x'), build(href: '/x')
      assert_equal build('id' => 'a'),    build(id: 'a')
      assert_equal build('class' => 'a'), build(class: 'a')
      assert_equal build('data' => { 'book_id' => 5432 }), build(data: { book_id: 5432 })
      assert_equal build('aria' => { 'label' => 'x' }),    build(aria: { label: 'x' })
    end

    it 'merges Symbol and String spellings of the same key' do
      assert_equal ' href="/y"',   build({ href: '/x' }, { 'href' => '/y' })
      assert_equal ' id="a_b"',    build({ id: 'a' }, { 'id' => 'b' })
      assert_equal ' class="a b"', build({ class: 'a' }, { 'class' => 'b' })
    end

    it 'stringifies a key which is neither Symbol nor String' do
      assert_equal ' 1="2"', build(1 => 2)
    end

    it 'allocates no more for Symbol keys than for the equivalent String keys' do
      skip_unless_cruby('allocation counting')
      symbol_keys = { href: '/x', title: 't' }
      string_keys = { 'href' => '/x', 'title' => 't' }
      build(symbol_keys)
      build(string_keys)

      extra = allocations { build(symbol_keys) } - allocations { build(string_keys) }
      # Was 2 * RUNS: key.to_s allocated one String per Symbol key per build.
      assert_operator extra, :<, RUNS / 10
    end
  end

  # The nested keys of data:/aria:, hyphenated by AttributeBuilder.flatten_attributes.
  describe 'nested attribute keys' do
    it 'skips a hash which contains itself instead of recursing into it' do
      data = { a: { b: 'c' } }
      data[:d] = data
      assert_equal ' data-a-b="c"', build(data: data)

      aria = { a: { b: 'c' } }
      aria[:d] = aria
      assert_equal ' aria-a-b="c"', build(aria: aria)
    end

    it 'changes underscores in a nested key to hyphens' do
      assert_equal ' data-raw-src="foo"', build(data: { raw_src: 'foo' })
      assert_equal ' data-raw-src="foo"', build('data' => { 'raw_src' => 'foo' })
      assert_equal ' data-a-b-c="1"',     build(data: { a_b_c: 1 })
      assert_equal ' aria-raw-src="foo"', build(aria: { raw_src: 'foo' })
    end

    it 'leaves a nested key without an underscore alone' do
      assert_equal ' data-src="foo"',     build(data: { src: 'foo' })
      assert_equal ' data-raw-src="foo"', build('data' => { 'raw-src' => 'foo' })
    end

    it 'hyphenates every level of a nested hash' do
      assert_equal ' data-raw-src-url="foo"', build(data: { raw_src: { url: 'foo' } })
      assert_equal ' data-a-b-c-d="1"',       build(data: { a_b: { c_d: 1 } })
    end

    it 'keeps stringifying a nested key which is neither Symbol nor String' do
      assert_equal ' data-1="2"',    build(data: { 1 => 2 })
      assert_equal ' data-false',    build(data: { false => true })
      # A nil key names the prefix itself rather than a suffix of it.
      assert_equal ' data="3"',      build(data: { nil => 3 })
    end

    it 'allocates no more for a Symbol nested key than for the equivalent String key' do
      skip_unless_cruby('allocation counting')
      symbol_key = { 'data' => { ab: 1 } }
      string_key = { 'data' => { 'ab' => 1 } }
      build(symbol_key)
      build(string_key)

      extra = allocations { build(symbol_key) } - allocations { build(string_key) }
      # Was RUNS: k.to_s allocated one String per Symbol key per build.
      assert_operator extra, :<, RUNS / 10
    end

    it 'allocates less for a nested key with no underscore to convert' do
      skip_unless_cruby('allocation counting')
      without_underscore = { 'data' => { 'ab' => 1 } }
      with_underscore    = { 'data' => { 'a_b' => 1 } }
      build(without_underscore)
      build(with_underscore)

      saved = allocations { build(with_underscore) } - allocations { build(without_underscore) }
      # Was 0: tr allocated a String per key per build even with nothing to replace.
      assert_operator saved, :>, RUNS / 2
    end
  end
end
