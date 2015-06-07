require 'haml'
require 'faml'
require 'hamlit'
require 'unindent'

module HamlitSpecHelper
  DEFAULT_OPTIONS = { ugly: true, escape_html: true }.freeze

  def parse_string(str)
    Hamlit::Parser.new.call(str)
  end

  def render_string(str, options = {})
    eval Hamlit::Engine.new(options).call(str)
  end

  def assert_render(haml, html, options = {})
    errs  = array_wrap(options.delete(:error_with) || [])
    impls = array_wrap(options.delete(:compatible_with) || [:haml, :faml] - errs)
    haml  = haml.unindent
    html  = html.unindent

    expect(render_string(haml, options)).to eq(html)
    impls.each do |impl|
      expect_compatibility(impl, haml, options)
    end
    errs.each do |impl|
      expect_compatibility(impl, haml, options, type: :error)
    end
    ([:haml, :faml] - impls - errs).each do |impl|
      expect_compatibility(impl, haml, options, type: :failure)
    end
  end

  def assert_parse(haml, &block)
    haml = haml.unindent
    ast  = block.call

    expect(parse_string(haml)).to eq(ast)
  end

  def assert_compile(before, after)
    result = described_class.new.call(before)
    expect(result).to eq(after)
  end

  private

  def expect_compatibility(impl, haml, options, type: :success)
    case impl
    when :haml
      expect_haml(haml, options, type: type)
    when :faml
      expect_faml(haml, options, type: type)
    end
  end

  def expect_faml(haml, options, type: :success)
    hamlit_html = render_string(haml, options)
    options = options.dup
    options.delete(:escape_html)

    case type
    when :success
      faml_html = eval Faml::Engine.new(options).call(haml)
      expect(hamlit_html).to eq(faml_html)
    when :failure
      faml_html = eval Faml::Engine.new(options).call(haml)
      expect(hamlit_html).to_not eq(faml_html)
    when :error
      expect {
        eval Faml::Engine.new(options).call(haml)
      }.to raise_error
    end
  end

  def expect_haml(haml, options, type: :success)
    hamlit_html = render_string(haml, options)
    options = DEFAULT_OPTIONS.merge(options)
    case type
    when :success
      haml_html = Haml::Engine.new(haml, options).render(Object.new, {})
      expect(hamlit_html).to eq(haml_html)
    when :failure
      haml_html = Haml::Engine.new(haml, options).render(Object.new, {})
      expect(hamlit_html).to_not eq(haml_html)
    when :error
      expect {
        Haml::Engine.new(haml, options).render(Object.new, {})
      }.to raise_error
    end
  end

  def array_wrap(arr)
    return arr if arr.is_a?(Array)
    [arr]
  end
end

RSpec.configure do |config|
  config.include HamlitSpecHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
