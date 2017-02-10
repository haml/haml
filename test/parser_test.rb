require 'test_helper'

module Haml
  class ParserTest < Haml::TestCase

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
    
    test "loud script with else is accepted" do
      begin
        parse "= if true\n  - 'A'\n-else\n  - 'B'"
        assert true
      rescue SyntaxError
        flunk 'loud script (=) should allow else'
      end
    end

    test "else after nested loud script is accepted" do
      begin
        parse "-if true\n  =if true\n    - 'A'\n-else\n  B"
        assert true
      rescue SyntaxError
        flunk 'else after nested loud script should be accepted'
      end
    end

    test "case with indented whens should allow else" do
      begin
        parse "- foo = 1\n-case foo\n  -when 1\n    A\n  -else\n    B"
        assert true
      rescue SyntaxError
        flunk 'case with indented whens should allow else'
      end
    end

    test "revealed conditional comments are detected" do
      text = "some revealed text"
      cond = "[cond]"

      node = parse("/!#{cond} #{text}").children[0]

      assert_equal text, node.value[:text]
      assert_equal cond, node.value[:conditional]
      assert node.value[:revealed]
    end

    test "hidden conditional comments are detected" do
      text = "some revealed text"
      cond = "[cond]"

      node = parse("/#{cond} #{text}").children[0]

      assert_equal text, node.value[:text]
      assert_equal cond, node.value[:conditional]
      refute node.value[:revealed]
    end

    test "only script lines are checked for continuation keywords" do
      haml = "- if true\n  setup\n- else\n  else\n"
      node = parse(haml).children[0]
      assert_equal(3, node.children.size)
    end

    # see #830. Strictly speaking the pipe here is not necessary, but there
    # shouldn't be an error if it is there.
    test "multiline Ruby with extra trailing pipe doesn't raise error" do
      haml = "%p= foo bar, |\n  baz"
      begin
        parse haml
      rescue Haml::SyntaxError
        flunk "Should not have raised SyntaxError"
      end
    end

    test "empty filter doesn't hide following lines" do
      root = parse "%p\n  :plain\n  %p\n"
      p_element = root.children[0]
      assert_equal 2, p_element.children.size
      assert_equal :filter, p_element.children[0].type
      assert_equal :tag, p_element.children[1].type
    end

    # Previously blocks under a haml_comment would be rejected if any line was
    # indented by a value that wasn't a multiple of the document indentation.
    test "haml_comment accepts any indentation in content" do
      begin
        parse "-\#\n  Indented two spaces\n   Indented three spaces"
      rescue Haml::SyntaxError
        flunk "haml_comment should accept any combination of indentation"
      end
    end

    test "block haml_comment includes text" do
      root = parse "-#\n  Hello\n   Hello\n"
      assert_equal "Hello\n Hello\n", root.children[0].value[:text]
    end

    test "block haml_comment includes first line if present" do
      root = parse "-# First line\n  Hello\n   Hello\n"
      assert_equal " First line\nHello\n Hello\n", root.children[0].value[:text]
    end

    private

    def parse(haml, options = nil)
      options ||= Options.new
      parser = Parser.new(options)
      parser.call(haml)
    end
  end
end
