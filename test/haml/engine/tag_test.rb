# frozen_string_literal: true

describe Haml::Engine do
  include RenderHelper

  describe 'tag' do
    it 'renders one-line tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>hello</span>
      HTML
        %span hello
      HAML
    end

    it 'accepts multi-line =' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>o</span>
      HTML
        %span= 'hello'.gsub('hell',
          '')
      HAML
    end

    it 'renders multi-line tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        hello
        </span>
      HTML
        %span
          hello
      HAML
    end

    it 'renders a nested tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <b>
        hello
        </b>
        <i>
        <small>world</small>
        </i>
        </span>
      HTML
        %span
          %b
            hello
          %i
            %small world
      HAML
    end

    it 'renders multi-line texts' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <b>
        hello
        world
        </b>
        </span>
      HTML
        %span
          %b
            hello
            world
      HAML
    end

    it 'ignores empty lines' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>
        <b>
        hello
        </b>
        </span>
      HTML
        %span

          %b

            hello

      HAML
    end

    it 'renders classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="foo-1 bar_A">hello</span>
      HTML
        %span.foo-1.bar_A hello
      HAML
    end

    it 'renders ids only last one' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span id="bar-">
        hello
        </span>
      HTML
        %span#Bar_0#bar-
          hello
      HAML
    end

    it 'renders ids and classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="b d" id="c">hello</span>
      HTML
        %span#a.b#c.d hello
      HAML
    end

    it 'renders implicit div tag starting with id' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="world" id="hello"></div>
      HTML
        #hello.world
      HAML
    end

    it 'renders implicit div tag starting with class' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="world" id="hello">
        foo
        </div>
      HTML
        .world#hello
          foo
      HAML
    end

    it 'renders large-case tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <SPAN>
        foo
        </SPAN>
      HTML
        %SPAN
          foo
      HAML
    end

    it 'renders h1 tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <h1>foo</h1>
      HTML
        %h1 foo
      HAML
    end

    it 'renders tag including hyphen or underscore' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <-_>foo</-_>
      HTML
        %-_ foo
      HAML
    end

    it 'does not render silent script just after a tag' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <span->raise 'a'</span->
      HTML
        %span- raise 'a'
      HAML
    end

    it 'renders a text just after attributes' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <span a="2">a</span>
      HTML
        %span{a: 2}a
      HAML
    end

    it 'strips a text' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>foo</span>
      HTML
        %span    foo
      HAML
    end

    it 'ignores spaces after tag' do
      assert_render(<<-HTML.unindent, "%span  \n  a")
        <span>
        a
        </span>
      HTML
    end

    it 'parses self-closing tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent, format: :xhtml)
        <div />
        <div></div>
      HTML
        %div/
        %div
      HAML
    end

    it 'supports Tailwind opacity modifier (/) in class shorthand' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="bg-primary/5"></div>
      HTML
        .bg-primary/5
      HAML
    end

    it 'supports Tailwind opacity modifier (/) with multiple classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="bg-red-500/10 text-white"></div>
      HTML
        .bg-red-500/10.text-white
      HAML
    end

    it 'supports Tailwind opacity modifier (/) on explicit tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="text-black/50">hello</span>
      HTML
        %span.text-black/50 hello
      HAML
    end

    it 'does not confuse Tailwind opacity with self-closing slash' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent, format: :xhtml)
        <input class="border" />
      HTML
        %input.border/
      HAML
    end

    it 'supports Tailwind important modifier (!) in class shorthand' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="!font-bold"></div>
      HTML
        .!font-bold
      HAML
    end

    it 'supports Tailwind important modifier (!) with other classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="!font-bold text-red-500"></div>
      HTML
        .!font-bold.text-red-500
      HAML
    end

    it 'supports Tailwind important modifier (!) on explicit tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <p class="!text-lg">hello</p>
      HTML
        %p.!text-lg hello
      HAML
    end

    it 'supports combining Tailwind opacity and important modifiers' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="!font-bold bg-primary/5"></div>
      HTML
        .!font-bold.bg-primary/5
      HAML
    end

    it 'does not confuse Tailwind ! modifier with unescaped output' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="base"><b>bold</b></div>
      HTML
        .base!= "<b>bold</b>"
      HAML
    end

    it 'supports Tailwind arbitrary values ([]) in class shorthand' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="bg-[#1da1f2]"></div>
      HTML
        .bg-[#1da1f2]
      HAML
    end

    it 'supports Tailwind arbitrary values ([]) with multiple classes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="text-[14px] font-bold"></div>
      HTML
        .text-[14px].font-bold
      HAML
    end

    it 'supports Tailwind arbitrary values ([]) on explicit tag' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span class="w-[320px]">hello</span>
      HTML
        %span.w-[320px] hello
      HAML
    end

    it 'supports Tailwind arbitrary values with complex expressions' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="w-[calc(100%-20px)]"></div>
      HTML
        .w-[calc(100%-20px)]
      HAML
    end

    it 'supports combining arbitrary values with opacity modifier' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class="bg-[rgba(0,0,0)]/50"></div>
      HTML
        .bg-[rgba(0,0,0)]/50
      HAML
    end

    it 'does not consume [] unless preceded by - (leaves object refs intact)' do
      ::TagTestObject = Struct.new(:id) unless defined?(::TagTestObject)
      assert_render(
        %Q|<div class="card tag_test_object" id="tag_test_object_42"></div>\n|,
        %q|.card[foo]|,
        locals: { foo: TagTestObject.new(42) },
      )
    end

    it 'supports arbitrary value class and object reference on the same element' do
      ::TagTestObject = Struct.new(:id) unless defined?(::TagTestObject)
      assert_render(
        %Q|<div class="bg-[#1da1f2] tag_test_object" id="tag_test_object_42"></div>\n|,
        %q|.bg-[#1da1f2][foo]|,
        locals: { foo: TagTestObject.new(42) },
      )
    end
  end
end
