if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start
end

require 'rubygems'
gem "minitest"
require 'bundler/setup'
require 'minitest/autorun'
require 'action_pack'
require 'action_controller'
require 'action_view'
require 'nokogiri'

require 'rails'
class TestApp < Rails::Application
  config.root = ""
end
Rails.application = TestApp

ActionController::Base.logger = Logger.new(nil)

require 'fileutils'

$VERBOSE = true

require 'haml'
require 'haml/template'

Haml::Template.options[:ugly]   = false
Haml::Template.options[:format] = :xhtml

module Declarative
  def test(name, &block)
    define_method("test #{name}", &block)
  end
end

class MiniTest::Unit::TestCase

  extend Declarative

  def render(text, options = {}, base = nil, &block)
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    engine = Haml::Engine.new(text, options)
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
