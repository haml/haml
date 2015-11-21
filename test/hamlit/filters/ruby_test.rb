describe Hamlit::Filters do
  include RenderHelper

  it 'renders ruby filter' do
    assert_render(<<-HTML.unindent, <<-HAML.unindent)
      hello
    HTML
      :ruby
      hello
    HAML
  end

  it 'renders ruby filter' do
    assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
      &lt;&amp;&gt;
    HTML
      :ruby
        hash = {
          a: "#{'<&>'}",
        }
      = hash[:a]
    HAML
  end
end
