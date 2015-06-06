require 'spec_helper'

describe Hamlit::Filters::Ruby do
  it 'renders ruby filter' do
    assert_render(<<-HAML, <<-HTML)
      :ruby
      hello
    HAML
      hello
    HTML
  end

  it 'renders ruby filter' do
    assert_render(<<-'HAML', <<-HTML)
      :ruby
        hash = {
          a: "#{'<&>'}",
        }
      = hash[:a]
    HAML
      &lt;&amp;&gt;
    HTML
  end
end
