
require_relative '../test_helper'

class TestBase < Haml::TestCase
  def setup
    @old_default_internal = Encoding.default_internal
    silence_warnings{Encoding.default_internal = nil}
  end

  def teardown
    silence_warnings{Encoding.default_internal = @old_default_internal}
  end

  def render(text, options = {}, &block)
    options = use_test_tracing(options)
    super
  end

  def engine(text, options = {})
    options = use_test_tracing(options)
    Haml::Engine.new(text, options)
  end

  def use_test_tracing(options)
    unless options[:filename]
      # use caller method name as fake filename. useful for debugging
      i = -1
      caller[i+=1] =~ /`(.+?)'/ until $1 and $1.index('test_') == 0
      options[:filename] = "(#{$1})"
    end
    options
  end
end