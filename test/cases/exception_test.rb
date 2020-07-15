
require 'cases/test_base'

class ExceptionTest < TestBase
  # A map of erroneous Haml documents to the error messages they should produce.
  # The error messages may be arrays;
  # if so, the second element should be the line number that should be reported for the error.
  # If this isn't provided, the tests will assume the line number should be the last line of the document.
  EXCEPTION_MAP = {
      "!!!\n  a"                                             => error(:illegal_nesting_header),
      "a\n  b"                                               => error(:illegal_nesting_plain),
      "/ a\n  b"                                             => error(:illegal_nesting_content),
      "% a"                                                  => error(:invalid_tag, '% a'),
      "%p a\n  b"                                            => error(:illegal_nesting_line, 'p'),
      "%p="                                                  => error(:no_ruby_code, '='),
      "%p~"                                                  => error(:no_ruby_code, '~'),
      "~"                                                    => error(:no_ruby_code, '~'),
      "="                                                    => error(:no_ruby_code, '='),
      "%p/\n  a"                                             => error(:illegal_nesting_self_closing),
      ":a\n  b"                                              => [error(:filter_not_defined, 'a'), 1],
      ":a= b"                                                => error(:invalid_filter_name, 'a= b'),
      "."                                                    => error(:illegal_element),
      ".#"                                                   => error(:illegal_element),
      ".{} a"                                                => error(:illegal_element),
      ".() a"                                                => error(:illegal_element),
      ".= a"                                                 => error(:illegal_element),
      "%p..a"                                                => error(:illegal_element),
      "%a/ b"                                                => error(:self_closing_content),
      " %p foo"                                              => error(:indenting_at_start),
      "  %p foo"                                             => error(:indenting_at_start),
      "- end"                                                => error(:no_end),
      "%p{:a => 'b',\n:c => 'd'}/ e"                         => [error(:self_closing_content), 2],
      "%p{:a => 'b',\n:c => 'd'}="                           => [error(:no_ruby_code, '='), 2],
      "%p.{:a => 'b',\n:c => 'd'} e"                         => [error(:illegal_element), 1],
      "%p{:a => 'b',\n:c => 'd',\n:e => 'f'}\n%p/ a"         => [error(:self_closing_content), 4],
      "%p{:a => 'b',\n:c => 'd',\n:e => 'f'}\n- raise 'foo'" => ["foo", 4],
      "%p{:a => 'b',\n:c => raise('foo'),\n:e => 'f'}"       => ["foo", 2],
      "%p{:a => 'b',\n:c => 'd',\n:e => raise('foo')}"       => ["foo", 3],
      " \n\t\n %p foo"                                       => [error(:indenting_at_start), 3],
      "\n\n %p foo"                                          => [error(:indenting_at_start), 3],
      "%p\n  foo\n foo"                                      => [error(:inconsistent_indentation, "1 space", "2 spaces"), 3],
      "%p\n  foo\n%p\n foo"                                  => [error(:inconsistent_indentation, "1 space", "2 spaces"), 4],
      "%p\n\t\tfoo\n\tfoo"                                   => [error(:inconsistent_indentation, "1 tab", "2 tabs"), 3],
      "%p\n  foo\n   foo"                                    => [error(:inconsistent_indentation, "3 spaces", "2 spaces"), 3],
      "%p\n  foo\n  %p\n   bar"                              => [error(:inconsistent_indentation, "3 spaces", "2 spaces"), 4],
      "%p\n  :plain\n     bar\n   \t  baz"                   => [error(:inconsistent_indentation, '"   \t  "', "2 spaces"), 4],
      "%p\n  foo\n%p\n    bar"                               => [error(:deeper_indenting, 2), 4],
      "%p\n  foo\n  %p\n        bar"                         => [error(:deeper_indenting, 3), 4],
      "%p\n \tfoo"                                           => [error(:cant_use_tabs_and_spaces), 2],
      "%p("                                                  => error(:invalid_attribute_list, '"("'),
      "%p(foo=)"                                             => error(:invalid_attribute_list, '"(foo=)"'),
      "%p(foo 'bar')"                                        => error(:invalid_attribute_list, '"(foo \'bar\')"'),
      "%p(foo=\nbar)"                                        => [error(:invalid_attribute_list, '"(foo="'), 1],
      "%p(foo 'bar'\nbaz='bang')"                            => [error(:invalid_attribute_list, '"(foo \'bar\'"'), 1],
      "%p(foo='bar'\nbaz 'bang'\nbip='bop')"                 => [error(:invalid_attribute_list, '"(foo=\'bar\' baz \'bang\'"'), 2],
      "%p{'foo' => 'bar' 'bar' => 'baz'}"                    => :compile,
      "%p{:foo => }"                                         => :compile,
      "%p{=> 'bar'}"                                         => :compile,
      "%p{'foo => 'bar'}"                                    => :compile,
      "%p{:foo => 'bar}"                                     => :compile,
      "%p{:foo => 'bar\"}"                                   => :compile,
      # Regression tests
      "foo\n\n\n  bar"                                       => [error(:illegal_nesting_plain), 4],
      "%p/\n\n  bar"                                         => [error(:illegal_nesting_self_closing), 3],
      "%p foo\n\n  bar"                                      => [error(:illegal_nesting_line, 'p'), 3],
      "/ foo\n\n  bar"                                       => [error(:illegal_nesting_content), 3],
      "!!!\n\n  bar"                                         => [error(:illegal_nesting_header), 3],
      "- raise 'foo'\n\n\n\nbar"                             => ["foo", 1],
      "= 'foo'\n-raise 'foo'"                                => ["foo", 2],
      "\n\n\n- raise 'foo'"                                  => ["foo", 4],
      "%p foo |\n   bar |\n   baz |\nbop\n- raise 'foo'"     => ["foo", 5],
      "foo\n:ruby\n  1\n  2\n  3\n- raise 'foo'"             => ["foo", 6],
      "foo\n:erb\n  1\n  2\n  3\n- raise 'foo'"              => ["foo", 6],
      "foo\n:plain\n  1\n  2\n  3\n- raise 'foo'"            => ["foo", 6],
      "foo\n:plain\n  1\n  2\n  3\n4\n- raise 'foo'"         => ["foo", 7],
      "foo\n:plain\n  1\n  2\n  3\#{''}\n- raise 'foo'"      => ["foo", 6],
      "foo\n:plain\n  1\n  2\n  3\#{''}\n4\n- raise 'foo'"   => ["foo", 7],
      "foo\n:plain\n  1\n  2\n  \#{raise 'foo'}"             => ["foo", 5],
      "= raise 'foo'\nfoo\nbar\nbaz\nbang"                   => ["foo", 1],
      "- case 1\n\n- when 1\n  - raise 'foo'"                => ["foo", 4],
  }.freeze

  EXCEPTION_MAP.each do |key, value|
    define_method("test_exception (#{key.inspect})") do
      begin
        silence_warnings do
          render(key, :filename => "(test_exception (#{key.inspect}))")
        end
      rescue Exception => err
        value = [value] unless value.is_a?(Array)
        expected_message, line_no = value
        line_no ||= key.split("\n").length


        if expected_message == :compile
          assert_match(/(compile error|syntax error|unterminated string|expecting)/, err.message, "Line: #{key}")
        else
          assert_equal(expected_message, err.message, "Line: #{key}")
        end

      else
        assert(false, "Exception not raised for\n#{key}")
      end
    end
  end

  def test_exception_line
    render("a\nb\n!!!\n  c\nd")
  rescue Haml::SyntaxError => e
    assert_equal("(test_exception_line):4", e.backtrace[0])
  else
    assert(false, '"a\nb\n!!!\n  c\nd" doesn\'t produce an exception')
  end

  def test_exception
    render("%p\n  hi\n  %a= undefined\n= 12")
  rescue Exception => e
    backtrace = e.backtrace
    backtrace.shift if "rbx" == RUBY_ENGINE
    assert_match("(test_exception):3", backtrace[0])
  else
    # Test failed... should have raised an exception
    assert(false)
  end

  def test_compile_error
    render("a\nb\n- fee)\nc")
  rescue Exception => e
    assert_match(/\(test_compile_error\):3:/i, e.message)
    assert_match(/(syntax error|expecting \$end)/i, e.message)
  else
    assert(false, '"a\nb\n- fee)\nc" doesn\'t produce an exception!')
  end

  def test_unbalanced_brackets
    render('foo #{1 + 5} foo #{6 + 7 bar #{8 + 9}')
  rescue Haml::SyntaxError => e
    assert_equal(Haml::Error.message(:unbalanced_brackets), e.message)
  end


  def test_render_proc_haml_buffer_gets_reset_even_with_exception
    scope = Object.new
    proc = engine("- raise Haml::Error").render_proc(scope)
    proc.call
    assert(false, "Expected exception")
  rescue Exception
    assert_nil(scope.send(:haml_buffer))
  end

  def test_haml_buffer_gets_reset_even_with_exception
    scope = Object.new
    render("- raise Haml::Error", :scope => scope)
    assert(false, "Expected exception")
  rescue Exception
    assert_nil(scope.send(:haml_buffer))
  end

  def test_def_method_haml_buffer_gets_reset_even_with_exception
    scope = Object.new
    engine("- raise Haml::Error").def_method(scope, :render)
    scope.render
    assert(false, "Expected exception")
  rescue Exception
    assert_nil(scope.send(:haml_buffer))
  end


  def test_render_proc_should_raise_haml_syntax_error_not_ruby_syntax_error
    assert_raises(Haml::SyntaxError) do
      Haml::Engine.new("%p{:foo => !}").render_proc(Object.new, :foo).call
    end
  end

  def test_render_should_raise_haml_syntax_error_not_ruby_syntax_error
    assert_raises(Haml::SyntaxError) do
      Haml::Engine.new("%p{:foo => !}").render
    end
  end

  def test_tracing
    result = render('%p{:class => "hello"}', :trace => true, :filename => 'foo').strip
    assert_equal "<p class='hello' data-trace='foo:1'></p>", result
  end

  def test_unsafe_dynamic_attribute_name_raises_invalid_attribute_name_error
    assert_raises(Haml::InvalidAttributeNameError) do
      render(<<-HAML)
- params = { 'x /><script>alert(1);</script><div x' => 'hello' }
%div{ data: params }
      HAML
    end
  end

  def test_unsafe_static_attribute_name_raises_invalid_attribute_name_error
    assert_raises(Haml::InvalidAttributeNameError) do
      render(<<-HAML)
%div{ 'x /><script>alert(1);</script><div x' => 'hello' }
      HAML
    end
  end
end