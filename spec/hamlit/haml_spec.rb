require "haml"

# This is a spec converted by haml-spec.
# See: https://github.com/haml/haml-spec
describe "haml ugly mode with ecape_html" do
  DEFAULT_OPTIONS = { ugly: true, escape_html: true }.freeze

  def assert_haml(haml, locals, options)
    engine  = Haml::Engine.new(haml, DEFAULT_OPTIONS.merge(options))
    hamlit  = Hamlit::Template.new(options) { haml }
    expect(hamlit.render(Object.new, locals)).to eq(engine.render(Object.new, locals))
  end

  context "headers" do
    specify "an XHTML XML prolog" do
      haml    = %q{!!! XML}
      html    = %q{<?xml version='1.0' encoding='utf-8' ?>}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an XHTML default (transitional) doctype" do
      haml    = %q{!!!}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an XHTML 1.1 doctype" do
      haml    = %q{!!! 1.1}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an XHTML 1.2 mobile doctype" do
      haml    = %q{!!! mobile}
      html    = %q{<!DOCTYPE html PUBLIC "-//WAPFORUM//DTD XHTML Mobile 1.2//EN" "http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an XHTML 1.1 basic doctype" do
      haml    = %q{!!! basic}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML Basic 1.1//EN" "http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an XHTML 1.0 frameset doctype" do
      haml    = %q{!!! frameset}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 5 doctype with XHTML syntax" do
      haml    = %q{!!! 5}
      html    = %q{<!DOCTYPE html>}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 5 XML prolog (silent)" do
      haml    = %q{!!! XML}
      html    = %q{}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 5 doctype" do
      haml    = %q{!!!}
      html    = %q{<!DOCTYPE html>}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 4 XML prolog (silent)" do
      haml    = %q{!!! XML}
      html    = %q{}
      locals  = {}
      options = {:format=>:html4}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 4 default (transitional) doctype" do
      haml    = %q{!!!}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}
      locals  = {}
      options = {:format=>:html4}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 4 frameset doctype" do
      haml    = %q{!!! frameset}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">}
      locals  = {}
      options = {:format=>:html4}
      assert_haml(haml, locals, options)
    end

    specify "an HTML 4 strict doctype" do
      haml    = %q{!!! strict}
      html    = %q{<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">}
      locals  = {}
      options = {:format=>:html4}
      assert_haml(haml, locals, options)
    end
  end

  context "basic Haml tags and CSS" do
    specify "a simple Haml tag" do
      haml    = %q{%p}
      html    = %q{<p></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a self-closing tag (XHTML)" do
      haml    = %q{%meta}
      html    = %q{<meta />}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "a self-closing tag (HTML4)" do
      haml    = %q{%meta}
      html    = %q{<meta>}
      locals  = {}
      options = {:format=>:html4}
      assert_haml(haml, locals, options)
    end

    specify "a self-closing tag (HTML5)" do
      haml    = %q{%meta}
      html    = %q{<meta>}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end

    specify "a self-closing tag ('/' modifier + XHTML)" do
      haml    = %q{%zzz/}
      html    = %q{<zzz />}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "a self-closing tag ('/' modifier + HTML5)" do
      haml    = %q{%zzz/}
      html    = %q{<zzz>}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end

    specify "a tag with a CSS class" do
      haml    = %q{%p.class1}
      html    = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with multiple CSS classes" do
      haml    = %q{%p.class1.class2}
      html    = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with a CSS id" do
      haml    = %q{%p#id1}
      html    = %q{<p id='id1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with multiple CSS id's" do
      haml    = %q{%p#id1#id2}
      html    = %q{<p id='id2'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with a class followed by an id" do
      haml    = %q{%p.class1#id1}
      html    = %q{<p class='class1' id='id1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with an id followed by a class" do
      haml    = %q{%p#id1.class1}
      html    = %q{<p class='class1' id='id1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "an implicit div with a CSS id" do
      haml    = %q{#id1}
      html    = %q{<div id='id1'></div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "an implicit div with a CSS class" do
      haml    = %q{.class1}
      html    = %q{<div class='class1'></div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "multiple simple Haml tags" do
      haml    = %q{%div
  %div
    %p}
      html    = %q{<div>
  <div>
    <p></p>
  </div>
</div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "tags with unusual HTML characters" do
    specify "a tag with colons" do
      haml    = %q{%ns:tag}
      html    = %q{<ns:tag></ns:tag>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with underscores" do
      haml    = %q{%snake_case}
      html    = %q{<snake_case></snake_case>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with dashes" do
      haml    = %q{%dashed-tag}
      html    = %q{<dashed-tag></dashed-tag>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with camelCase" do
      haml    = %q{%camelCase}
      html    = %q{<camelCase></camelCase>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with PascalCase" do
      haml    = %q{%PascalCase}
      html    = %q{<PascalCase></PascalCase>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "tags with unusual CSS identifiers" do
    specify "an all-numeric class" do
      haml    = %q{.123}
      html    = %q{<div class='123'></div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a class with underscores" do
      haml    = %q{.__}
      html    = %q{<div class='__'></div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a class with dashes" do
      haml    = %q{.--}
      html    = %q{<div class='--'></div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "tags with inline content" do
    specify "Inline content simple tag" do
      haml    = %q{%p hello}
      html    = %q{<p>hello</p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Inline content tag with CSS" do
      haml    = %q{%p.class1 hello}
      html    = %q{<p class='class1'>hello</p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Inline content multiple simple tags" do
      haml    = %q{%div
  %div
    %p text}
      html    = %q{<div>
  <div>
    <p>text</p>
  </div>
</div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "tags with nested content" do
    specify "Nested content simple tag" do
      haml    = %q{%p
  hello}
      html    = %q{<p>
  hello
</p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Nested content tag with CSS" do
      haml    = %q{%p.class1
  hello}
      html    = %q{<p class='class1'>
  hello
</p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Nested content multiple simple tags" do
      haml    = %q{%div
  %div
    %p
      text}
      html    = %q{<div>
  <div>
    <p>
      text
    </p>
  </div>
</div>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "tags with HTML-style attributes" do
    specify "HTML-style one attribute" do
      haml    = %q{%p(a='b')}
      html    = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style multiple attributes" do
      haml    = %q{%p(a='b' c='d')}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style attributes separated with newlines" do
      haml    = %q{%p(a='b'
  c='d')}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style interpolated attribute" do
      haml    = %q{%p(a="#{var}")}
      html    = %q{<p a='value'></p>}
      locals  = {:var=>"value"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style 'class' as an attribute" do
      haml    = %q{%p(class='class1')}
      html    = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag with a CSS class and 'class' as an attribute" do
      haml    = %q{%p.class2(class='class1')}
      html    = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag with 'id' as an attribute" do
      haml    = %q{%p(id='1')}
      html    = %q{<p id='1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag with a CSS id and 'id' as an attribute" do
      haml    = %q{%p#id(id='1')}
      html    = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag with a variable attribute" do
      haml    = %q{%p(class=var)}
      html    = %q{<p class='hello'></p>}
      locals  = {:var=>"hello"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag with a CSS class and 'class' as a variable attribute" do
      haml    = %q{.hello(class=var)}
      html    = %q{<div class='hello world'></div>}
      locals  = {:var=>"world"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag multiple CSS classes (sorted correctly)" do
      haml    = %q{.z(class=var)}
      html    = %q{<div class='a z'></div>}
      locals  = {:var=>"a"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "HTML-style tag with an atomic attribute" do
      haml    = %q{%a(flag)}
      html    = %q{<a flag></a>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "tags with Ruby-style attributes" do
    specify "Ruby-style one attribute" do
      haml    = %q{%p{:a => 'b'}}
      html    = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style attributes hash with whitespace" do
      haml    = %q{%p{  :a  =>  'b'  }}
      html    = %q{<p a='b'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style interpolated attribute" do
      haml    = %q{%p{:a =>"#{var}"}}
      html    = %q{<p a='value'></p>}
      locals  = {:var=>"value"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style multiple attributes" do
      haml    = %q{%p{ :a => 'b', 'c' => 'd' }}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style attributes separated with newlines" do
      haml    = %q{%p{ :a => 'b',
  'c' => 'd' }}
      html    = %q{<p a='b' c='d'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style 'class' as an attribute" do
      haml    = %q{%p{:class => 'class1'}}
      html    = %q{<p class='class1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS class and 'class' as an attribute" do
      haml    = %q{%p.class2{:class => 'class1'}}
      html    = %q{<p class='class1 class2'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag with 'id' as an attribute" do
      haml    = %q{%p{:id => '1'}}
      html    = %q{<p id='1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS id and 'id' as an attribute" do
      haml    = %q{%p#id{:id => '1'}}
      html    = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS id and a numeric 'id' as an attribute" do
      haml    = %q{%p#id{:id => 1}}
      html    = %q{<p id='id_1'></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag with a variable attribute" do
      haml    = %q{%p{:class => var}}
      html    = %q{<p class='hello'></p>}
      locals  = {:var=>"hello"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS class and 'class' as a variable attribute" do
      haml    = %q{.hello{:class => var}}
      html    = %q{<div class='hello world'></div>}
      locals  = {:var=>"world"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "Ruby-style tag multiple CSS classes (sorted correctly)" do
      haml    = %q{.z{:class => var}}
      html    = %q{<div class='a z'></div>}
      locals  = {:var=>"a"}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "silent comments" do
    specify "an inline silent comment" do
      haml    = %q{-# hello}
      html    = %q{}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a nested silent comment" do
      haml    = %q{-#
  hello}
      html    = %q{}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a multiply nested silent comment" do
      haml    = %q{-#
  %div
    foo}
      html    = %q{}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a multiply nested silent comment with inconsistent indents" do
      haml    = %q{-#
  %div
      foo}
      html    = %q{}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "markup comments" do
    specify "an inline markup comment" do
      haml    = %q{/ comment}
      html    = %q{<!-- comment -->}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a nested markup comment" do
      haml    = %q{/
  comment
  comment2}
      html    = %q{<!--
  comment
  comment2
-->}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "conditional comments" do
    specify "a conditional comment" do
      haml    = %q{/[if IE]
  %p a}
      html    = %q{<!--[if IE]>
  <p>a</p>
<![endif]-->}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "internal filters" do
    specify "content in an 'escaped' filter" do
      haml    = %q{:escaped
  <&">}
      html    = %q{&lt;&amp;&quot;&gt;}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "content in a 'preserve' filter" do
      haml    = %q{:preserve
  hello

%p}
      html    = %q{hello&#x000A;
<p></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "content in a 'plain' filter" do
      haml    = %q{:plain
  hello

%p}
      html    = %q{hello
<p></p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "content in a 'css' filter (XHTML)" do
      haml    = %q{:css
  hello

%p}
      html    = %q{<style type='text/css'>
  /*<![CDATA[*/
    hello
  /*]]>*/
</style>
<p></p>}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "content in a 'javascript' filter (XHTML)" do
      haml    = %q{:javascript
  a();
%p}
      html    = %q{<script type='text/javascript'>
  //<![CDATA[
    a();
  //]]>
</script>
<p></p>}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "content in a 'css' filter (HTML)" do
      haml    = %q{:css
  hello

%p}
      html    = %q{<style>
  hello
</style>
<p></p>}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end

    specify "content in a 'javascript' filter (HTML)" do
      haml    = %q{:javascript
  a();
%p}
      html    = %q{<script>
  a();
</script>
<p></p>}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end
  end

  context "Ruby-style interpolation" do
    specify "interpolation inside inline content" do
      haml    = %q{%p #{var}}
      html    = %q{<p>value</p>}
      locals  = {:var=>"value"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "no interpolation when escaped" do
      haml    = %q{%p \#{var}}
      html    = %q{<p>#{var}</p>}
      locals  = {:var=>"value"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "interpolation when the escape character is escaped" do
      haml    = %q{%p \\#{var}}
      html    = %q{<p>\value</p>}
      locals  = {:var=>"value"}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "interpolation inside filtered content" do
      haml    = %q{:plain
  #{var} interpolated: #{var}}
      html    = %q{value interpolated: value}
      locals  = {:var=>"value"}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "HTML escaping" do
    specify "code following '&='" do
      haml    = %q{&= '<"&>'}
      html    = %q{&lt;&quot;&amp;&gt;}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "code following '=' when escape_haml is set to true" do
      haml    = %q{= '<"&>'}
      html    = %q{&lt;&quot;&amp;&gt;}
      locals  = {}
      options = {:escape_html=>"true"}
      assert_haml(haml, locals, options)
    end

    specify "code following '!=' when escape_haml is set to true" do
      haml    = %q{!= '<"&>'}
      html    = %q{<"&>}
      locals  = {}
      options = {:escape_html=>"true"}
      assert_haml(haml, locals, options)
    end
  end

  context "boolean attributes" do
    specify "boolean attribute with XHTML" do
      haml    = %q{%input(checked=true)}
      html    = %q{<input checked='checked' />}
      locals  = {}
      options = {:format=>:xhtml}
      assert_haml(haml, locals, options)
    end

    specify "boolean attribute with HTML" do
      haml    = %q{%input(checked=true)}
      html    = %q{<input checked>}
      locals  = {}
      options = {:format=>:html5}
      assert_haml(haml, locals, options)
    end
  end

  context "whitespace preservation" do
    specify "following the '~' operator" do
      haml    = %q{~ "Foo\n<pre>Bar\nBaz</pre>"}
      html    = %q{Foo
<pre>Bar&#x000A;Baz</pre>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "inside a textarea tag" do
      haml    = %q{%textarea
  hello
  hello}
      html    = %q{<textarea>hello
hello</textarea>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "inside a pre tag" do
      haml    = %q{%pre
  hello
  hello}
      html    = %q{<pre>hello
hello</pre>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end

  context "whitespace removal" do
    specify "a tag with '>' appended and inline content" do
      haml    = %q{%li hello
%li> world
%li again}
      html    = %q{<li>hello</li><li>world</li><li>again</li>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with '>' appended and nested content" do
      haml    = %q{%li hello
%li>
  world
%li again}
      html    = %q{<li>hello</li><li>
  world
</li><li>again</li>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end

    specify "a tag with '<' appended" do
      haml    = %q{%p<
  hello
  world}
      html    = %q{<p>hello
world</p>}
      locals  = {}
      options = {}
      assert_haml(haml, locals, options)
    end
  end
end
