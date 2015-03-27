require "haml"

describe "haml" do
  def assert_pretty(haml, locals, options)
    engine = Haml::Engine.new(haml, options)
    hamlit = Hamlit::Template.new(options) { haml }
    expect(hamlit.render(Object.new, locals)).to eq(engine.render(Object.new, locals))
  end

  def assert_ugly(haml, locals, options)
    assert_pretty(haml, locals, { ugly: true }.merge(options))
  end

  context "headers" do
    specify "an XHTML XML prolog" do
      haml    = %q{!!! XML}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an XHTML default (transitional) doctype" do
      haml    = %q{!!!}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an XHTML 1.1 doctype" do
      haml    = %q{!!! 1.1}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an XHTML 1.2 mobile doctype" do
      haml    = %q{!!! mobile}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an XHTML 1.1 basic doctype" do
      haml    = %q{!!! basic}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an XHTML 1.0 frameset doctype" do
      haml    = %q{!!! frameset}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 5 doctype with XHTML syntax" do
      haml    = %q{!!! 5}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 5 XML prolog (silent)" do
      haml    = %q{!!! XML}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 5 doctype" do
      haml    = %q{!!!}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 4 XML prolog (silent)" do
      haml    = %q{!!! XML}
      locals  = {}
      options = {:format=>:html4}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 4 default (transitional) doctype" do
      haml    = %q{!!!}
      locals  = {}
      options = {:format=>:html4}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 4 frameset doctype" do
      haml    = %q{!!! frameset}
      locals  = {}
      options = {:format=>:html4}
      assert_ugly(haml, locals, options)
    end

    specify "an HTML 4 strict doctype" do
      haml    = %q{!!! strict}
      locals  = {}
      options = {:format=>:html4}
      assert_ugly(haml, locals, options)
    end
  end

  context "basic Haml tags and CSS" do
    specify "a simple Haml tag" do
      haml    = %q{%p}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a self-closing tag (XHTML)" do
      haml    = %q{%meta}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "a self-closing tag (HTML4)" do
      haml    = %q{%meta}
      locals  = {}
      options = {:format=>:html4}
      assert_ugly(haml, locals, options)
    end

    specify "a self-closing tag (HTML5)" do
      haml    = %q{%meta}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end

    specify "a self-closing tag ('/' modifier + XHTML)" do
      haml    = %q{%zzz/}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "a self-closing tag ('/' modifier + HTML5)" do
      haml    = %q{%zzz/}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with a CSS class" do
      haml    = %q{%p.class1}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with multiple CSS classes" do
      haml    = %q{%p.class1.class2}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with a CSS id" do
      haml    = %q{%p#id1}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with multiple CSS id's" do
      haml    = %q{%p#id1#id2}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with a class followed by an id" do
      haml    = %q{%p.class1#id1}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with an id followed by a class" do
      haml    = %q{%p#id1.class1}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "an implicit div with a CSS id" do
      haml    = %q{#id1}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "an implicit div with a CSS class" do
      haml    = %q{.class1}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "multiple simple Haml tags" do
      haml    = %q{%div
  %div
    %p}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "tags with unusual HTML characters" do
    specify "a tag with colons" do
      haml    = %q{%ns:tag}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with underscores" do
      haml    = %q{%snake_case}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with dashes" do
      haml    = %q{%dashed-tag}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with camelCase" do
      haml    = %q{%camelCase}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with PascalCase" do
      haml    = %q{%PascalCase}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "tags with unusual CSS identifiers" do
    specify "an all-numeric class" do
      haml    = %q{.123}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a class with underscores" do
      haml    = %q{.__}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a class with dashes" do
      haml    = %q{.--}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "tags with inline content" do
    specify "Inline content simple tag" do
      haml    = %q{%p hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Inline content tag with CSS" do
      haml    = %q{%p.class1 hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Inline content multiple simple tags" do
      haml    = %q{%div
  %div
    %p text}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "tags with nested content" do
    specify "Nested content simple tag" do
      haml    = %q{%p
  hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Nested content tag with CSS" do
      haml    = %q{%p.class1
  hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Nested content multiple simple tags" do
      haml    = %q{%div
  %div
    %p
      text}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "tags with HTML-style attributes" do
    specify "HTML-style one attribute" do
      haml    = %q{%p(a='b')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style multiple attributes" do
      haml    = %q{%p(a='b' c='d')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    # FIXME: it requires multiple-line attribute parser
    pending "HTML-style attributes separated with newlines" do
      haml    = %q{%p(a='b'
  c='d')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style interpolated attribute" do
      haml    = %q{%p(a="#{var}")}
      locals  = {:var=>"value"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style 'class' as an attribute" do
      haml    = %q{%p(class='class1')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style tag with a CSS class and 'class' as an attribute" do
      haml    = %q{%p.class2(class='class1')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style tag with 'id' as an attribute" do
      haml    = %q{%p(id='1')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style tag with a CSS id and 'id' as an attribute" do
      haml    = %q{%p#id(id='1')}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style tag with a variable attribute" do
      haml    = %q{%p(class=var)}
      locals  = {:var=>"hello"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style tag with a CSS class and 'class' as a variable attribute" do
      haml    = %q{.hello(class=var)}
      locals  = {:var=>"world"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "HTML-style tag multiple CSS classes (sorted correctly)" do
      haml    = %q{.z(class=var)}
      locals  = {:var=>"a"}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "tags with Ruby-style attributes" do
    specify "Ruby-style one attribute" do
      haml    = %q{%p{:a => 'b'}}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style attributes hash with whitespace" do
      haml    = %q{%p{  :a  =>  'b'  }}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style interpolated attribute" do
      haml    = %q{%p{:a =>"#{var}"}}
      locals  = {:var=>"value"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style multiple attributes" do
      haml    = %q{%p{ :a => 'b', 'c' => 'd' }}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    # FIXME: it requires multiple-line attribute parser
    pending "Ruby-style attributes separated with newlines" do
      haml    = %q{%p{ :a => 'b',
  'c' => 'd' }}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style 'class' as an attribute" do
      haml    = %q{%p{:class => 'class1'}}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS class and 'class' as an attribute" do
      haml    = %q{%p.class2{:class => 'class1'}}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag with 'id' as an attribute" do
      haml    = %q{%p{:id => '1'}}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS id and 'id' as an attribute" do
      haml    = %q{%p#id{:id => '1'}}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS id and a numeric 'id' as an attribute" do
      haml    = %q{%p#id{:id => 1}}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag with a variable attribute" do
      haml    = %q{%p{:class => var}}
      locals  = {:var=>"hello"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag with a CSS class and 'class' as a variable attribute" do
      haml    = %q{.hello{:class => var}}
      locals  = {:var=>"world"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "Ruby-style tag multiple CSS classes (sorted correctly)" do
      haml    = %q{.z{:class => var}}
      locals  = {:var=>"a"}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "silent comments" do
    specify "an inline silent comment" do
      haml    = %q{-# hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a nested silent comment" do
      haml    = %q{-#
  hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a multiply nested silent comment" do
      haml    = %q{-#
  %div
    foo}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a multiply nested silent comment with inconsistent indents" do
      haml    = %q{-#
  %div
      foo}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "markup comments" do
    specify "an inline markup comment" do
      haml    = %q{/ comment}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a nested markup comment" do
      haml    = %q{/
  comment
  comment2}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "conditional comments" do
    specify "a conditional comment" do
      haml    = %q{/[if IE]
  %p a}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "internal filters" do
    specify "content in an 'escaped' filter" do
      haml    = %q{:escaped
  <&">}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "content in a 'preserve' filter" do
      haml    = %q{:preserve
  hello

%p}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "content in a 'plain' filter" do
      haml    = %q{:plain
  hello

%p}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "content in a 'css' filter (XHTML)" do
      haml    = %q{:css
  hello

%p}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "content in a 'javascript' filter (XHTML)" do
      haml    = %q{:javascript
  a();
%p}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "content in a 'css' filter (HTML)" do
      haml    = %q{:css
  hello

%p}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end

    specify "content in a 'javascript' filter (HTML)" do
      haml    = %q{:javascript
  a();
%p}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end
  end

  context "Ruby-style interpolation" do
    specify "interpolation inside inline content" do
      haml    = %q{%p #{var}}
      locals  = {:var=>"value"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "no interpolation when escaped" do
      haml    = %q{%p \#{var}}
      locals  = {:var=>"value"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "interpolation when the escape character is escaped" do
      haml    = %q{%p \\#{var}}
      locals  = {:var=>"value"}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "interpolation inside filtered content" do
      haml    = %q{:plain
  #{var} interpolated: #{var}}
      locals  = {:var=>"value"}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "HTML escaping" do
    specify "code following '&='" do
      haml    = %q{&= '<"&>'}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "code following '=' when escape_haml is set to true" do
      haml    = %q{= '<"&>'}
      locals  = {}
      options = {:escape_html=>"true"}
      assert_ugly(haml, locals, options)
    end

    specify "code following '!=' when escape_haml is set to true" do
      haml    = %q{!= '<"&>'}
      locals  = {}
      options = {:escape_html=>"true"}
      assert_ugly(haml, locals, options)
    end
  end

  context "boolean attributes" do
    specify "boolean attribute with XHTML" do
      haml    = %q{%input(checked=true)}
      locals  = {}
      options = {:format=>:xhtml}
      assert_ugly(haml, locals, options)
    end

    specify "boolean attribute with HTML" do
      haml    = %q{%input(checked=true)}
      locals  = {}
      options = {:format=>:html5}
      assert_ugly(haml, locals, options)
    end
  end

  context "whitespace preservation" do
    specify "following the '~' operator" do
      haml    = %q{~ "Foo\n<pre>Bar\nBaz</pre>"}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "inside a textarea tag" do
      haml    = %q{%textarea
  hello
  hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "inside a pre tag" do
      haml    = %q{%pre
  hello
  hello}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end

  context "whitespace removal" do
    specify "a tag with '>' appended and inline content" do
      haml    = %q{%li hello
%li> world
%li again}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with '>' appended and nested content" do
      haml    = %q{%li hello
%li>
  world
%li again}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end

    specify "a tag with '<' appended" do
      haml    = %q{%p<
  hello
  world}
      locals  = {}
      options = {}
      assert_ugly(haml, locals, options)
    end
  end
end
