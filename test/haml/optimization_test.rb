# frozen_string_literal: true

require_relative '../test_helper'

describe 'optimization' do
  include RenderHelper

  def compiled_code(haml, options = {})
    Haml::Engine.new(options).call(haml)
  end

  # Mirrors Haml::RailsTemplate.options without depending on the railtie being loaded.
  def rails_compiled_code(haml)
    compiled_code(haml, {
      generator:       Temple::Generators::RailsOutputBuffer,
      use_html_safe:   true,
      buffer_class:    'ActionView::OutputBuffer',
      disable_capture: true,
    })
  end

  describe 'static analysis' do
    it 'renders static value for href statically' do
      haml = %|%a{ href: 1 }|
      assert_equal true, compiled_code(haml).include?("href=\\\"1\\\"")
    end

    it 'renders html attributes statically' do
      haml = %|%span(data-boolean data-string="str")|
      assert_equal true, compiled_code(haml).include?("<span data-boolean data-string=\\\"str\\\">")
    end

    it 'renders static script statically' do
      haml = <<-HAML.unindent
        %span
          1
      HAML
      assert_equal true, compiled_code(haml).include?(%q|<span>\n1\n</span>|)
    end

    it 'renders inline static script statically' do
      haml = %|%span= 1|
      assert_equal true, compiled_code(haml).include?(%|<span>1</span>|)
    end
  end

  describe 'string interpolation' do
    it 'renders a static part of string literal statically' do
      haml = %q|%input{ value: "jruby#{9000}#{dynamic}" }|
      assert_equal true, compiled_code(haml).include?("value=\\\"jruby9000")

      haml = %q|%span= "jruby#{9000}#{dynamic}"|
      assert_equal true, compiled_code(haml).include?(%|<span>jruby9000|)
    end

    it 'optimizes script' do
      haml = %q|= "jruby#{ "#{9000}" }#{dynamic}"|
      assert_equal true, compiled_code(haml).include?(%|jruby9000|)
    end

    it 'detects a static part recursively' do
      haml = %q|%input{ value: "#{ "hello#{ hello }" }" }|
      assert_equal true, compiled_code(haml).include?("value=\\\"hello")
    end

    it 'leaves adjacent string concatenation alone' do
      assert_render(%|<span>hello world</span>\n|, %q|%span= "hello" " world"|)
    end
  end

  describe 'to_s' do
    it 'emits a single to_s per dynamic output' do
      assert_equal 1, compiled_code(%|%p= @content|).scan('.to_s').size
      assert_equal 1, compiled_code(%|%p!= @content|).scan('.to_s').size
    end

    it 'emits a single to_s per dynamic output in rails mode' do
      code = rails_compiled_code(%|%p= @content|)
      assert_equal true, code.include?('safe_concat')
      assert_equal 1, code.scan('.to_s').size
    end

    it 'does not append to_s to an interpolated attribute value' do
      code = compiled_code(<<-HAML.unindent)
        - href = 1
        %a{ href: href }
      HAML
      assert_equal true, code.include?('#{::Haml::Util.escape_html((href))}')
    end

    it 'appends to_s only to :escapeany nodes' do
      filter = Haml::EscapeAny.new(use_html_safe: false)
      assert_equal [:dynamic, '::Haml::Util.escape_html((foo))'],
                   filter.call([:escapeany, true, [:dynamic, 'foo']])
      assert_equal [:dynamic, '(foo).to_s'],
                   filter.call([:escapeany, false, [:dynamic, 'foo']])
      # An already-escaped node, i.e. what the Escape pass leaves behind.
      assert_equal [:dynamic, '::Haml::Util.escape_html((foo))'],
                   filter.call([:dynamic, '::Haml::Util.escape_html((foo))'])
    end

    it 'still stringifies values which are not String' do
      assert_render(%|<p>1/1</p>\n|, %|%p= 1.to_r|)
      assert_render(%|<p>1/1</p>\n|, %|%p!= 1.to_r|)
      assert_render(%|1/1\n|, %|!= 1.to_r|)
      assert_render(%|<a href="1/1"></a>\n|, %Q|- href = 1.to_r\n%a{ href: href }|)
    end
  end

  # The runtime path: what AttributeCompiler#runtime_compile emits for hashes it cannot
  # resolve at compile time.
  describe 'boolean attributes' do
    def build(hash, format = :html)
      Haml::AttributeBuilder.build(true, '"', format, nil, hash)
    end

    def with_custom_attributes(*attributes)
      old_attributes = Haml::BOOLEAN_ATTRIBUTES.dup
      Haml::BOOLEAN_ATTRIBUTES.push(*attributes)
      yield
    ensure
      Haml::BOOLEAN_ATTRIBUTES.replace(old_attributes)
    end

    it 'omits a known boolean attribute whose value is false or nil' do
      assert_equal ' disabled', build('disabled' => true)
      assert_equal '', build('disabled' => false)
      assert_equal '', build('disabled' => nil)
      assert_equal ' disabled="disabled"', build({ 'disabled' => true }, :xhtml)
    end

    it 'treats data- and aria- prefixed attributes as boolean' do
      assert_equal ' data-foo', build('data-foo' => true)
      assert_equal ' aria-foo', build('aria-foo' => true)
      assert_equal '', build('data-foo' => false)
      assert_equal '', build('aria-foo' => false)
    end

    it 'keeps other attributes non-boolean' do
      assert_equal ' href="true"', build('href' => true)
      assert_equal ' href="false"', build('href' => false)
      # The prefixes are anchored: only a leading data-/aria- counts.
      assert_equal ' datax="false"', build('datax' => false)
      assert_equal ' x-data-foo="false"', build('x-data-foo' => false)
    end

    it 'picks up attributes added to BOOLEAN_ATTRIBUTES after the first build' do
      assert_equal ' custom="false"', build('custom' => false)
      with_custom_attributes('custom') do
        assert_equal '', build('custom' => false)
        assert_equal ' custom', build('custom' => true)
      end
      assert_equal ' custom="false"', build('custom' => false)
    end
  end

  describe 'attribute keys' do
    BUILDS = 1000

    def build(*hashes)
      Haml::AttributeBuilder.build(true, '"', :html, nil, *hashes)
    end

    def allocations
      GC.start
      before = GC.stat(:total_allocated_objects)
      BUILDS.times { yield }
      GC.stat(:total_allocated_objects) - before
    end

    it 'treats a Symbol key the same as the equivalent String key' do
      assert_equal build('href' => '/x'), build(href: '/x')
      assert_equal build('id' => 'a'),    build(id: 'a')
      assert_equal build('class' => 'a'), build(class: 'a')
      assert_equal build('data' => { 'book_id' => 5432 }), build(data: { book_id: 5432 })
      assert_equal build('aria' => { 'label' => 'x' }),    build(aria: { label: 'x' })
    end

    it 'merges Symbol and String spellings of the same key' do
      assert_equal ' href="/y"',   build({ href: '/x' }, { 'href' => '/y' })
      assert_equal ' id="a_b"',    build({ id: 'a' }, { 'id' => 'b' })
      assert_equal ' class="a b"', build({ class: 'a' }, { 'class' => 'b' })
    end

    it 'stringifies a key which is neither Symbol nor String' do
      assert_equal ' 1="2"', build(1 => 2)
    end

    it 'allocates no more for Symbol keys than for the equivalent String keys' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      symbol_keys = { href: '/x', title: 't' }
      string_keys = { 'href' => '/x', 'title' => 't' }
      build(symbol_keys)
      build(string_keys)

      extra = allocations { build(symbol_keys) } - allocations { build(string_keys) }
      # Was 2 * BUILDS: key.to_s allocated one String per Symbol key per build.
      assert_operator extra, :<, BUILDS / 10
    end
  end

  # The nested keys of data:/aria:, flattened and hyphenated by
  # AttributeBuilder.flatten_attributes.
  describe 'nested attribute keys' do
    def build(*hashes)
      Haml::AttributeBuilder.build(true, '"', :html, nil, *hashes)
    end

    def allocations
      GC.start
      before = GC.stat(:total_allocated_objects)
      BUILDS.times { yield }
      GC.stat(:total_allocated_objects) - before
    end

    it 'skips a hash which contains itself instead of recursing into it' do
      data = { a: { b: 'c' } }
      data[:d] = data
      assert_equal ' data-a-b="c"', build(data: data)

      aria = { a: { b: 'c' } }
      aria[:d] = aria
      assert_equal ' aria-a-b="c"', build(aria: aria)
    end

    it 'changes underscores in a nested key to hyphens' do
      assert_equal ' data-raw-src="foo"', build(data: { raw_src: 'foo' })
      assert_equal ' data-raw-src="foo"', build('data' => { 'raw_src' => 'foo' })
      assert_equal ' data-a-b-c="1"',     build(data: { a_b_c: 1 })
      assert_equal ' aria-raw-src="foo"', build(aria: { raw_src: 'foo' })
    end

    it 'leaves a nested key without an underscore alone' do
      assert_equal ' data-src="foo"',     build(data: { src: 'foo' })
      assert_equal ' data-raw-src="foo"', build('data' => { 'raw-src' => 'foo' })
    end

    it 'hyphenates every level of a nested hash' do
      assert_equal ' data-raw-src-url="foo"', build(data: { raw_src: { url: 'foo' } })
      assert_equal ' data-a-b-c-d="1"',       build(data: { a_b: { c_d: 1 } })
    end

    it 'keeps stringifying a nested key which is neither Symbol nor String' do
      assert_equal ' data-1="2"',    build(data: { 1 => 2 })
      assert_equal ' data-false',    build(data: { false => true })
      # A nil key names the prefix itself rather than a suffix of it.
      assert_equal ' data="3"',      build(data: { nil => 3 })
    end

    it 'allocates no more for a Symbol nested key than for the equivalent String key' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      symbol_key = { 'data' => { ab: 1 } }
      string_key = { 'data' => { 'ab' => 1 } }
      build(symbol_key)
      build(string_key)

      extra = allocations { build(symbol_key) } - allocations { build(string_key) }
      # Was BUILDS: k.to_s allocated one String per Symbol key per build.
      assert_operator extra, :<, BUILDS / 10
    end

    it 'allocates less for a nested key with no underscore to convert' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      without_underscore = { 'data' => { 'ab' => 1 } }
      with_underscore    = { 'data' => { 'a_b' => 1 } }
      build(without_underscore)
      build(with_underscore)

      saved = allocations { build(with_underscore) } - allocations { build(without_underscore) }
      # Was 0: tr allocated a String per key per build even with nothing to replace.
      assert_operator saved, :>, BUILDS / 2
    end
  end

  # Whatever Escape emits for `=` when use_html_safe is on, which is the default whenever
  # ActiveSupport is loaded. test_helper requires rails before haml, so these run against
  # the variant Util picks when html_safe? exists.
  describe 'html safe escaping' do
    class ::TosSafeBufferObject
      def to_s
        '<hr>'.html_safe
      end
    end

    it 'escapes a value which is not html_safe' do
      assert_equal '&lt;b&gt;', Haml::Util.escape_html_safe('<b>')
      assert_equal '', Haml::Util.escape_html_safe(nil)
      assert_equal '1/1', Haml::Util.escape_html_safe(1.to_r)
    end

    it 'passes an html_safe value through untouched' do
      safe = '<b>'.html_safe
      assert_equal '<b>', Haml::Util.escape_html_safe(safe)
      assert_same safe, Haml::Util.escape_html_safe(safe)
    end

    it 'asks html_safe? of to_s, not of the object' do
      # Kaminari-style object: not html_safe itself, but its to_s is.
      assert_equal '<hr>', Haml::Util.escape_html_safe(::TosSafeBufferObject.new)
    end

    it 'does not ask respond_to? per value when html_safe? is available' do
      skip 'iseq introspection is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      disasm = RubyVM::InstructionSequence.of(Haml::Util.method(:escape_html_safe)).disasm
      # The guard used to run on every escaped value, though html_safe? is on Object
      # as soon as ActiveSupport is loaded, so it could never be false here.
      refute_includes disasm, 'respond_to?'
      assert_includes disasm, 'html_safe?'
    end

    it 'keeps the guard when ActiveSupport is not loaded' do
      skip 'subprocess test is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      script = <<~RUBY
        require 'haml'
        abort 'ActiveSupport leaked into the child' if ''.respond_to?(:html_safe?)
        print Haml::Util.escape_html_safe('<b>')
        print '|'
        require 'active_support/core_ext/string/output_safety'
        print Haml::Util.escape_html_safe('<b>'.html_safe)
      RUBY
      lib = File.expand_path('../../lib', __dir__)
      out = IO.popen([RbConfig.ruby, '-I', lib, '-e', script], &:read)

      assert_predicate $?, :success?
      # Escapes without ActiveSupport, and still adapts if it shows up later, which is
      # the only reason the guarded variant exists.
      assert_equal '&lt;b&gt;|<b>', out
    end
  end

  # `~` (preserve) used to rebuild its tag regex on every call, and the code the compiler
  # emits carried the tag list as a literal, reallocated per render.
  describe 'preserve regexes' do
    CALLS = 1000

    def find_and_preserve(*args)
      Haml::Compiler::ScriptCompiler.find_and_preserve(*args)
    end

    def allocations
      GC.start
      before = GC.stat(:total_allocated_objects)
      CALLS.times { yield }
      GC.stat(:total_allocated_objects) - before
    end

    it 'emits a reference to the tag list instead of a literal' do
      # Only `!~` and escape_html: false reach find_and_preserve; a plain `~` under the
      # default escape_html: true is escaped instead.
      [compiled_code(%Q{- x = 1\n!~ x}), rails_compiled_code(%Q{- x = 1\n!~ x})].each do |code|
        assert_includes code, '::Haml::Helpers::DEFAULT_PRESERVE_TAGS'
        refute_includes code, '%w(textarea pre code)'
      end
    end

    it 'builds one regex per tag list' do
      default = Haml::Helpers::DEFAULT_PRESERVE_TAGS
      assert_same Haml::Helpers.preserve_regex(default), Haml::Helpers.preserve_regex(default)
      # A literal spelled out by a caller is the same list, so it must hit the same entry.
      assert_same Haml::Helpers.preserve_regex(default), Haml::Helpers.preserve_regex(%w[textarea pre code])
      assert_same Haml::Helpers.preserve_regex(%w[b]), Haml::Helpers.preserve_regex(%w[b])
      refute_same Haml::Helpers.preserve_regex(%w[b]), Haml::Helpers.preserve_regex(%w[i])
    end

    it 'stops rebuilding the regex per call' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      tags = Haml::Helpers::DEFAULT_PRESERVE_TAGS
      Haml::Helpers.preserve_regex(tags)

      cached = allocations { Haml::Helpers.preserve_regex(tags) }
      built  = allocations { Haml::Helpers.send(:build_preserve_regex, tags) }
      # Was what building costs: map + Regexp.escape per tag + join + Regexp, ~14 objects.
      assert_operator built - cached, :>, CALLS * 5
    end

    it 'renders a preserved value with only haml/engine required' do
      skip 'subprocess test is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      # haml/helpers is loaded by haml/template and haml/rails_helpers, neither of which
      # haml/engine pulls in, so this used to raise NameError at render time.
      script = <<~'RUBY'
        require 'haml/engine'
        haml = %Q{- x = ["<pre>a\\nb</pre>"].first\n~ x\n}
        print eval(Haml::Engine.new(escape_html: false).call(haml))
      RUBY
      lib = File.expand_path('../../lib', __dir__)
      out = IO.popen([RbConfig.ruby, '-I', lib, '-e', script], &:read)

      assert_predicate $?, :success?
      assert_equal %Q{<pre>a&#x000A;b</pre>\n}, out
    end

    it 'preserves newlines inside the default tags' do
      assert_render(%Q{<pre>a&#x000A;b</pre>\n}, %Q{- x = ["<pre>a\\nb</pre>"].first\n!~ x})
      assert_render(%Q{<textarea>a&#x000A;b</textarea>\n},
                    %Q{- x = ["<textarea>a\\nb</textarea>"].first\n!~ x})
      # Compiled away by static_compile rather than emitted, but through the same method.
      assert_render(%Q{<pre>a&#x000A;b</pre>\n}, %Q{~ ["<pre>a\\nb</pre>"][0]}, escape_html: false)
    end

    it 'matches the same tags as before' do
      assert_equal '<b>a&#x000A;b</b>', find_and_preserve("<b>a\nb</b>", %w[b])
      assert_equal '<b>a&#x000A;b</b>', find_and_preserve("<b>a\nb</b>", [:b])
      assert_equal "<b>a\nb</b>",       find_and_preserve("<b>a\nb</b>")
      assert_equal '<PRE>a&#x000A;b</PRE>', find_and_preserve("<PRE>a\nb</PRE>")
      assert_equal '<pre class="x">a&#x000A;b</pre>', find_and_preserve(%Q{<pre class="x">a\nb</pre>})
      # An empty list still builds a regex, one that needs a </> to close.
      assert_equal "<pre>a\nb</pre>", find_and_preserve("<pre>a\nb</pre>", [])
      # Regexp.escape still applies to a tag carrying regex syntax.
      assert_equal '<a.b>a&#x000A;b</a.b>', find_and_preserve("<a.b>a\nb</a.b>", ['a.b'])
      assert_equal '13', find_and_preserve(13)
      assert_equal '',   find_and_preserve(nil)
    end

    it 'keeps a cached list working after the caller mutates its own array' do
      tags = %w[b]
      assert_equal '<b>a&#x000A;b</b>', find_and_preserve("<b>a\nb</b>", tags)
      tags << 'i'
      assert_equal '<i>a&#x000A;b</i>', find_and_preserve("<i>a\nb</i>", tags)
      assert_equal '<b>a&#x000A;b</b>', find_and_preserve("<b>a\nb</b>", %w[b])
    end
  end

  # The parser interpolated the flat-block indentation, the current line's indentation and
  # the attribute quote character straight into regex literals, inside loops that run once
  # per template line. Compiling benchmark/etc/real_sample.haml built 1200+ Regexps.
  describe 'parser regexes' do
    COMPILES = 20

    def parse(haml)
      Haml::Parser.new({}).call(haml)
    end

    # The text a filter or -# block collected, wherever it sits in the tree.
    def flat_text(haml)
      find = lambda do |node|
        return node if node.type == :filter || node.type == :haml_comment
        node.children.each { |child| (found = find.call(child)) and return found }
        nil
      end
      find.call(parse(haml))&.value&.[](:text)
    end

    def compile_allocations(haml)
      Haml::Engine.new.call(haml)
      GC.start
      before = GC.stat(:total_allocated_objects)
      COMPILES.times { Haml::Engine.new.call(haml) }
      (GC.stat(:total_allocated_objects) - before) / COMPILES.to_f
    end

    it 'compiles no regex while parsing' do
      skip 'iseq introspection is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      names = Haml::Parser.instance_methods(false) + Haml::Parser.private_instance_methods(false)
      interpolating = names.select do |name|
        iseq = RubyVM::InstructionSequence.of(Haml::Parser.instance_method(name))
        iseq&.disasm&.include?('toregexp')
      end
      # toregexp builds a Regexp at runtime. call, compute_tabs, closes_flat?, next_line,
      # filter_opened? and parse_new_attribute each had one, all of them inside a loop.
      assert_empty interpolating
    end

    it 'keeps a whitespace-only line in a filter whose indentation is not known yet' do
      # Nothing has established the template's indentation when this filter opens, so
      # @flat_spaces is still empty. The regex was /^/ there: it matched the empty prefix,
      # so gsub! reported a substitution and the line survived. delete_prefix! reports
      # nothing for an empty argument, which would have emptied the line instead.
      assert_equal " \nfoo\n", flat_text(":plain\n \n  foo\n")
      # Once the indentation is known the same line no longer carries it and is emptied.
      assert_equal "a\n\nb\n", flat_text("%p\n  :plain\n    a\n \n    b\n")
    end

    it 'strips the same flat-block indentation as the interpolated anchor did' do
      assert_equal "a\n\nb\n",        flat_text(":plain\n  a\n\n  b\n")
      assert_equal "a\n    b\nc\n",   flat_text(":plain\n  a\n      b\n  c\n")
      assert_equal "a\n\t\tb\n",      flat_text(":plain\n\ta\n\t\t\tb\n")
      assert_equal "a  \nb\n",        flat_text(":plain\n  a  \n  b\n")
      assert_equal "%p not haml\n",   flat_text(":plain\n  %p not haml\n")
      assert_equal "a\nb\n",          flat_text("%div\n  %p\n    :plain\n      a\n      b\n")
      assert_equal "a\n",             flat_text("%div\n  :plain\n    a\n  %p x\n%p y\n")
      assert_equal "a\n      b\n",    flat_text("%div\n  :plain\n    a\n          b\n")
      assert_nil                      flat_text("%p x\n:plain\n%p y\n")
      # -# runs the same code, without the special case that keeps a blank line after a filter.
      assert_equal "foo\n",           flat_text("-#\n \n  foo\n%p y\n")
      assert_equal "a\n\nb\n",        flat_text("-#\n  a\n\n  b\n")
      assert_equal " text\na\nb\n",   flat_text("-# text\n  a\n  b\n")
    end

    it 'resets the flat indentation between two blocks' do
      # close_flat_section clears @flat_spaces, which is now '' rather than nil.
      assert_equal ["a\n", "b\n"], parse(":plain\n  a\n:plain\n  b\n").children.map { |c| c.value[:text] }
    end

    it 'keeps the scanner regex it used to interpolate per attribute value' do
      %w[" '].each do |quote|
        assert_equal(/((?:\\.|\#(?!\{)|[^#{quote}\\#])*)(#{quote}|#\{)/,
                     Haml::Parser::NEW_ATTRIBUTE_VALUE_REGEX[quote])
      end
      # parse_new_attribute reaches this after scanner.scan(/["']/), so there is no third key.
      assert_equal ['"', "'"], Haml::Parser::NEW_ATTRIBUTE_VALUE_REGEX.keys.sort
    end

    it 'scans a quoted attribute value the same for both quote characters' do
      assert_render %Q{<a href="x"></a>\n},              %q{%a(href="x")}
      assert_render %Q{<a href="x"></a>\n},              %q{%a(href='x')}
      assert_render %Q{<a title="it&#39;s"></a>\n},      %q{%a(title="it's")}
      assert_render %Q{<a title="say &quot;hi&quot;"></a>\n}, %q{%a(title='say "hi"')}
      assert_render %Q{<a title="a&quot;b"></a>\n},      %q{%a(title="a\\"b")}
      assert_render %Q{<a title="a&#39;b"></a>\n},       %q{%a(title='a\\'b')}
      assert_render %Q{<a href="#"></a>\n},              %q{%a(href="#")}
      assert_render %Q{<a href="#top"></a>\n},           %q{%a(href="#top")}
      assert_render %Q{<a href=""></a>\n},               %q{%a(href="")}
      assert_render %Q{<a href="x" title="y"></a>\n},    %q{%a(href="x" title='y')}
      assert_render %Q{<a title="héllo ☃"></a>\n},       %q{%a(title="héllo ☃")}
      assert_render %Q{<a href="/u/1"></a>\n},           %Q{- v = 1\n%a(href="/u/\#{v}")}
      assert_render %Q{<a href="/u/1"></a>\n},           %Q{- v = 1\n%a(href='/u/\#{v}')}
      assert_render %Q{<a href="#1"></a>\n},             %Q{- v = 1\n%a(href="\#\#{v}")}
    end

    it 'stops allocating a regex per line of a filter body' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      short = ":plain\n" + "  content line\n" * 10
      long  = ":plain\n" + "  content line\n" * 110

      per_line = (compile_allocations(long) - compile_allocations(short)) / 100.0
      # Was 34: an interpolated Regexp and its source String for the body line, another
      # pair for closes_flat?, and what gsub! allocates on top of them. Now 10.
      assert_operator per_line, :<, 20
    end
  end

  # Util.balance built its scanning Regexp on every call, and it is called once per
  # interpolation, per object reference and per conditional comment.
  describe 'balance regexes' do
    BALANCES = 1000

    def balance(*args)
      Haml::Util.balance(*args)
    end

    def allocations
      GC.start
      before = GC.stat(:total_allocated_objects)
      BALANCES.times { yield }
      GC.stat(:total_allocated_objects) - before
    end

    it 'keeps the regex it used to build per call' do
      regexes = Haml::Util.const_get(:BALANCE_REGEXES)
      [['{', '}'], ['[', ']'], ['(', ')']].each do |start, finish|
        assert_equal Regexp.new("(.*?)[\\#{start}\\#{finish}]", Regexp::MULTILINE),
                     regexes.dig(start, finish)
      end
      # Interpolation and new attribute values use {}, object references and conditional
      # comments use [], and parse_new_attributes uses () on its way to raising.
      assert_equal ['(', '[', '{'], regexes.keys.sort
    end

    it 'stops rebuilding the regex per call' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      balance('a} b', '{', '}', 1)
      balance('a> b', '<', '>', 1)

      cached   = allocations { balance('a} b', '{', '}', 1) }
      fallback = allocations { balance('a> b', '<', '>', 1) }
      # Was the same on both: every pair went through Regexp.new, 6 objects a call.
      assert_operator fallback - cached, :>, BALANCES * 5
    end

    it 'keeps working for a pair it has no regex for' do
      assert_equal ['<a>', ' rest'], balance('<a> rest', '<', '>')
      # A mismatched pair has to fall back rather than pick up the regex for '{'.
      assert_equal ['a]', ' rest'],  balance('a] rest', '{', ']', 1)
    end

    it 'balances the same pairs as before' do
      assert_equal ['a}', ' rest'],        balance('a} rest', '{', '}', 1)
      assert_equal ['[@user]', ' text'],   balance('[@user] text', '[', ']')
      assert_equal ['(a (b) c)', ' rest'], balance('(a (b) c) rest', '(', ')')
      assert_nil                           balance('no delimiters here', '{', '}', 1)
      assert_nil                           balance('a { b { c } d } e', '{', '}', 1)

      # A StringScanner receiver is moved in place; a String is wrapped in a fresh one.
      scanner = StringScanner.new('user.id} and more')
      assert_equal ['user.id}', ' and more'], balance(scanner, '{', '}', 1)
      assert_equal ' and more', scanner.rest
    end

    it 'renders the shapes that reach balance' do
      assert_render %Q{<p>1</p>\n},                     %q[%p #{1}]
      assert_render %Q{<p>1</p>\n},                     %q[%p #{ {a: 1}[:a] }]
      assert_render %Q{<p>[1, 2]</p>\n},                %q[%p #{ [1,2].map { |i| i } }]
      assert_render %Q{<p>\#{not_interp}</p>\n},        %q[%p \#{not_interp}]
      assert_render %Q{<p>[not an object ref]</p>\n},   %q[%p [not an object ref]]
      assert_render %Q{<!--[if IE]> hi <![endif]-->\n}, %q[/[if IE] hi]
      assert_render %Q{<a href="/u/1"></a>\n},          %Q{- v = 1\n%a(href="/u/\#{v}")}
    end
  end

  # contains_interpolation? ran Regexp#=== once per line of text, attribute value, comment and
  # filter body, and the lookup tables around it were Array literals rebuilt per line.
  describe 'interpolation and keyword lookups' do
    CHECKS = 1000

    PER_LINE_ARRAY_METHODS = %i[
      process_line silent_script check_push_script_stack close_silent_script parse_old_attributes
    ].freeze

    def parse(haml)
      Haml::Parser.new({}).call(haml)
    end

    def allocations
      GC.start
      before = GC.stat(:total_allocated_objects)
      CHECKS.times { yield }
      GC.stat(:total_allocated_objects) - before
    end

    it 'stops allocating a MatchData per interpolation check' do
      skip 'allocation counting is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      hit  = %q{text #{value} more}
      miss = 'text with none of it'
      [hit, miss].each { |s| Haml::Util.contains_interpolation?(s) }

      # Regexp#=== cost 3 objects on a match and 1-2 on a miss, for a $~ nothing reads.
      assert_operator allocations { Haml::Util.contains_interpolation?(hit) },  :<, CHECKS
      assert_operator allocations { Haml::Util.contains_interpolation?(miss) }, :<, CHECKS
    end

    it 'keeps the lookup tables it used to rebuild per line' do
      assert_equal %w[{ @ $],           Haml::Parser::INTERPOLATION_CHARS
      assert_equal %w[if case unless],  Haml::Parser::SCRIPT_STACK_KEYWORDS
      assert_equal %w[else elsif when], Haml::Parser::SCRIPT_STACK_MID_KEYWORDS
      assert_equal %i[BRACE_LEFT LAMBDA_BEGIN EMBEXPR_BEGIN], Haml::Parser::OLD_ATTRIBUTE_OPEN_TOKENS
      assert_equal %i[BRACE_RIGHT EMBEXPR_END], Haml::Parser::OLD_ATTRIBUTE_CLOSE_TOKENS

      %i[INTERPOLATION_CHARS SCRIPT_STACK_KEYWORDS SCRIPT_STACK_MID_KEYWORDS
         OLD_ATTRIBUTE_OPEN_TOKENS OLD_ATTRIBUTE_CLOSE_TOKENS].each do |name|
        assert_predicate Haml::Parser.const_get(name), :frozen?, name
      end

      # Narrower than the block-keyword lists, which also build the block regexes.
      refute_equal Haml::Parser::START_BLOCK_KEYWORDS, Haml::Parser::SCRIPT_STACK_KEYWORDS
      refute_equal Haml::Parser::MID_BLOCK_KEYWORDS,   Haml::Parser::SCRIPT_STACK_MID_KEYWORDS
    end

    it 'builds no Array literal in the per-line lookups' do
      skip 'iseq introspection is CRuby-specific' unless RUBY_ENGINE == 'ruby'
      # Both opcodes: Ruby <= 3.3 emits duparray, 4.0 folds `[...].include?` into
      # opt_newarray_send. newarray is excluded, its arrays carry data, not lookups.
      building = PER_LINE_ARRAY_METHODS.select do |name|
        disasm = RubyVM::InstructionSequence.of(Haml::Parser.instance_method(name)).disasm
        disasm.include?('duparray') || disasm.include?('opt_newarray_send')
      end
      assert_empty building
    end

    it 'reports interpolation for the same strings as before' do
      [%q{a #{1}}, 'a #@ivar', 'a #$global', '#{', '#@', '#$', %q{\#{x}}].each do |str|
        assert Haml::Util.contains_interpolation?(str), str.inspect
      end
      ['a # b', 'plain', '', '#', nil].each do |str|
        refute Haml::Util.contains_interpolation?(str), str.inspect
      end
    end

    it 'still tells a div id from an interpolated line' do
      assert_render %Q{<div id="main">content</div>\n},          %q{#main content}
      assert_render %Q{<div class="wide" id="main">x</div>\n},   %q{#main.wide x}
      assert_render %Q{2\n},                                     %q{#{1 + 1}}
      assert_render %Q{<p>text 2 more</p>\n},                    %q{%p text #{1 + 1} more}
      assert_render %Q{<p>a # b</p>\n},                          %q{%p a # b}
      assert_render %Q{<p>x</p>\n},                              %Q{-# hidden\n%p x}
      assert_raises(Haml::SyntaxError) { parse(%q{#}) }
    end

    it 'nests silent scripts against the same keyword sets' do
      assert_render %Q{<p>b</p>\n}, %Q{- if false\n  %p a\n- elsif true\n  %p b\n}
      assert_render %Q{<p>c</p>\n}, %Q{- if false\n  %p a\n- elsif false\n  %p b\n- else\n  %p c\n}
      assert_render %Q{<p>a</p>\n}, %Q{- unless false\n  %p a\n- else\n  %p b\n}
      assert_render %Q{<p>b</p>\n}, %Q{- case 2\n- when 1\n  %p a\n- when 2\n  %p b\n}
      assert_render %Q{<p>c</p>\n}, %Q{- case 3\n- when 1\n  %p a\n- else\n  %p c\n}
      assert_render %Q{<p>a</p>\n}, %Q{- case 1\n  - when 1\n    %p a\n}
      assert_render %Q{<p>a</p>\n}, %Q{- begin\n  %p a\n- rescue\n  %p b\n}
      assert_render %Q{<p>a</p>\n<p>c</p>\n}, %Q{- if true\n  - case 1\n  - when 1\n    %p a\n- if true\n  %p c\n}

      # Reusing START_BLOCK_KEYWORDS here would make this shape a Ruby SyntaxError, not a Haml one.
      assert_raises(Haml::SyntaxError) { parse(%Q{- begin\n  %p a\n- else\n  %p b\n}) }
      assert_raises(Haml::SyntaxError) { parse(%Q{- else\n  %p a\n}) }
      assert_raises(Haml::SyntaxError) { parse(%Q{- when 1\n  %p a\n}) }
      assert_raises(Haml::SyntaxError) { parse(%Q{- if true\n  %p a\n  - else\n    %p b\n}) }
    end

    it 'balances an old-syntax attribute hash against the same token lists' do
      assert_render %Q[<p title="a } b">x</p>\n],  %q[%p{ title: "a } b" } x]
      assert_render %Q{<p title="a 1 b">x</p>\n},  %q{%p{ title: "a #{1} b" } x}
      assert_render %Q{<p v="[1, 2]">x</p>\n},     %q{%p{ v: [1,2].map { |i| i } } x}
      assert_render %Q{<p a="1" b="2">x</p>\n},    %Q{%p{ a: 1,\n    b: 2 } x}
      assert_render %Q{<p data-a="1">x</p>\n},     %q{%p{ data: { a: 1 } } x}
      assert_render %Q{<p class="a" id="b">x</p>\n}, %q{%p{ class: 'a' }(id='b') x}
      assert_raises(Haml::SyntaxError) { parse(%q[%p{ class: 'a' x]) }
    end
  end
end
