# frozen_string_literal: true

require 'test_helper'

class HelperTest < Haml::TestCase
  def test_html_escape
    assert_equal "&quot;&gt;&lt;&amp;", Haml::Helpers.html_escape('"><&')
  end

  def test_html_escape_should_work_on_frozen_strings
    assert Haml::Helpers.html_escape('foo'.freeze)
  rescue => e
    flunk e.message
  end

  def test_html_escape_encoding
    old_stderr, $stderr = $stderr, StringIO.new
    string = "\"><&\u00e9" # if you're curious, u00e9 is "LATIN SMALL LETTER E WITH ACUTE"
    assert_equal "&quot;&gt;&lt;&amp;\u00e9", Haml::Helpers.html_escape(string)
    assert $stderr.string == "", "html_escape shouldn't generate warnings with UTF-8 strings: #{$stderr.string}"
  ensure
    $stderr = old_stderr
  end

  def test_html_escape_non_string
    assert_equal('4.58', Haml::Helpers.html_escape(4.58))
  end

  def test_escape_once
    assert_equal "&quot;&gt;&lt;&amp;", Haml::Helpers.escape_once('"><&')
  end

  def test_escape_once_leaves_entity_references
    assert_equal "&quot;&gt;&lt;&amp; &nbsp;", Haml::Helpers.escape_once('"><& &nbsp;')
  end

  def test_escape_once_leaves_numeric_references
    assert_equal "&quot;&gt;&lt;&amp; &#160;", Haml::Helpers.escape_once('"><& &#160;') #decimal
    assert_equal "&quot;&gt;&lt;&amp; &#x00a0;", Haml::Helpers.escape_once('"><& &#x00a0;') #hexadecimal
  end

  def test_escape_once_encoding
    old_stderr, $stderr = $stderr, StringIO.new
    string = "\"><&\u00e9 &nbsp;"
    assert_equal "&quot;&gt;&lt;&amp;\u00e9 &nbsp;", Haml::Helpers.escape_once(string)
    assert $stderr.string == "", "html_escape shouldn't generate warnings with UTF-8 strings: #{$stderr.string}"
  ensure
    $stderr = old_stderr
  end

  def test_escape_once_should_work_on_frozen_strings
    Haml::Helpers.escape_once('foo'.freeze)
  rescue => e
    flunk e.message
  end
end
