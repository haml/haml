describe 'haml-spec' do
  specify %q{an XHTML XML prolog (headers)} do
    html             = %q{<?xml version='1.0' encoding='utf-8' ?>}
    haml             = %Q{!!! XML}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an XHTML default (transitional) doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">}
    haml             = %Q{!!!}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an XHTML 1.1 doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">}
    haml             = %Q{!!! 1.1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an XHTML 1.2 mobile doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">}
    haml             = %Q{!!! mobile}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an XHTML 1.1 basic doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">}
    haml             = %Q{!!! basic}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an XHTML 1.0 frameset doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">}
    haml             = %Q{!!! frameset}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 5 doctype with XHTML syntax (headers)} do
    html             = %q{<!DOCTYPE html>}
    haml             = %Q{!!! 5}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 5 XML prolog (silent) (headers)} do
    html             = %q{}
    haml             = %Q{!!! XML}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 5 doctype (headers)} do
    html             = %q{<!DOCTYPE html>}
    haml             = %Q{!!!}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 4 XML prolog (silent) (headers)} do
    html             = %q{}
    haml             = %Q{!!! XML}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html4"}
    options[:format] = 'html4'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 4 default (transitional) doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
    haml             = %Q{!!!}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html4"}
    options[:format] = 'html4'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 4 frameset doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">}
    haml             = %Q{!!! frameset}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html4"}
    options[:format] = 'html4'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an HTML 4 strict doctype (headers)} do
    html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
    haml             = %Q{!!! strict}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html4"}
    options[:format] = 'html4'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a simple Haml tag (basic Haml tags and CSS)} do
    html             = %q{<p></p>}
    haml             = %Q{%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a self-closing tag (XHTML) (basic Haml tags and CSS)} do
    html             = %q{<meta />}
    haml             = %Q{%meta}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a self-closing tag (HTML4) (basic Haml tags and CSS)} do
    html             = %q{<meta>}
    haml             = %Q{%meta}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html4"}
    options[:format] = 'html4'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a self-closing tag (HTML5) (basic Haml tags and CSS)} do
    html             = %q{<meta>}
    haml             = %Q{%meta}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a self-closing tag ('/' modifier + XHTML) (basic Haml tags and CSS)} do
    html             = %q{<zzz />}
    haml             = %Q{%zzz/}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a self-closing tag ('/' modifier + HTML5) (basic Haml tags and CSS)} do
    html             = %q{<zzz>}
    haml             = %Q{%zzz/}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with a CSS class (basic Haml tags and CSS)} do
    html             = %q{<p class='class1'></p>}
    haml             = %Q{%p.class1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with multiple CSS classes (basic Haml tags and CSS)} do
    html             = %q{<p class='class1 class2'></p>}
    haml             = %Q{%p.class1.class2}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with a CSS id (basic Haml tags and CSS)} do
    html             = %q{<p id='id1'></p>}
    haml             = %Q{%p#id1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with multiple CSS id's (basic Haml tags and CSS)} do
    html             = %q{<p id='id2'></p>}
    haml             = %Q{%p#id1#id2}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with a class followed by an id (basic Haml tags and CSS)} do
    html             = %q{<p class='class1' id='id1'></p>}
    haml             = %Q{%p.class1#id1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with an id followed by a class (basic Haml tags and CSS)} do
    html             = %q{<p class='class1' id='id1'></p>}
    haml             = %Q{%p#id1.class1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an implicit div with a CSS id (basic Haml tags and CSS)} do
    html             = %q{<div id='id1'></div>}
    haml             = %Q{#id1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an implicit div with a CSS class (basic Haml tags and CSS)} do
    html             = %q{<div class='class1'></div>}
    haml             = %Q{.class1}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{multiple simple Haml tags (basic Haml tags and CSS)} do
    html             = %q{<div>
  <div>
    <p></p>
  </div>
</div>}
    haml             = %Q{%div
  %div
    %p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with colons (tags with unusual HTML characters)} do
    html             = %q{<ns:tag></ns:tag>}
    haml             = %Q{%ns:tag}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with underscores (tags with unusual HTML characters)} do
    html             = %q{<snake_case></snake_case>}
    haml             = %Q{%snake_case}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with dashes (tags with unusual HTML characters)} do
    html             = %q{<dashed-tag></dashed-tag>}
    haml             = %Q{%dashed-tag}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with camelCase (tags with unusual HTML characters)} do
    html             = %q{<camelCase></camelCase>}
    haml             = %Q{%camelCase}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with PascalCase (tags with unusual HTML characters)} do
    html             = %q{<PascalCase></PascalCase>}
    haml             = %Q{%PascalCase}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an all-numeric class (tags with unusual CSS identifiers)} do
    html             = %q{<div class='123'></div>}
    haml             = %Q{.123}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a class with underscores (tags with unusual CSS identifiers)} do
    html             = %q{<div class='__'></div>}
    haml             = %Q{.__}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a class with dashes (tags with unusual CSS identifiers)} do
    html             = %q{<div class='--'></div>}
    haml             = %Q{.--}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Inline content simple tag (tags with inline content)} do
    html             = %q{<p>hello</p>}
    haml             = %Q{%p hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Inline content tag with CSS (tags with inline content)} do
    html             = %q{<p class='class1'>hello</p>}
    haml             = %Q{%p.class1 hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Inline content multiple simple tags (tags with inline content)} do
    html             = %q{<div>
  <div>
    <p>text</p>
  </div>
</div>}
    haml             = %Q{%div
  %div
    %p text}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Nested content simple tag (tags with nested content)} do
    html             = %q{<p>
  hello
</p>}
    haml             = %Q{%p
  hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Nested content tag with CSS (tags with nested content)} do
    html             = %q{<p class='class1'>
  hello
</p>}
    haml             = %Q{%p.class1
  hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Nested content multiple simple tags (tags with nested content)} do
    html             = %q{<div>
  <div>
    <p>
      text
    </p>
  </div>
</div>}
    haml             = %Q{%div
  %div
    %p
      text}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style one attribute (tags with HTML-style attributes)} do
    html             = %q{<p a='b'></p>}
    haml             = %Q{%p(a='b')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style multiple attributes (tags with HTML-style attributes)} do
    html             = %q{<p a='b' c='d'></p>}
    haml             = %Q{%p(a='b' c='d')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style attributes separated with newlines (tags with HTML-style attributes)} do
    html             = %q{<p a='b' c='d'></p>}
    haml             = %Q{%p(a='b'
  c='d')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style interpolated attribute (tags with HTML-style attributes)} do
    html             = %q{<p a='value'></p>}
    haml             = %Q{%p(a="#{var}")}
    locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style 'class' as an attribute (tags with HTML-style attributes)} do
    html             = %q{<p class='class1'></p>}
    haml             = %Q{%p(class='class1')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style tag with a CSS class and 'class' as an attribute (tags with HTML-style attributes)} do
    html             = %q{<p class='class1 class2'></p>}
    haml             = %Q{%p.class2(class='class1')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style tag with 'id' as an attribute (tags with HTML-style attributes)} do
    html             = %q{<p id='1'></p>}
    haml             = %Q{%p(id='1')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style tag with a CSS id and 'id' as an attribute (tags with HTML-style attributes)} do
    html             = %q{<p id='id_1'></p>}
    haml             = %Q{%p#id(id='1')}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style tag with a variable attribute (tags with HTML-style attributes)} do
    html             = %q{<p class='hello'></p>}
    haml             = %Q{%p(class=var)}
    locals           = Hash[{"var"=>"hello"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style tag with a CSS class and 'class' as a variable attribute (tags with HTML-style attributes)} do
    html             = %q{<div class='hello world'></div>}
    haml             = %Q{.hello(class=var)}
    locals           = Hash[{"var"=>"world"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{HTML-style tag multiple CSS classes (sorted correctly) (tags with HTML-style attributes)} do
    html             = %q{<div class='a z'></div>}
    haml             = %Q{.z(class=var)}
    locals           = Hash[{"var"=>"a"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style one attribute (tags with Ruby-style attributes)} do
    html             = %q{<p a='b'></p>}
    haml             = %Q{%p{:a => 'b'}}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style attributes hash with whitespace (tags with Ruby-style attributes)} do
    html             = %q{<p a='b'></p>}
    haml             = %Q{%p{  :a  =>  'b'  }}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style interpolated attribute (tags with Ruby-style attributes)} do
    html             = %q{<p a='value'></p>}
    haml             = %Q{%p{:a =>"#{var}"}}
    locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style multiple attributes (tags with Ruby-style attributes)} do
    html             = %q{<p a='b' c='d'></p>}
    haml             = %Q{%p{ :a => 'b', 'c' => 'd' }}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style attributes separated with newlines (tags with Ruby-style attributes)} do
    html             = %q{<p a='b' c='d'></p>}
    haml             = %Q{%p{ :a => 'b',
  'c' => 'd' }}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style 'class' as an attribute (tags with Ruby-style attributes)} do
    html             = %q{<p class='class1'></p>}
    haml             = %Q{%p{:class => 'class1'}}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag with a CSS class and 'class' as an attribute (tags with Ruby-style attributes)} do
    html             = %q{<p class='class1 class2'></p>}
    haml             = %Q{%p.class2{:class => 'class1'}}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag with 'id' as an attribute (tags with Ruby-style attributes)} do
    html             = %q{<p id='1'></p>}
    haml             = %Q{%p{:id => '1'}}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag with a CSS id and 'id' as an attribute (tags with Ruby-style attributes)} do
    html             = %q{<p id='id_1'></p>}
    haml             = %Q{%p#id{:id => '1'}}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag with a CSS id and a numeric 'id' as an attribute (tags with Ruby-style attributes)} do
    html             = %q{<p id='id_1'></p>}
    haml             = %Q{%p#id{:id => 1}}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag with a variable attribute (tags with Ruby-style attributes)} do
    html             = %q{<p class='hello'></p>}
    haml             = %Q{%p{:class => var}}
    locals           = Hash[{"var"=>"hello"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag with a CSS class and 'class' as a variable attribute (tags with Ruby-style attributes)} do
    html             = %q{<div class='hello world'></div>}
    haml             = %Q{.hello{:class => var}}
    locals           = Hash[{"var"=>"world"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{Ruby-style tag multiple CSS classes (sorted correctly) (tags with Ruby-style attributes)} do
    html             = %q{<div class='a z'></div>}
    haml             = %Q{.z{:class => var}}
    locals           = Hash[{"var"=>"a"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an inline silent comment (silent comments)} do
    html             = %q{}
    haml             = %Q{-# hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a nested silent comment (silent comments)} do
    html             = %q{}
    haml             = %Q{-#
  hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a multiply nested silent comment (silent comments)} do
    html             = %q{}
    haml             = %Q{-#
  %div
    foo}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a multiply nested silent comment with inconsistent indents (silent comments)} do
    html             = %q{}
    haml             = %Q{-#
  %div
      foo}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{an inline markup comment (markup comments)} do
    html             = %q{<!-- comment -->}
    haml             = %Q{/ comment}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a nested markup comment (markup comments)} do
    html             = %q{<!--
  comment
  comment2
-->}
    haml             = %Q{/
  comment
  comment2}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a conditional comment (conditional comments)} do
    html             = %q{<!--[if IE]>
  <p>a</p>
<![endif]-->}
    haml             = %Q{/[if IE]
  %p a}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in an 'escaped' filter (internal filters)} do
    html             = %q{&lt;&amp;&quot;&gt;}
    haml             = %Q{:escaped
  <&">}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in a 'preserve' filter (internal filters)} do
    html             = %q{hello&#x000A;
<p></p>}
    haml             = %Q{:preserve
  hello

%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in a 'plain' filter (internal filters)} do
    html             = %q{hello
<p></p>}
    haml             = %Q{:plain
  hello

%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in a 'css' filter (XHTML) (internal filters)} do
    html             = %q{<style type='text/css'>
  /*<![CDATA[*/
    hello
  /*]]>*/
</style>
<p></p>}
    haml             = %Q{:css
  hello

%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in a 'javascript' filter (XHTML) (internal filters)} do
    html             = %q{<script type='text/javascript'>
  //<![CDATA[
    a();
  //]]>
</script>
<p></p>}
    haml             = %Q{:javascript
  a();
%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in a 'css' filter (HTML) (internal filters)} do
    html             = %q{<style>
  hello
</style>
<p></p>}
    haml             = %Q{:css
  hello

%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{content in a 'javascript' filter (HTML) (internal filters)} do
    html             = %q{<script>
  a();
</script>
<p></p>}
    haml             = %Q{:javascript
  a();
%p}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{interpolation inside inline content (Ruby-style interpolation)} do
    html             = %q{<p>value</p>}
    haml             = %Q{%p #{var}}
    locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{no interpolation when escaped (Ruby-style interpolation)} do
    html             = %q{<p>#{var}</p>}
    haml             = %Q{%p \#{var}}
    locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{interpolation when the escape character is escaped (Ruby-style interpolation)} do
    html             = %q{<p>\value</p>}
    haml             = %Q{%p \\#{var}}
    locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{interpolation inside filtered content (Ruby-style interpolation)} do
    html             = %q{value interpolated: value}
    haml             = %Q{:plain
  #{var} interpolated: #{var}}
    locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{code following '&=' (HTML escaping)} do
    html             = %q{&lt;&quot;&amp;&gt;}
    haml             = %Q{&= '<"&>'}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{code following '=' when escape_haml is set to true (HTML escaping)} do
    html             = %q{&lt;&quot;&amp;&gt;}
    haml             = %Q{= '<"&>'}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:escape_html=>"true"}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{code following '!=' when escape_haml is set to true (HTML escaping)} do
    html             = %q{<"&>}
    haml             = %Q{!= '<"&>'}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:escape_html=>"true"}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{boolean attribute with XHTML (boolean attributes)} do
    html             = %q{<input checked='checked' />}
    haml             = %Q{%input(checked=true)}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"xhtml"}
    options[:format] = 'xhtml'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{boolean attribute with HTML (boolean attributes)} do
    html             = %q{<input checked>}
    haml             = %Q{%input(checked=true)}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {:format=>"html5"}
    options[:format] = 'html5'
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{following the '~' operator (whitespace preservation)} do
    html             = %q{Foo
<pre>Bar&#x000A;Baz</pre>}
    haml             = %Q{~ "Foo\n<pre>Bar\nBaz</pre>"}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{inside a textarea tag (whitespace preservation)} do
    html             = %q{<textarea>hello
hello</textarea>}
    haml             = %Q{%textarea
  hello
  hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{inside a pre tag (whitespace preservation)} do
    html             = %q{<pre>hello
hello</pre>}
    haml             = %Q{%pre
  hello
  hello}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with '>' appended and inline content (whitespace removal)} do
    html             = %q{<li>hello</li><li>world</li><li>again</li>}
    haml             = %Q{%li hello
%li> world
%li again}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with '>' appended and nested content (whitespace removal)} do
    html             = %q{<li>hello</li><li>
  world
</li><li>again</li>}
    haml             = %Q{%li hello
%li>
  world
%li again}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end

  specify %q{a tag with '<' appended (whitespace removal)} do
    html             = %q{<p>hello
world</p>}
    haml             = %Q{%p<
  hello
  world}
    locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
    options          = {}
    engine           = Hamlit::Template.new(options) { haml }
    result           = engine.render(Object.new, locals)
    expect(result.strip).to eq(html)
  end
end
