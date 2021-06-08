describe Hamlit::Engine do
  include RenderHelper

  describe 'whitespace removal' do
    it 'removes outer whitespace by >' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>a</span><span>b</span>
        <span>c</span><span>
        d
        </span><span>
        e
        </span>
        <span>f</span>
      HTML
        %span> a
        %span b
        %span c
        %span>
          d
        %span
          e
        %span f
      HAML
    end

    it 'removes outer whitespace by > from inside of block' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>a</span><span>
        b
        </span><span>
        c
        </span>
      HTML
        %span a
        - if true
          %span>
            b
        %span
          c
      HAML
    end

    it 'removes whitespaces inside block script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span>foofoo2<span>bar</span></span>
      HTML
        %span<
          = 2.times do
            = 'foo'
          %span> bar
      HAML
    end

    it 'removes whitespace inside script inside silent script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class='bar'>foofoofoo</div>
      HTML
        .bar<
          - 3.times do
            = 'foo'
      HAML
    end

    it 'removes whitespace inside script recursively' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class='foo'>bar1bar1bar1bar12</div>
      HTML
        .foo<
          - 1.times do
            = 2.times do
              - 2.times do
                = 1.times do
                  = 'bar'
      HAML
    end

    it 'does not remove whitespace after string interpolation' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        <div>helloworld</div>
      HTML
        %div<
          #{'hello'}
          world
      HAML
    end

    it 'removes whitespace inside script inside silent script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <div class='bar'>12</div>
      HTML
        .bar<
          - 1.times do
            = '1'
            = '2'
      HAML
    end

    it 'does not nuke internal recursively' do
      assert_render(%Q|<div><span>\nhello\n</span></div>|, <<-HAML.unindent)
        %div><
          %span>
            hello
      HAML
    end

    it 'does not nuke inside script' do
      assert_render(%Q|<div><span>\nhello\n</span>1</div>|, <<-HAML.unindent)
        %div><
          = 1.times do
            %span>
              hello
      HAML
    end
  end
end
