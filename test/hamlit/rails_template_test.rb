require 'haml'
require 'haml/template/plugin'
require 'hamlit/rails_template'

describe Hamlit::RailsTemplate do
  def render(haml, with: :hamlit)
    case with
    when :hamlit
      ActionView::Template.register_template_handler :haml, Hamlit::RailsTemplate.new
    else
      Haml::Template.options[:ugly] = true
      ActionView::Template.register_template_handler :haml, Haml::Plugin
    end

    base = ActionView::Base.new(__dir__, {})
    base.render(inline: haml, type: :haml)
  end

  specify 'rails rendering' do
    assert_equal %Q|<a class="bar" href="#">foo</a>\n|, render(%q|= link_to 'foo', '#', class: 'bar'|)
    assert_equal <<-HTML.unindent.strip, render(<<-HAML.unindent)
      <div>text
      </div>
    HTML
      = content_tag :div do
        text
    HAML
    assert_equal <<-HTML.unindent.strip, render(<<-HAML.unindent)
      <div>text
      </div><div>text
      </div><div>text
      </div>
    HTML
      - 3.times do
        = content_tag :div do
          text
    HAML
  end
end
