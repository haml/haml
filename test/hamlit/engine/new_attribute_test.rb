class Hamlit::NewAttributeTest < Haml::TestCase
  test 'renders attributes' do
    assert_render(<<-HAML, <<-HTML)
      %p(class='foo') bar
    HAML
      <p class='foo'>bar</p>
    HTML
  end

  test 'renders multiple attributes' do
    assert_render(<<-HAML, <<-HTML)
      %p(a=1 b=2) bar
    HAML
      <p a='1' b='2'>bar</p>
    HTML
  end

  test 'renders multi-line attributes properly' do
    skip
    assert_render(<<-HAML, <<-HTML)
      %span(a=__LINE__
       b=__LINE__)
      = __LINE__
    HAML
      <span a='1' b='2'></span>
      3
    HTML
  end

  test 'renders hyphenated attributes properly' do
    assert_render(<<-HAML, <<-HTML)
      %p(data-foo='bar') bar
    HAML
      <p data-foo='bar'>bar</p>
    HTML
  end

  test 'renders multiply hyphenated attributes properly' do
    assert_render(<<-HAML, <<-HTML)
      %p(data-x-foo='bar') bar
    HAML
      <p data-x-foo='bar'>bar</p>
    HTML
  end

  test 'escapes attribute values on static attributes' do
    skip
    assert_render(<<-'HAML', <<-HTML)
      %a(title="'")
      %a(title = "'\"")
      %a(href='/search?foo=bar&hoge=<fuga>')
    HAML
      <a title='&#39;'></a>
      <a title='&#39;&quot;'></a>
      <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
    HTML
  end

  test 'escapes attribute values on dynamic attributes' do
    assert_render(<<-'HAML', <<-HTML)
      - title = "'\""
      - href  = '/search?foo=bar&hoge=<fuga>'
      %a(title=title)
      %a(href=href)
    HAML
      <a title='&#39;&quot;'></a>
      <a href='/search?foo=bar&amp;hoge=&lt;fuga&gt;'></a>
    HTML
  end

  test 'does not generate double classes' do
    assert_render(<<-HAML, <<-HTML)
      .item(class='first')
    HAML
      <div class='first item'></div>
    HTML
  end

  test 'does not generate double classes for a variable' do
    assert_render(<<-HAML, <<-HTML)
      - val = 'val'
      .element(class=val)
    HAML
      <div class='element val'></div>
    HTML
  end

  test 'concatenates ids with underscore' do
    assert_render(<<-HAML, <<-HTML)
      #item(id='first')
    HAML
      <div id='item_first'></div>
    HTML
  end

  test 'concatenates ids with underscore for a variable' do
    assert_render(<<-HAML, <<-HTML)
      - val = 'first'
      #item(id=val)
    HAML
      <div id='item_first'></div>
    HTML
  end
end
