require 'haml'
require 'faml'
require 'hamlit'
require 'unindent'

module RenderHelper
  DEFAULT_OPTIONS = { ugly: true, escape_html: true }.freeze

  def parse_string(str)
    Hamlit::Parser.new.call(str)
  end

  def render_string(str, options = {})
    eval Hamlit::Engine.new(options).call(str)
  end

  def assert_render(haml, html, options = {})
    errs  = array_wrap(options.delete(:error_with) || [])
    impls = array_wrap(options.delete(:compatible_only) || [:haml, :faml] - errs)
    fails = [:haml, :faml] - impls - errs

    test = TestCase.new
    test.src_haml = haml.unindent
    test.hamlit_html = html.unindent

    expect(render_string(test.src_haml, options)).to eq(test.hamlit_html)
    impls.each { |i| expect_compatibility(i, test, options) }
    errs.each  { |i| expect_compatibility(i, test, options, type: :error) }
    fails.each { |i| expect_compatibility(i, test, options, type: :failure) }

    if DocumentGenerator.generate_docs? && (errs.any? || fails.any?)
      write_caller!(test)
      DocumentGenerator.register_test!(test)
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

  def write_caller!(test)
    example = RSpec.current_example
    test.lineno = example.metadata[:line_number]
    test.dir, test.file = example.file_path.gsub(%r{^.+spec/hamlit/}, '').split('/')
  end

  def expect_compatibility(impl, test, options, type: :success)
    case impl
    when :haml
      expect_haml(impl, test, options, type)
    when :faml
      expect_faml(impl, test, options, type)
    end
  end

  def expect_haml(impl, test, options, type)
    expect_implementation(impl, test, options, type) do |test, options|
      options = DEFAULT_OPTIONS.merge(options)
      Haml::Engine.new(test.src_haml, options).render(Object.new, {})
    end
  end

  def expect_faml(impl, test, options, type)
    expect_implementation(impl, test, options, type) do |test, options|
      options = options.dup
      options.delete(:escape_html)
      eval Faml::Engine.new(options).call(test.src_haml)
    end
  end

  def expect_implementation(impl, test, options, type, &block)
    if type == :error
      expect { block.call(test, options) }.to raise_error
      begin
        block.call(test, options)
      rescue Exception => e
        err = "#{e.class}: #{e.message}"
        test.send(:"#{impl}_html=", err)
      end
      return
    end

    result = block.call(test, options)
    test.send(:"#{impl}_html=", result)

    case type
    when :success
      expect(test.hamlit_html).to eq(result)
    when :failure
      expect(test.hamlit_html).to_not eq(result)
    end
  end

  def array_wrap(arr)
    return arr if arr.is_a?(Array)
    [arr]
  end

  def tests
    @tests ||= []
  end
end
