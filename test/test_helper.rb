require 'unindent'
require 'bundler/setup'
require 'minitest/autorun'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'rails'

require 'hamlit'
require 'haml'

# require 'minitest/reporters'
# Minitest::Reporters.use!

BASE_TEST_CLASS = if defined?(Minitest::Test)
                    Minitest::Test
                  else
                    MiniTest::Unit::TestCase
                  end

module Declarative
  def test(name, &block)
    define_method("test_ #{name}", &block)
  end
end

module RenderHelper
  def assert_render(expected, haml, options = {})
    actual = render(haml, options)
    assert_equal expected, actual
  end

  def render(haml, options = {})
    eval Hamlit::Engine.new(options).call(haml)
  end

  def assert_haml(haml, options = {})
    expected = Haml::Engine.new(haml, { escape_html: true, escape_attrs: true, ugly: true }.merge(options)).to_html
    actual = render(haml, options)
    assert_equal expected, actual
  end
end

class Haml::TestCase < BASE_TEST_CLASS
  extend Declarative

  def render(text, options = {}, base = nil, &block)
    options = { escape_html: false }.merge(options) # incompatible default
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    options.delete(:ugly)
    eval Hamlit::Engine.new(options).call(text)
  end

  def assert_render(text, options = {}, base = nil)
    haml_base = { ugly: true, escape_html: true, escape_attrs: true }
    hamlit_base = { escape_html: true }
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    haml_result   = Haml::Engine.new(text, haml_base.merge(options)).render(scope, locals)
    hamlit_result = Hamlit::Template.new(hamlit_base.merge(options)) { text }.render(scope, locals)
    assert_equal haml_result, hamlit_result
  end

  def assert_warning(message)
    the_real_stderr, $stderr = $stderr, StringIO.new
    yield

    if message.is_a?(Regexp)
      assert_match message, $stderr.string.strip
    else
      assert_equal message.strip, $stderr.string.strip
    end
  ensure
    $stderr = the_real_stderr
  end

  def silence_warnings(&block)
    Hamlit::HamlUtil.silence_warnings(&block)
  end

  def assert_raises_message(klass, message)
    yield
  rescue Exception => e
    assert_instance_of(klass, e)
    assert_equal(message, e.message)
  else
    flunk "Expected exception #{klass}, none raised"
  end

  def self.error(*args)
    Hamlit::HamlError.message(*args)
  end
end
