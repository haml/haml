describe Hamlit::Template do
  # Simple imitation of Sinatra::Templates#compila_template
  def compile_template(engine, data, options = {})
    template = Tilt[engine]
    template.new(nil, 1, options) { data }
  end

  specify 'Tilt returns Hamlit::Template for haml engine' do
    assert_equal Hamlit::Template, Tilt[:haml]
  end

  it 'renders properly via tilt' do
    result = compile_template(:haml, %q|%p hello world|).render(Object.new, {})
    assert_equal %Q|<p>hello world</p>\n|, result
  end

  describe 'escape_attrs' do
    it 'escapes attrs by default' do
      result = compile_template(:haml, %q|%div{ data: '<script>' }|).render(Object.new, {})
      assert_equal %Q|<div data='&lt;script&gt;'></div>\n|, result
    end

    it 'can be configured not to escape attrs' do
      result = compile_template(:haml, %q|%div{ data: '<script>' }|, escape_attrs: false).render(Object.new, {})
      assert_equal %Q|<div data='<script>'></div>\n|, result
    end
  end

  describe 'escape_html' do
    it 'escapes html' do
      result = compile_template(:haml, %q|= '<script>' |).render(Object.new, {})
      assert_equal %Q|&lt;script&gt;\n|, result
    end

    it 'can be configured not to escape attrs' do
      result = compile_template(:haml, %q|= '<script>' |, escape_html: false).render(Object.new, {})
      assert_equal %Q|<script>\n|, result
    end
  end
end
