# frozen_string_literal: true
require 'test_helper'

class FiltersTest < Haml::TestCase
  test "should be registered as filters when including Haml::Filters::Base" do
    begin
      refute Haml::Filters.defined.has_key? "bar"
      Module.new {def self.name; "Foo::Bar"; end; include Haml::Filters::Base}
      assert Haml::Filters.defined.has_key? "bar"
    ensure
      Haml::Filters.remove_filter "Bar"
    end
  end

  test "should raise error when attempting to register a defined Tilt filter" do
    begin
      assert_raises RuntimeError do
        2.times do
          Haml::Filters.register_tilt_filter "Foo"
        end
      end
    ensure
      Haml::Filters.remove_filter "Foo"
    end
  end

  test "should raise error when a Tilt filters dependencies are unavailable for extension" do
    begin
      assert_raises Haml::Error do
        # ignore warnings from Tilt
        silence_warnings do
          Haml::Filters.register_tilt_filter "Textile"
          Haml::Filters.defined["textile"].template_class
        end
      end
    ensure
      Haml::Filters.remove_filter "Textile"
    end
  end

  test "should raise error when a Tilt filters dependencies are unavailable for filter without extension" do
    begin
      assert_raises Haml::Error do
        Haml::Filters.register_tilt_filter "Maruku"
        Haml::Filters.defined["maruku"].template_class
      end
    ensure
      Haml::Filters.remove_filter "Maruku"
    end
  end

  test "should raise informative error about Maruku being moved to haml-contrib" do
    begin
      render(":maruku\n  # foo")
      flunk("Should have raised error with message about the haml-contrib gem.")
    rescue Haml::Error => e
      assert_equal e.message, Haml::Error.message(:install_haml_contrib, "maruku")
    end
  end

  test "should raise informative error about Textile being moved to haml-contrib" do
    begin
      render(":textile\n  h1. foo")
      flunk("Should have raised error with message about the haml-contrib gem.")
    rescue Haml::Error => e
      assert_equal e.message, Haml::Error.message(:install_haml_contrib, "textile")
    end
  end

  test "should respect escaped newlines and interpolation" do
    html = "\\n\n\n"
    haml = ":plain\n  \\n\#{""}"
    assert_equal(html, render(haml))
  end

  test "should process an filter with no content" do
    assert_equal("\n", render(':plain'))
  end

  test ":plain with content" do
    expectation = "foo\n"
    assert_equal(expectation, render(":plain\n  foo"))
  end

  test "should pass options to Tilt filters that precompile" do
    begin
      orig_erb_opts = Haml::Filters::Erb.options
      haml  = ":erb\n  <%= 'foo' %>"
      refute_match('test_var', Haml::Engine.new(haml).compiler.precompiled)
      Haml::Filters::Erb.options = {:outvar => 'test_var'}
      assert_match('test_var', Haml::Engine.new(haml).compiler.precompiled)
    ensure
      Haml::Filters::Erb.options = orig_erb_opts
    end
  end

  test "should pass options to Tilt filters that don't precompile" do
    begin
      filter = Class.new(Tilt::Template) do
        def self.name
          "Foo"
        end

        def prepare
          @engine = {:data => data, :options => options}
        end

        def evaluate(scope, locals, &block)
          @output = @engine[:options].to_a.join
        end
      end
      Haml::Filters.register_tilt_filter "Foo", :template_class => filter
      Haml::Filters::Foo.options[:foo] = "bar"
      haml = ":foo"
      assert_equal "foobar\n", render(haml)
    ensure
      Haml::Filters.remove_filter "Foo"
    end
  end

  test "interpolated code should be escaped if escape_html is set" do
    assert_equal "&lt;script&gt;evil&lt;/script&gt;\n\n",
                 render(":plain\n  \#{'<script>evil</script>'}", :escape_html => true)
  end

end

class ErbFilterTest < Haml::TestCase
  test "multiline expressions should work" do
    html = "foobarbaz\n\n"
    haml = %Q{:erb\n  <%= "foo" +\n      "bar" +\n      "baz" %>}
    assert_equal(html, render(haml))
  end

  test "should evaluate in the same context as Haml" do
    haml  = ":erb\n  <%= foo %>"
    html  = "bar\n\n"
    scope = Object.new.instance_eval {foo = "bar"; nil if foo; binding}
    assert_equal(html, render(haml, :scope => scope))
  end

end

class JavascriptFilterTest < Haml::TestCase
  test "should interpolate" do
    scope = Object.new.instance_eval {foo = "bar"; nil if foo; binding}
    haml  = ":javascript\n  \#{foo}"
    html  = render(haml, :scope => scope)
    assert_match(/bar/, html)
  end

  test "should never HTML-escape non-interpolated ampersands" do
    html = "<script>\n  & < > &amp;\n</script>\n"
    haml = %Q{:javascript\n  & < > \#{"&"}}
    assert_equal(html, render(haml, :escape_html => true))
  end

  test "should not include type in HTML 5 output" do
    html = "<script>\n  foo bar\n</script>\n"
    haml = ":javascript\n  foo bar"
    assert_equal(html, render(haml, :format => :html5))
  end

  test "should always include CDATA when format is xhtml" do
    html = "<script type='text/javascript'>\n  //<![CDATA[\n    foo bar\n  //]]>\n</script>\n"
    haml = ":javascript\n  foo bar"
    assert_equal(html, render(haml, :format => :xhtml, :cdata => false))
  end

  test "should omit CDATA when cdata option is false" do
    html = "<script>\n  foo bar\n</script>\n"
    haml = ":javascript\n  foo bar"
    assert_equal(html, render(haml, :format => :html5, :cdata => false))
  end

  test "should include CDATA when cdata option is true" do
    html = "<script>\n  //<![CDATA[\n    foo bar\n  //]]>\n</script>\n"
    haml = ":javascript\n  foo bar"
    assert_equal(html, render(haml, :format => :html5, :cdata => true))
  end

  test "should default to no CDATA when format is html5" do
    haml = ":javascript\n  foo bar"
    out = render(haml, :format => :html5)
    refute_match('//<![CDATA[', out)
    refute_match('//]]>', out)
  end

  test "should emit tag on empty block" do
    html = "<script>\n  \n</script>\n"
    haml = ":javascript"
    assert_equal(html, render(haml))
  end
end

class CSSFilterTest < Haml::TestCase
  test "should wrap output in CDATA and a CSS tag when output is XHTML" do
    html = "<style type='text/css'>\n  /*<![CDATA[*/\n    foo\n  /*]]>*/\n</style>\n"
    haml = ":css\n  foo"
    assert_equal(html, render(haml, :format => :xhtml))
  end

  test "should not include type in HTML 5 output" do
    html = "<style>\n  foo bar\n</style>\n"
    haml = ":css\n  foo bar"
    assert_equal(html, render(haml, :format => :html5))
  end

  test "should always include CDATA when format is xhtml" do
    html = "<style type='text/css'>\n  /*<![CDATA[*/\n    foo bar\n  /*]]>*/\n</style>\n"
    haml = ":css\n  foo bar"
    assert_equal(html, render(haml, :format => :xhtml, :cdata => false))
  end

  test "should omit CDATA when cdata option is false" do
    html = "<style>\n  foo bar\n</style>\n"
    haml = ":css\n  foo bar"
    assert_equal(html, render(haml, :format => :html5, :cdata => false))
  end

  test "should include CDATA when cdata option is true" do
    html = "<style>\n  /*<![CDATA[*/\n    foo bar\n  /*]]>*/\n</style>\n"
    haml = ":css\n  foo bar"
    assert_equal(html, render(haml, :format => :html5, :cdata => true))
  end

  test "should default to no CDATA when format is html5" do
    haml = ":css\n  foo bar"
    out = render(haml, :format => :html5)
    refute_match('<![CDATA[', out)
    refute_match(']]>', out)
  end

  test "should emit tag on empty block" do
    html = "<style>\n  \n</style>\n"
    haml = ":css"
    assert_equal(html, render(haml))
  end
end

class CDATAFilterTest < Haml::TestCase
  test "should wrap output in CDATA tag" do
    html = "<![CDATA[\n    foo\n]]>\n"
    haml = ":cdata\n  foo"
    assert_equal(html, render(haml))
  end
end

class EscapedFilterTest < Haml::TestCase
  test "should escape ampersands" do
    html = "&amp;\n"
    haml = ":escaped\n  &"
    assert_equal(html, render(haml))
  end
end

class RubyFilterTest < Haml::TestCase
  test "can write to haml_io" do
    haml = ":ruby\n  haml_io.puts 'hello'\n"
    html = "hello\n"
    assert_equal(html, render(haml))
  end

  test "haml_io appends to output" do
    haml = "hello\n:ruby\n  haml_io.puts 'hello'\n"
    html = "hello\nhello\n"
    assert_equal(html, render(haml))
  end

  test "can create local variables" do
    haml = ":ruby\n  a = 7\n=a"
    html = "7\n"
    assert_equal(html, render(haml))
  end

  test "can render empty filter" do
    haml = ":ruby\n%foo"
    html = "<foo></foo>\n"
    assert_equal(html, render(haml))
  end
end
