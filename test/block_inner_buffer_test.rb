require 'test_helper'

class BlockInnerBufferTest < Haml::TestCase
  def test_block_inner_buffer
    haml = clean_space <<-HAML
    Hello
    = simple_tag('em') do
      = 'World'.upcase
    !!
    HAML

    assert_equal "Hello\n<em>WORLD\n</em>\n!!\n", render(haml, {}, TestContext.new)
  end

  def clean_space(str)
    str.gsub /^#{str.scan(/^\s+/).min}/, ''
  end

  class TestContext
    def simple_tag(tag)
      "<#{tag}>#{yield}</#{tag}>"
    end
  end
end
