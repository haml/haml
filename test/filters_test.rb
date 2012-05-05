# -*- coding: utf-8 -*-
require 'test_helper'

class FiltersTest < MiniTest::Unit::TestCase

  def render(text, options = {}, &block)
    scope  = options.delete(:scope)  || Object.new
    locals = options.delete(:locals) || {}
    Haml::Engine.new(text, options).to_html(scope, locals, &block)
  end

  TESTS = {
    :sass         => ["sass", /width: 100;/, ":sass\n  p\n    width: 100"],
    :scss         => ["sass", /width: 100;/, ":scss\n  $width: 100;\n  p {\n    width: $width;\n  }"],
    :less         => ["less", /width: 100;/, ":less\n  @width: 100;\n  p {\n    width: @width;\n  }"],
    :coffeescript => ["coffee_script", /var foo;/, ":coffeescript\n foo = 'bar'"],
    :maruku       => ["maruku", /h1/, ":maruku\n  # foo"],
  }

  TESTS.each do |key, value|
    library, pattern, haml = value

    define_method("test_#{key}_filter") do
      begin
        Haml::Util.silence_warnings do
          require library
          assert_match(pattern, render(haml))
        end
      rescue LoadError
        warn "Could not load #{key} filter's dependencies"
      end
    end
  end
end