require_relative '../test_helper'

describe Hamlit::Engine do
  include RenderHelper

  describe 'script' do
    it 'renders optimized script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        1
        2
      HTML
        = '1'
        = __LINE__
      HAML
    end

    it 'renders dynamic script' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        1
        2
      HTML
        = 'a'.gsub(/a/, '1')
        = __LINE__
      HAML
    end

    it 'renders dynamic script with children' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        1
        3
        3
        24
      HTML
        = __LINE__
        = __LINE__.times do
          = __LINE__
        = __LINE__
      HAML
    end
  end

  describe 'silent script' do
    it 'renders silent script' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        2:3
        4
      HTML
        - __LINE__.times do
          - a = __LINE__
          = "#{a}:#{__LINE__}"
        = __LINE__
      HAML
    end

    it 'renders silent script with children' do
      assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
        1:2
      HTML
        - a = __LINE__
        = "#{a}:#{__LINE__}"
      HAML
    end
  end

  describe 'old attributes' do
    it 'renders multi-line old attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span a='1' b='2'>2</span>
        3
      HTML
        %span{ a: __LINE__,
          b: __LINE__ }= __LINE__
        = __LINE__
      HAML
    end

    it 'renders optimized old attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span a='a' b='b'></span>
        3
        <span a='a' b='b'>5</span>
        6
      HTML
        %span{ a: 'a',
          b: 'b' }
        = __LINE__
        %span{ a: 'a',
          b: 'b' }= __LINE__
        = __LINE__
      HAML
    end
  end

  describe 'new attributes' do
    it 'renders multi-line new attributes' do
      assert_render(<<-HTML.unindent, <<-HAML.unindent)
        <span a='1' b='1'>1</span>
        3
      HTML
        %span(a=__LINE__
         b=__LINE__)= __LINE__
        = __LINE__
      HAML
    end
  end

  describe 'filters' do
    describe 'coffee filter' do
      it 'renders static filter' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <script>
            (function() {
              jQuery(function($) {
                console.log('3');
                return console.log('4');
              });
            
            }).call(this);
          </script>
          5
        HTML
          :coffee
            jQuery ($) ->
              console.log('#{__LINE__}')
              console.log('#{__LINE__}')
          = __LINE__
        HAML
      end

      it 'renders dynamic filter' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <script>
            (function() {
              jQuery(function($) {
                console.log('3');
                return console.log('4');
              });
            
            }).call(this);
          </script>
          5
        HTML
          :coffee
            jQuery ($) ->
              console.log('3')
              console.log('4')
          = __LINE__
        HAML
      end
    end unless /java/ === RUBY_PLATFORM # execjs is not working with Travis JRuby environment

    describe 'css filter' do
      it 'renders static filter' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <style>
            body {
              width: 3px;
              height: 4px;
            }
          </style>
          6
        HTML
          :css
            body {
              width: 3px;
              height: 4px;
            }
          = __LINE__
        HAML
      end

      it 'renders dynamic filter' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <style>
            body {
              width: 3px;
              height: 4px;
            }
          </style>
          6
        HTML
          :css
            body {
              width: #{__LINE__}px;
              height: #{__LINE__}px;
            }
          = __LINE__
        HAML
      end

      it 'renders dynamic filter with trailing newlines' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <style>
            body {
              width: 3px;
              height: 4px;
            }
          </style>
          8
        HTML
          :css
            body {
              width: #{__LINE__}px;
              height: #{__LINE__}px;
            }


          = __LINE__
        HAML
      end
    end

    describe 'javascript filter' do
      it 'renders static filter' do
        assert_render(<<-HTML.unindent, <<-HAML.unindent)
          <script>
            console.log("2");
            console.log("3");
          </script>
          5
        HTML
          :javascript
            console.log("2");
            console.log("3");

          = __LINE__
        HAML
      end

      it 'renders dynamic filter' do
        assert_render(<<-HTML.unindent, <<-'HAML'.unindent)
          <script>
            console.log("2");
            console.log("3");
          </script>
          5
        HTML
          :javascript
            console.log("#{__LINE__}");
            console.log("#{__LINE__}");

          = __LINE__
        HAML
      end
    end unless /java/ === RUBY_PLATFORM # execjs is not working with Travis JRuby environment
  end
end if RUBY_ENGINE != 'truffleruby' # negetive line numbers are broken in truffleruby
