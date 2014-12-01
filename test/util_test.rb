require 'test_helper'

class UtilTest < Haml::TestCase
  include Haml::Util

  def test_silence_warnings
    old_stderr, $stderr = $stderr, StringIO.new
    warn "Out"
    assert_equal("Out\n", $stderr.string)
    silence_warnings {warn "In"}
    assert_equal("Out\n", $stderr.string)
  ensure
    $stderr = old_stderr
  end

  def test_check_encoding_does_not_destoy_the_given_string
    string_with_bom = File.read(File.dirname(__FILE__) + '/templates/with_bom.haml', :encoding => Encoding::UTF_8)
    original = string_with_bom.dup
    check_encoding(string_with_bom)
    assert_equal(original, string_with_bom)
  end
end
