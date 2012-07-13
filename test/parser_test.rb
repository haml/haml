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

    test "else after if containing case is accepted" do
      # see issue 572
      begin
        parse "- if true\n  - case @foo\n  - when 1\n    bar\n- else\n  bar"
        assert true
      rescue SyntaxError
        flunk 'else clause after if containing case should be accepted'
      end
    end

    test "else after if containing unless is accepted" do
      begin
        parse "- if true\n  - unless @foo\n  bar\n- else\n  bar"
        assert true
      rescue SyntaxError
        flunk 'else clause after if containing unless should be accepted'
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