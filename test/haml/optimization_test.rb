# frozen_string_literal: true

require_relative '../test_helper'

describe 'optimization' do
  include RenderHelper

  def compiled_code(haml, options = {})
    Haml::Engine.new(options).call(haml)
  end

  # Mirrors Haml::RailsTemplate.options without depending on the railtie being loaded.
  def rails_compiled_code(haml)
    compiled_code(haml, {
      generator:       Temple::Generators::RailsOutputBuffer,
      use_html_safe:   true,
      buffer_class:    'ActionView::OutputBuffer',
      disable_capture: true,
    })
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

  describe 'to_s' do
    it 'emits a single to_s per dynamic output' do
      assert_equal 1, compiled_code(%|%p= @content|).scan('.to_s').size
      assert_equal 1, compiled_code(%|%p!= @content|).scan('.to_s').size
    end

    it 'emits a single to_s per dynamic output in rails mode' do
      code = rails_compiled_code(%|%p= @content|)
      assert_equal true, code.include?('safe_concat')
      assert_equal 1, code.scan('.to_s').size
    end

    it 'does not append to_s to an interpolated attribute value' do
      code = compiled_code(<<-HAML.unindent)
        - href = 1
        %a{ href: href }
      HAML
      assert_equal true, code.include?('#{::Haml::Util.escape_html((href))}')
    end

    it 'appends to_s only to :escapeany nodes' do
      filter = Haml::EscapeAny.new(use_html_safe: false)
      assert_equal [:dynamic, '::Haml::Util.escape_html((foo))'],
                   filter.call([:escapeany, true, [:dynamic, 'foo']])
      assert_equal [:dynamic, '(foo).to_s'],
                   filter.call([:escapeany, false, [:dynamic, 'foo']])
      # An already-escaped node, i.e. what the Escape pass leaves behind.
      assert_equal [:dynamic, '::Haml::Util.escape_html((foo))'],
                   filter.call([:dynamic, '::Haml::Util.escape_html((foo))'])
    end

    it 'still stringifies values which are not String' do
      assert_render(%|<p>1/1</p>\n|, %|%p= 1.to_r|)
      assert_render(%|<p>1/1</p>\n|, %|%p!= 1.to_r|)
      assert_render(%|1/1\n|, %|!= 1.to_r|)
      assert_render(%|<a href="1/1"></a>\n|, %Q|- href = 1.to_r\n%a{ href: href }|)
    end
  end

  # The runtime path: what AttributeCompiler#runtime_compile emits for hashes it cannot
  # resolve at compile time.
  describe 'boolean attributes' do
    def build(hash, format = :html)
      Haml::AttributeBuilder.build(true, '"', format, nil, hash)
    end

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
      assert_equal ' disabled="disabled"', build({ 'disabled' => true }, :xhtml)
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
