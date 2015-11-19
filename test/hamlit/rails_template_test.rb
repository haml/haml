require 'haml'
require 'haml/template/plugin'
require 'hamlit/rails_template'

describe Hamlit::RailsTemplate do
  def render(haml, with: :hamlit)
    case with
    when :hamlit
      ActionView::Template.register_template_handler :haml, Hamlit::RailsTemplate.new
    else
      ActionView::Template.register_template_handler :haml, Haml::Plugin
    end

    base = ActionView::Base.new(__dir__, {})
    base.render(inline: haml, type: :haml)
  end

  def assert_render(haml)
    assert_equal render(haml, with: :haml), render(haml, with: :hamlit)
  end

  specify 'rails rendering' do
    assert_render(%q|= link_to 'foo', '#', class: 'bar'|)
  end
end
