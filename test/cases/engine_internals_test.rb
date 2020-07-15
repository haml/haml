
require 'cases/test_base'

class EngineInternalsTest < TestBase

  def test_multi_render
    engine = engine("%strong Hi there!")
    assert_equal("<strong>Hi there!</strong>\n", engine.to_html)
    assert_equal("<strong>Hi there!</strong>\n", engine.to_html)
    assert_equal("<strong>Hi there!</strong>\n", engine.to_html)
  end

  def test_engine_reflects_defaults
    defaults = Haml::Options.defaults.dup
    Haml::Options.defaults[:attr_wrapper] = '"'
    assert_equal %Q[<a a="a"></a>\n], Haml::Engine.new('%a(a="a")').render
  ensure
    Haml::Options.defaults.replace(defaults)
  end

  def test_engine_inspect_monkeypatch
    Tempfile.open(['haml-test', '.rb']) do |f|
      f.puts <<-HAML
        TrueClass.class_eval do
          def inspect
            "⊤"
          end
        end

        FalseClass.class_eval do
          def inspect
            "⊥"
          end
        end

        require 'haml'
        print Haml::Engine.new('%div{ foo: true, bar: false }').render
      HAML
      f.close
      out = IO.popen([RbConfig.ruby, f.path], &:read)
      assert_equal true, $?.success?
      assert_equal "<div foo></div>\n", out
    end
  end

  def test_filename_and_line
    begin
      render("\n\n = abc", :filename => 'test', :line => 2)
    rescue Exception => e
      assert_kind_of Haml::SyntaxError, e
      assert_match(/test:4/, e.backtrace.first)
    end

    begin
      render("\n\n= 123\n\n= nil[]", :filename => 'test', :line => 2)
    rescue Exception => e
      assert_kind_of NoMethodError, e
      backtrace = e.backtrace
      backtrace.shift if "rbx" == RUBY_ENGINE
      assert_match(/test:6/, backtrace.first)
    end
  end

  def test_nil_option
    assert_equal("<p foo='bar'></p>\n", render('%p{:foo => "bar"}', :attr_wrapper => nil))
    assert_equal("<p foo='bar'></p>\n", render('%p{foo: "bar"}', :attr_wrapper => nil))
  end

  def test_autoclose_option
    assert_equal("<flaz foo='bar'>\n", render("%flaz{:foo => 'bar'}", :autoclose => ["flaz"]))
    assert_equal(<<HTML, render(<<HAML, :autoclose => [/^flaz/]))
<flaz>
<flaznicate>
<flan></flan>
HTML
%flaz
%flaznicate
%flan
HAML
  end

  def test_arbitrary_output_option
    assert_raises_message(Haml::Error, "Invalid output format :html1") do
      engine("%br", :format => :html1)
    end
  end
end