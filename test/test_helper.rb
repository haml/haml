require 'unindent'
require 'bundler/setup'
require 'minitest/autorun'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'rails'

require 'hamlit'
require 'hamlit/template'

require 'minitest/reporters'
Minitest::Reporters.use!

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

module RenderAssertion
  def assert_render(haml, html, options = {})
    options = options.dup
    options.delete(:compatible_only)
    options.delete(:error_with)
    options = { escape_html: true, ugly: true}.merge(options)
    haml, html = haml.unindent, html.unindent
    assert_equal render(haml, options), html
  end

  def render(text, options = {}, base = nil, &block)
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    engine = Hamlit::HamlEngine.new(text, options)
    return engine.to_html(base) if base
    engine.to_html(scope, locals, &block)
  end
end

class Haml::TestCase < BASE_TEST_CLASS
  extend Declarative

  def render(text, options = {}, base = nil, &block)
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    engine = Hamlit::HamlEngine.new(text, options)
    return engine.to_html(base) if base
    engine.to_html(scope, locals, &block)
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
    Haml::Util.silence_warnings(&block)
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
    Haml::Error.message(*args)
  end
end
