require 'test_helper'

module Haml
  class ParserTest < MiniTest::Unit::TestCase

    test "should raise error for 'else' at wrong indent level" do
      begin
        parse("- if true\n  #first\n    text\n  - else\n    #second")
        flunk("Should have raised a Haml::SyntaxError")
      rescue SyntaxError => e
        assert_equal Error.message(:bad_script_indent, 'else', 0, 1), e.message
      end
    end

    test "should raise error for 'elsif' at wrong indent level" do
      begin
        parse("- if true\n  #first\n    text\n  - elsif false\n    #second")
        flunk("Should have raised a Haml::SyntaxError")
      rescue SyntaxError => e
        assert_equal Error.message(:bad_script_indent, 'elsif', 0, 1), e.message
      end
    end

    test "should raise error for 'else' at wrong indent level after unless" do
      begin
        parse("- unless true\n  #first\n    text\n  - else\n    #second")
        flunk("Should have raised a Haml::SyntaxError")
      rescue SyntaxError => e
        assert_equal Error.message(:bad_script_indent, 'else', 0, 1), e.message
      end
    end

    test "should raise syntax error for else with no if" do
      begin
        parse("- else\n  'foo'")
        flunk("Should have raised a Haml::SyntaxError")
      rescue SyntaxError => e
        assert_equal Error.message(:missing_if, 'else'), e.message
      end
    end

    test "should raise syntax error for nested else with no" do
      begin
        parse("#foo\n  - else\n    'foo'")
        flunk("Should have raised a Haml::SyntaxError")
      rescue SyntaxError => e
        assert_equal Error.message(:missing_if, 'else'), e.message
      end
    end

    private

    def parse(haml, options = nil)
      options ||= Options.new
      parser = Parser.new(haml, options)
      parser.parse
    end
  end
end