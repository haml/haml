require 'rails_helper'

describe UsersController, type: :request do
  describe '#index' do
    it 'renders params' do
      get users_path(q: 'hello')
      expect(response.body).to include('<span>hello</span>')
    end

    it 'escapes script' do
      get users_path(q: '<script>alert("a");</script>')
      expect(response.body).to include(
        '<span>&lt;script&gt;alert(&quot;a&quot;);&lt;/script&gt;</span>',
      )
    end

    it 'descapes block script' do
      get users_path(q: '<>')
      expect(response.body).to include(<<-HTML.strip_heredoc)
        <i>
        &lt;&gt;
        &lt;&gt;
        </i>
      HTML
    end

    it 'renders instance variable' do
      get users_path
      expect(response.body).to include('<p>k0kubun</p>')
    end

    it 'renders rails helper' do
      get users_path
      expect(response.body).to include('<a href="/">root</a>')
    end
  end

  describe '#capture' do
    it 'allows capture method to work' do
      get capture_users_path
      expect(response.body).to include(<<-HTML.strip_heredoc)
        <div class='capture'><span>
        <p>Capture</p>
        </span>
        </div>
      HTML
    end
  end

  describe '#form' do
    it 'renders haml tags in the form block' do
      get form_users_path
      expect(response.body).to include('row')
    end
  end

  describe '#helpers' do
    it 'accepts find_and_preserve' do
      get helpers_users_path
      expect(response.body).to include(<<-HTML.strip_heredoc)
        Foo
        <pre>Bar&#x000A;Baz</pre>
      HTML
    end
  end
end
