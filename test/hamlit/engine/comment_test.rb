require 'test_helper'

class Hamlit::CommentTest < Haml::TestCase
  test 'renders html comment' do
    assert_render(<<-HAML, <<-HTML)
      / comments
    HAML
      <!-- comments -->
    HTML
  end
end
