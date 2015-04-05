require 'rails_helper'

describe 'Hamlit rails integration', type: :request do
  it 'renders views' do
    get root_path
    expect(response).to be_ok
    expect(response).to render_template('application/index')
    expect(response).to render_template('layouts/application')
    expect(response.body).to include('<span>Hamlit</span>')
  end

  it 'renders params' do
    get users_path(q: 'hello')
    expect(response.body).to include('<span>hello</span>')
  end

  it 'renders instance variable' do
    get users_path
    expect(response.body).to include('<p>k0kubun</p>')
  end

  it 'does not escape the object whose to_s returns SafeBuffer' do
    get safe_buffer_users_path
    expect(response.body).to include('<safe>')
  end

  it 'renders a complex old attributes' do
    get old_attributes_users_path
    expect(response.body).to include("<a value='foo 1'></a>")
    expect(response.body).to include("<span data-value='foo 2'></span>")
    expect(response.body).to include("<div class='foo' data-value='foo 3'></div>")
    expect(response.body).to include("<a data-value='foo 4'></a>")
    expect(response.body).to include("<a data-value='[{:count=>1}]'></a>")
  end

  describe 'escaping' do
    it 'escapes script' do
      get users_path(q: '<script>alert("a");</script>')
      expect(response.body).to include(
        '<span>&lt;script&gt;alert(&quot;a&quot;);&lt;/script&gt;</span>',
      )
    end

    it 'escapes block script' do
      get users_path(q: '<>')
      expect(response.body).to include(<<-HTML.strip_heredoc)
        <i>
        &lt;&gt;
        &lt;&gt;
        </i>
      HTML
    end
  end

  describe 'rails helpers' do
    it 'renders rails helper' do
      get users_path
      expect(response.body).to include('<a href="/">root</a>')
    end

    it 'allows capture method to work' do
      get capture_users_path
      expect(response.body).to include(<<-HTML.strip_heredoc)
        <div class='capture'><span>
        <p>Capture</p>
        </span>
        </div>
      HTML
    end

    it 'renders haml tags in the form block' do
      get form_users_path
      expect(response.body).to include('row')
    end
  end

  describe 'haml helpers' do
    it 'accepts find_and_preserve' do
      get helpers_users_path
      expect(response.body).to include(<<-HTML.strip_heredoc)
        Foo
        <pre>Bar&#x000A;Baz</pre>
      HTML
    end

    it 'accepts capture_haml' do
      get capture_users_path
      expect(response.body).to include(<<-HTML.strip_heredoc)
        <div class='capture'><span>
        <p>Capture</p>
        </span>
        </div>
      HTML
    end
  end
end
