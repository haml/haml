# frozen_string_literal: true

require_relative '../test_helper'

describe 'optimization' do
  include RenderHelper

  def compiled_code(haml)
    Haml::Engine.new.call(haml)
  end

  # The runtime path, what AttributeCompiler#runtime_compile emits for unresolvable hashes.
  def build(*hashes)
    build_as(:html, *hashes)
  end

  # Positional format: as a keyword, a bare build(href: 'x') would arrive as keywords.
  def build_as(format, *hashes)
    Haml::AttributeBuilder.build(true, '"', format, nil, *hashes)
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
      yield
    ensure
      Haml::BOOLEAN_ATTRIBUTES.replace(old_attributes)
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

    it 'picks up attributes added to BOOLEAN_ATTRIBUTES after the first build' do
      assert_equal ' custom="false"', build('custom' => false)
      with_custom_attributes('custom') do
        assert_equal '', build('custom' => false)
        assert_equal ' custom', build('custom' => true)
      end
      assert_equal ' custom="false"', build('custom' => false)
    end
  end
end
