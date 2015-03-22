describe 'haml-spec' do
  context "headers" do
    specify "an XHTML XML prolog" do
      html             = %q{<?xml version='1.0' encoding='utf-8' ?>}
      haml             = %q{!!! XML}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an XHTML default (transitional) doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">}
      haml             = %q{!!!}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an XHTML 1.1 doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">}
      haml             = %q{!!! 1.1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an XHTML 1.2 mobile doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">}
      haml             = %q{!!! mobile}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an XHTML 1.1 basic doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">}
      haml             = %q{!!! basic}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an XHTML 1.0 frameset doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">}
      haml             = %q{!!! frameset}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 5 doctype with XHTML syntax" do
      html             = %q{<!DOCTYPE html>}
      haml             = %q{!!! 5}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 5 XML prolog (silent)" do
      html             = %q{}
      haml             = %q{!!! XML}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 5 doctype" do
      html             = %q{<!DOCTYPE html>}
      haml             = %q{!!!}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 4 XML prolog (silent)" do
      html             = %q{}
      haml             = %q{!!! XML}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html4"}
      options[:format] = :html4
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 4 default (transitional) doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
      haml             = %q{!!!}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html4"}
      options[:format] = :html4
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 4 frameset doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">}
      haml             = %q{!!! frameset}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html4"}
      options[:format] = :html4
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an HTML 4 strict doctype" do
      html             = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
      haml             = %q{!!! strict}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html4"}
      options[:format] = :html4
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "basic Haml tags and CSS" do
    specify "a simple Haml tag" do
      html             = %q{<p></p>}
      haml             = %q{%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a self-closing tag (XHTML)" do
      html             = %q{<meta />}
      haml             = %q{%meta}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a self-closing tag (HTML4)" do
      html             = %q{<meta>}
      haml             = %q{%meta}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html4"}
      options[:format] = :html4
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a self-closing tag (HTML5)" do
      html             = %q{<meta>}
      haml             = %q{%meta}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a self-closing tag ('/' modifier + XHTML)" do
      html             = %q{<zzz />}
      haml             = %q{%zzz/}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a self-closing tag ('/' modifier + HTML5)" do
      html             = %q{<zzz>}
      haml             = %q{%zzz/}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with a CSS class" do
      html             = %q{<p class='class1'></p>}
      haml             = %q{%p.class1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with multiple CSS classes" do
      html             = %q{<p class='class1 class2'></p>}
      haml             = %q{%p.class1.class2}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with a CSS id" do
      html             = %q{<p id='id1'></p>}
      haml             = %q{%p#id1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with multiple CSS id's" do
      html             = %q{<p id='id2'></p>}
      haml             = %q{%p#id1#id2}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with a class followed by an id" do
      html             = %q{<p class='class1' id='id1'></p>}
      haml             = %q{%p.class1#id1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with an id followed by a class" do
      html             = %q{<p class='class1' id='id1'></p>}
      haml             = %q{%p#id1.class1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an implicit div with a CSS id" do
      html             = %q{<div id='id1'></div>}
      haml             = %q{#id1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "an implicit div with a CSS class" do
      html             = %q{<div class='class1'></div>}
      haml             = %q{.class1}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "multiple simple Haml tags" do
      html             = %q{<div>
  <div>
    <p></p>
  </div>
</div>}
      haml             = %q{%div
  %div
    %p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "tags with unusual HTML characters" do
    specify "a tag with colons" do
      html             = %q{<ns:tag></ns:tag>}
      haml             = %q{%ns:tag}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with underscores" do
      html             = %q{<snake_case></snake_case>}
      haml             = %q{%snake_case}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with dashes" do
      html             = %q{<dashed-tag></dashed-tag>}
      haml             = %q{%dashed-tag}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with camelCase" do
      html             = %q{<camelCase></camelCase>}
      haml             = %q{%camelCase}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with PascalCase" do
      html             = %q{<PascalCase></PascalCase>}
      haml             = %q{%PascalCase}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "tags with unusual CSS identifiers" do
    specify "an all-numeric class" do
      html             = %q{<div class='123'></div>}
      haml             = %q{.123}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a class with underscores" do
      html             = %q{<div class='__'></div>}
      haml             = %q{.__}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a class with dashes" do
      html             = %q{<div class='--'></div>}
      haml             = %q{.--}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "tags with inline content" do
    specify "Inline content simple tag" do
      html             = %q{<p>hello</p>}
      haml             = %q{%p hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Inline content tag with CSS" do
      html             = %q{<p class='class1'>hello</p>}
      haml             = %q{%p.class1 hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Inline content multiple simple tags" do
      html             = %q{<div>
  <div>
    <p>text</p>
  </div>
</div>}
      haml             = %q{%div
  %div
    %p text}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "tags with nested content" do
    specify "Nested content simple tag" do
      html             = %q{<p>
  hello
</p>}
      haml             = %q{%p
  hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Nested content tag with CSS" do
      html             = %q{<p class='class1'>
  hello
</p>}
      haml             = %q{%p.class1
  hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Nested content multiple simple tags" do
      html             = %q{<div>
  <div>
    <p>
      text
    </p>
  </div>
</div>}
      haml             = %q{%div
  %div
    %p
      text}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "tags with HTML-style attributes" do
    specify "HTML-style one attribute" do
      html             = %q{<p a='b'></p>}
      haml             = %q{%p(a='b')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style multiple attributes" do
      html             = %q{<p a='b' c='d'></p>}
      haml             = %q{%p(a='b' c='d')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style attributes separated with newlines" do
      html             = %q{<p a='b' c='d'></p>}
      haml             = %q{%p(a='b'
  c='d')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style interpolated attribute" do
      html             = %q{<p a='value'></p>}
      haml             = %q{%p(a="#{var}")}
      locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style 'class' as an attribute" do
      html             = %q{<p class='class1'></p>}
      haml             = %q{%p(class='class1')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style tag with a CSS class and 'class' as an attribute" do
      html             = %q{<p class='class1 class2'></p>}
      haml             = %q{%p.class2(class='class1')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style tag with 'id' as an attribute" do
      html             = %q{<p id='1'></p>}
      haml             = %q{%p(id='1')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style tag with a CSS id and 'id' as an attribute" do
      html             = %q{<p id='id_1'></p>}
      haml             = %q{%p#id(id='1')}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style tag with a variable attribute" do
      html             = %q{<p class='hello'></p>}
      haml             = %q{%p(class=var)}
      locals           = Hash[{"var"=>"hello"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style tag with a CSS class and 'class' as a variable attribute" do
      html             = %q{<div class='hello world'></div>}
      haml             = %q{.hello(class=var)}
      locals           = Hash[{"var"=>"world"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "HTML-style tag multiple CSS classes (sorted correctly)" do
      html             = %q{<div class='a z'></div>}
      haml             = %q{.z(class=var)}
      locals           = Hash[{"var"=>"a"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "tags with Ruby-style attributes" do
    specify "Ruby-style one attribute" do
      html             = %q{<p a='b'></p>}
      haml             = %q{%p{:a => 'b'}}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style attributes hash with whitespace" do
      html             = %q{<p a='b'></p>}
      haml             = %q{%p{  :a  =>  'b'  }}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style interpolated attribute" do
      html             = %q{<p a='value'></p>}
      haml             = %q{%p{:a =>"#{var}"}}
      locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style multiple attributes" do
      html             = %q{<p a='b' c='d'></p>}
      haml             = %q{%p{ :a => 'b', 'c' => 'd' }}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style attributes separated with newlines" do
      html             = %q{<p a='b' c='d'></p>}
      haml             = %q{%p{ :a => 'b',
  'c' => 'd' }}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style 'class' as an attribute" do
      html             = %q{<p class='class1'></p>}
      haml             = %q{%p{:class => 'class1'}}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag with a CSS class and 'class' as an attribute" do
      html             = %q{<p class='class1 class2'></p>}
      haml             = %q{%p.class2{:class => 'class1'}}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag with 'id' as an attribute" do
      html             = %q{<p id='1'></p>}
      haml             = %q{%p{:id => '1'}}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag with a CSS id and 'id' as an attribute" do
      html             = %q{<p id='id_1'></p>}
      haml             = %q{%p#id{:id => '1'}}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag with a CSS id and a numeric 'id' as an attribute" do
      html             = %q{<p id='id_1'></p>}
      haml             = %q{%p#id{:id => 1}}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag with a variable attribute" do
      html             = %q{<p class='hello'></p>}
      haml             = %q{%p{:class => var}}
      locals           = Hash[{"var"=>"hello"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag with a CSS class and 'class' as a variable attribute" do
      html             = %q{<div class='hello world'></div>}
      haml             = %q{.hello{:class => var}}
      locals           = Hash[{"var"=>"world"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "Ruby-style tag multiple CSS classes (sorted correctly)" do
      html             = %q{<div class='a z'></div>}
      haml             = %q{.z{:class => var}}
      locals           = Hash[{"var"=>"a"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "silent comments" do
    specify "an inline silent comment" do
      html             = %q{}
      haml             = %q{-# hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a nested silent comment" do
      html             = %q{}
      haml             = %q{-#
  hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a multiply nested silent comment" do
      html             = %q{}
      haml             = %q{-#
  %div
    foo}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a multiply nested silent comment with inconsistent indents" do
      html             = %q{}
      haml             = %q{-#
  %div
      foo}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "markup comments" do
    specify "an inline markup comment" do
      html             = %q{<!-- comment -->}
      haml             = %q{/ comment}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a nested markup comment" do
      html             = %q{<!--
  comment
  comment2
-->}
      haml             = %q{/
  comment
  comment2}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "conditional comments" do
    specify "a conditional comment" do
      html             = %q{<!--[if IE]>
  <p>a</p>
<![endif]-->}
      haml             = %q{/[if IE]
  %p a}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "internal filters" do
    specify "content in an 'escaped' filter" do
      html             = %q{&lt;&amp;&quot;&gt;}
      haml             = %q{:escaped
  <&">}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "content in a 'preserve' filter" do
      html             = %q{hello&#x000A;
<p></p>}
      haml             = %q{:preserve
  hello

%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "content in a 'plain' filter" do
      html             = %q{hello
<p></p>}
      haml             = %q{:plain
  hello

%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "content in a 'css' filter (XHTML)" do
      html             = %q{<style type='text/css'>
  /*<![CDATA[*/
    hello
  /*]]>*/
</style>
<p></p>}
      haml             = %q{:css
  hello

%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "content in a 'javascript' filter (XHTML)" do
      html             = %q{<script type='text/javascript'>
  //<![CDATA[
    a();
  //]]>
</script>
<p></p>}
      haml             = %q{:javascript
  a();
%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "content in a 'css' filter (HTML)" do
      html             = %q{<style>
  hello
</style>
<p></p>}
      haml             = %q{:css
  hello

%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "content in a 'javascript' filter (HTML)" do
      html             = %q{<script>
  a();
</script>
<p></p>}
      haml             = %q{:javascript
  a();
%p}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "Ruby-style interpolation" do
    specify "interpolation inside inline content" do
      html             = %q{<p>value</p>}
      haml             = %q{%p #{var}}
      locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "no interpolation when escaped" do
      html             = %q{<p>#{var}</p>}
      haml             = %q{%p \#{var}}
      locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "interpolation when the escape character is escaped" do
      html             = %q{<p>\value</p>}
      haml             = %q{%p \\#{var}}
      locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "interpolation inside filtered content" do
      html             = %q{value interpolated: value}
      haml             = %q{:plain
  #{var} interpolated: #{var}}
      locals           = Hash[{"var"=>"value"}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "HTML escaping" do
    specify "code following '&='" do
      html             = %q{&lt;&quot;&amp;&gt;}
      haml             = %q{&= '<"&>'}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "code following '=' when escape_haml is set to true" do
      html             = %q{&lt;&quot;&amp;&gt;}
      haml             = %q{= '<"&>'}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:escape_html=>"true"}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "code following '!=' when escape_haml is set to true" do
      html             = %q{<"&>}
      haml             = %q{!= '<"&>'}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:escape_html=>"true"}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "boolean attributes" do
    specify "boolean attribute with XHTML" do
      html             = %q{<input checked='checked' />}
      haml             = %q{%input(checked=true)}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"xhtml"}
      options[:format] = :xhtml
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "boolean attribute with HTML" do
      html             = %q{<input checked>}
      haml             = %q{%input(checked=true)}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {:format=>"html5"}
      options[:format] = :html5
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "whitespace preservation" do
    specify "following the '~' operator" do
      html             = %q{Foo
<pre>Bar&#x000A;Baz</pre>}
      haml             = %q{~ "Foo\n<pre>Bar\nBaz</pre>"}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "inside a textarea tag" do
      html             = %q{<textarea>hello
hello</textarea>}
      haml             = %q{%textarea
  hello
  hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "inside a pre tag" do
      html             = %q{<pre>hello
hello</pre>}
      haml             = %q{%pre
  hello
  hello}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end

  context "whitespace removal" do
    specify "a tag with '>' appended and inline content" do
      html             = %q{<li>hello</li><li>world</li><li>again</li>}
      haml             = %q{%li hello
%li> world
%li again}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with '>' appended and nested content" do
      html             = %q{<li>hello</li><li>
  world
</li><li>again</li>}
      haml             = %q{%li hello
%li>
  world
%li again}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end

    specify "a tag with '<' appended" do
      html             = %q{<p>hello
world</p>}
      haml             = %q{%p<
  hello
  world}
      locals           = Hash[{}.map {|x, y| [x.to_sym, y]}]
      options          = {}
      engine           = Hamlit::Template.new(options) { haml }
      result           = engine.render(Object.new, locals)
      expect(result.strip).to eq(html)
    end
  end
end
