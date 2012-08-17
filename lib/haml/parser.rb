require 'strscan'

module Haml
  class Parser
    include Haml::Util

    attr_reader :root

    # Designates an XHTML/XML element.
    ELEMENT         = ?%

    # Designates a `<div>` element with the given class.
    DIV_CLASS       = ?.

    # Designates a `<div>` element with the given id.
    DIV_ID          = ?#

    # Designates an XHTML/XML comment.
    COMMENT         = ?/

    # Designates an XHTML doctype or script that is never HTML-escaped.
    DOCTYPE         = ?!

    # Designates script, the result of which is output.
    SCRIPT          = ?=

    # Designates script that is always HTML-escaped.
    SANITIZE        = ?&

    # Designates script, the result of which is flattened and output.
    FLAT_SCRIPT     = ?~

    # Designates script which is run but not output.
    SILENT_SCRIPT   = ?-

    # When following SILENT_SCRIPT, designates a comment that is not output.
    SILENT_COMMENT  = ?#

    # Designates a non-parsed line.
    ESCAPE          = ?\\

    # Designates a block of filtered text.
    FILTER          = ?:

    # Designates a non-parsed line. Not actually a character.
    PLAIN_TEXT      = -1

    # Keeps track of the ASCII values of the characters that begin a
    # specially-interpreted line.
    SPECIAL_CHARACTERS   = [
      ELEMENT,
      DIV_CLASS,
      DIV_ID,
      COMMENT,
      DOCTYPE,
      SCRIPT,
      SANITIZE,
      FLAT_SCRIPT,
      SILENT_SCRIPT,
      ESCAPE,
      FILTER
    ]

    # The value of the character that designates that a line is part
    # of a multiline string.
    MULTILINE_CHAR_VALUE = ?|

    # Regex to check for blocks with spaces around arguments. Not to be confused
    # with multiline script.
    # For example:
    #     foo.each do | bar |
    #       = bar
    #
    BLOCK_WITH_SPACES = /do[\s]*\|[\s]*[^\|]*[\s]+\|\z/

    MID_BLOCK_KEYWORDS = %w[else elsif rescue ensure end when]
    START_BLOCK_KEYWORDS = %w[if begin case unless]
    # Try to parse assignments to block starters as best as possible
    START_BLOCK_KEYWORD_REGEX = /(?:\w+(?:,\s*\w+)*\s*=\s*)?(#{START_BLOCK_KEYWORDS.join('|')})/
    BLOCK_KEYWORD_REGEX = /^-?\s*(?:(#{MID_BLOCK_KEYWORDS.join('|')})|#{START_BLOCK_KEYWORD_REGEX.source})\b/

    # The Regex that matches a Doctype command.
    DOCTYPE_REGEX = /(\d(?:\.\d)?)?[\s]*([a-z]*)\s*([^ ]+)?/i

    # The Regex that matches a literal string or symbol value
    LITERAL_VALUE_REGEX = /:(\w*)|(["'])((?![\\#]|\2).|\\.)*\2/


    def initialize(template, options)
      # :eod is a special end-of-document marker
      @template           = (template.rstrip).split(/\r\n|\r|\n/) + [:eod, :eod]
      @options            = options
      @flat               = false
      @index              = 0
      # Record the indent levels of "if" statements to validate the subsequent
      # elsif and else statements are indented at the appropriate level.
      @script_level_stack = []
      @template_index     = 0
      @template_tabs      = 0
    end

    def parse
      @root = @parent = ParseNode.new(:root)
      @haml_comment = false
      @indentation = nil
      @line = next_line

      raise SyntaxError.new(Error.message(:indenting_at_start), @line.index) if @line.tabs != 0

      while next_line
        process_indent(@line) unless @line.text.empty?

        if flat?
          text = @line.full.dup
          text = "" unless text.gsub!(/^#{@flat_spaces}/, '')
          @filter_buffer << "#{text}\n"
          @line = @next_line
          next
        end

        @tab_up = nil
        process_line(@line.text, @line.index) unless @line.text.empty? || @haml_comment
        if @parent.type != :haml_comment && (block_opened? || @tab_up)
          @template_tabs += 1
          @parent = @parent.children.last
        end

        if !@haml_comment && !flat? && @next_line.tabs - @line.tabs > 1
          raise SyntaxError.new(Error.message(:deeper_indenting, @next_line.tabs - @line.tabs), @next_line.index)
        end

        @line = @next_line
      end

      # Close all the open tags
      close until @parent.type == :root
      @root
    rescue Haml::Error => e
      e.backtrace.unshift "#{@options[:filename]}:#{(e.line ? e.line + 1 : @index) + @options[:line] - 1}"
      raise
    end


    private

    # @private
    class Line < Struct.new(:text, :unstripped, :full, :index, :compiler, :eod)
      alias_method :eod?, :eod

      # @private
      def tabs
        line = self
        @tabs ||= compiler.instance_eval do
          break 0 if line.text.empty? || !(whitespace = line.full[/^\s+/])

          if @indentation.nil?
            @indentation = whitespace

            if @indentation.include?(?\s) && @indentation.include?(?\t)
              raise SyntaxError.new(Error.message(:cant_use_tabs_and_spaces), line.index)
            end

            @flat_spaces = @indentation * (@template_tabs+1) if flat?
            break 1
          end

          tabs = whitespace.length / @indentation.length
          break tabs if whitespace == @indentation * tabs
          break @template_tabs + 1 if flat? && whitespace =~ /^#{@flat_spaces}/

          message = Error.message(:inconsistent_indentation,
            Haml::Util.human_indentation(whitespace),
            Haml::Util.human_indentation(@indentation)
          )
          raise SyntaxError.new(message, line.index)
        end
      end
    end

    # @private
    class ParseNode < Struct.new(:type, :line, :value, :parent, :children)
      def initialize(*args)
        super
        self.children ||= []
      end

      def inspect
        text = "(#{type} #{value.inspect}"
        children.each {|c| text << "\n" << c.inspect.gsub(/^/, "  ")}
        text + ")"
      end
    end

    # Processes and deals with lowering indentation.
    def process_indent(line)
      return unless line.tabs <= @template_tabs && @template_tabs > 0

      to_close = @template_tabs - line.tabs
      to_close.times {|i| close unless to_close - 1 - i == 0 && mid_block_keyword?(line.text)}
    end

    # Processes a single line of Haml.
    #
    # This method doesn't return anything; it simply processes the line and
    # adds the appropriate code to `@precompiled`.
    def process_line(text, index)
      @index = index + 1

      case text[0]
      when DIV_CLASS; push div(text)
      when DIV_ID
        return push plain(text) if text[1] == ?{
        push div(text)
      when ELEMENT; push tag(text)
      when COMMENT; push comment(text[1..-1].strip)
      when SANITIZE
        return push plain(text[3..-1].strip, :escape_html) if text[1..2] == "=="
        return push script(text[2..-1].strip, :escape_html) if text[1] == SCRIPT
        return push flat_script(text[2..-1].strip, :escape_html) if text[1] == FLAT_SCRIPT
        return push plain(text[1..-1].strip, :escape_html) if text[1] == ?\s
        push plain(text)
      when SCRIPT
        return push plain(text[2..-1].strip) if text[1] == SCRIPT
        push script(text[1..-1])
      when FLAT_SCRIPT; push flat_script(text[1..-1])
      when SILENT_SCRIPT; push silent_script(text)
      when FILTER; push filter(text[1..-1].downcase)
      when DOCTYPE
        return push doctype(text) if text[0...3] == '!!!'
        return push plain(text[3..-1].strip, false) if text[1..2] == "=="
        return push script(text[2..-1].strip, false) if text[1] == SCRIPT
        return push flat_script(text[2..-1].strip, false) if text[1] == FLAT_SCRIPT
        return push plain(text[1..-1].strip, false) if text[1] == ?\s
        push plain(text)
      when ESCAPE; push plain(text[1..-1])
      else; push plain(text)
      end
    end

    def block_keyword(text)
      return unless keyword = text.scan(BLOCK_KEYWORD_REGEX)[0]
      keyword[0] || keyword[1]
    end

    def mid_block_keyword?(text)
      MID_BLOCK_KEYWORDS.include?(block_keyword(text))
    end

    def push(node)
      @parent.children << node
      node.parent = @parent
    end

    def plain(text, escape_html = nil)
      if block_opened?
        raise SyntaxError.new(Error.message(:illegal_nesting_plain), @next_line.index)
      end

      unless contains_interpolation?(text)
        return ParseNode.new(:plain, @index, :text => text)
      end

      escape_html = @options[:escape_html] if escape_html.nil?
      script(unescape_interpolation(text, escape_html), false)
    end

    def script(text, escape_html = nil, preserve = false)
      raise SyntaxError.new(Error.message(:no_ruby_code, '=')) if text.empty?
      text = handle_ruby_multiline(text)
      escape_html = @options[:escape_html] if escape_html.nil?

      keyword = block_keyword(text)
      check_push_script_stack(keyword)

      ParseNode.new(:script, @index, :text => text, :escape_html => escape_html,
        :preserve => preserve, :keyword => keyword)
    end

    def flat_script(text, escape_html = nil)
      raise SyntaxError.new(Error.message(:no_ruby_code, '~')) if text.empty?
      script(text, escape_html, :preserve)
    end

    def silent_script(text)
      return haml_comment(text[2..-1]) if text[1] == SILENT_COMMENT

      raise SyntaxError.new(Error.message(:no_end), @index - 1) if text[1..-1].strip == "end"

      text = handle_ruby_multiline(text)
      keyword = block_keyword(text)

      check_push_script_stack(keyword)

      if ["else", "elsif", "when"].include?(keyword)
        if @script_level_stack.empty?
          raise Haml::SyntaxError.new(Error.message(:missing_if, keyword), @line.index)
        end

        if keyword == 'when' and !@script_level_stack.last[2]
          if @script_level_stack.last[1] + 1 == @line.tabs
            @script_level_stack.last[1] += 1
          end
          @script_level_stack.last[2] = true
        end

        if @script_level_stack.last[1] != @line.tabs
          message = Error.message(:bad_script_indent, keyword, @script_level_stack.last[1], @line.tabs)
          raise Haml::SyntaxError.new(message, @line.index)
        end
      end

      ParseNode.new(:silent_script, @index,
        :text => text[1..-1], :keyword => keyword)
    end

    def check_push_script_stack(keyword)
      if ["if", "case", "unless"].include?(keyword)
        # @script_level_stack contents are arrays of form
        # [:keyword, stack_level, other_info]
        @script_level_stack.push([keyword.to_sym, @line.tabs])
        @script_level_stack.last << false if keyword == 'case'
        @tab_up = true
      end
    end

    def haml_comment(text)
      @haml_comment = block_opened?
      ParseNode.new(:haml_comment, @index, :text => text)
    end

    def tag(line)
      tag_name, attributes, attributes_hashes, object_ref, nuke_outer_whitespace,
        nuke_inner_whitespace, action, value, last_line = parse_tag(line)

      preserve_tag = @options[:preserve].include?(tag_name)
      nuke_inner_whitespace ||= preserve_tag
      preserve_tag = false if @options[:ugly]
      escape_html = (action == '&' || (action != '!' && @options[:escape_html]))

      case action
      when '/'; self_closing = true
      when '~'; parse = preserve_script = true
      when '='
        parse = true
        if value[0] == ?=
          value = unescape_interpolation(value[1..-1].strip, escape_html)
          escape_html = false
        end
      when '&', '!'
        if value[0] == ?= || value[0] == ?~
          parse = true
          preserve_script = (value[0] == ?~)
          if value[1] == ?=
            value = unescape_interpolation(value[2..-1].strip, escape_html)
            escape_html = false
          else
            value = value[1..-1].strip
          end
        elsif contains_interpolation?(value)
          value = unescape_interpolation(value, escape_html)
          parse = true
          escape_html = false
        end
      else
        if contains_interpolation?(value)
          value = unescape_interpolation(value, escape_html)
          parse = true
          escape_html = false
        end
      end

      attributes = Parser.parse_class_and_id(attributes)
      attributes_list = []

      if attributes_hashes[:new]
        static_attributes, attributes_hash = attributes_hashes[:new]
        Buffer.merge_attrs(attributes, static_attributes) if static_attributes
        attributes_list << attributes_hash
      end

      if attributes_hashes[:old]
        static_attributes = parse_static_hash(attributes_hashes[:old])
        Buffer.merge_attrs(attributes, static_attributes) if static_attributes
        attributes_list << attributes_hashes[:old] unless static_attributes || @options[:suppress_eval]
      end

      attributes_list.compact!

      raise SyntaxError.new(Error.message(:illegal_nesting_self_closing), @next_line.index) if block_opened? && self_closing
      raise SyntaxError.new(Error.message(:no_ruby_code, action), last_line - 1) if parse && value.empty?
      raise SyntaxError.new(Error.message(:self_closing_content), last_line - 1) if self_closing && !value.empty?

      if block_opened? && !value.empty? && !is_ruby_multiline?(value)
        raise SyntaxError.new(Error.message(:illegal_nesting_line, tag_name), @next_line.index)
      end

      self_closing ||= !!(!block_opened? && value.empty? && @options[:autoclose].any? {|t| t === tag_name})
      value = nil if value.empty? && (block_opened? || self_closing)
      value = handle_ruby_multiline(value) if parse

      ParseNode.new(:tag, @index, :name => tag_name, :attributes => attributes,
        :attributes_hashes => attributes_list, :self_closing => self_closing,
        :nuke_inner_whitespace => nuke_inner_whitespace,
        :nuke_outer_whitespace => nuke_outer_whitespace, :object_ref => object_ref,
        :escape_html => escape_html, :preserve_tag => preserve_tag,
        :preserve_script => preserve_script, :parse => parse, :value => value)
    end

    # Renders a line that creates an XHTML tag and has an implicit div because of
    # `.` or `#`.
    def div(line)
      tag('%div' + line)
    end

    # Renders an XHTML comment.
    def comment(line)
      conditional, line = balance(line, ?[, ?]) if line[0] == ?[
      line.strip!
      conditional << ">" if conditional

      if block_opened? && !line.empty?
        raise SyntaxError.new(Haml::Error.message(:illegal_nesting_content), @next_line.index)
      end

      ParseNode.new(:comment, @index, :conditional => conditional, :text => line)
    end

    # Renders an XHTML doctype or XML shebang.
    def doctype(line)
      raise SyntaxError.new(Error.message(:illegal_nesting_header), @next_line.index) if block_opened?
      version, type, encoding = line[3..-1].strip.downcase.scan(DOCTYPE_REGEX)[0]
      ParseNode.new(:doctype, @index, :version => version, :type => type, :encoding => encoding)
    end

    def filter(name)
      raise Error.new(Error.message(:invalid_filter_name, name)) unless name =~ /^\w+$/

      @filter_buffer = String.new

      if filter_opened?
        @flat = true
        # If we don't know the indentation by now, it'll be set in Line#tabs
        @flat_spaces = @indentation * (@template_tabs+1) if @indentation
      end

      ParseNode.new(:filter, @index, :name => name, :text => @filter_buffer)
    end

    def close
      node, @parent = @parent, @parent.parent
      @template_tabs -= 1
      send("close_#{node.type}", node) if respond_to?("close_#{node.type}", :include_private)
    end

    def close_filter(_)
      @flat = false
      @flat_spaces = nil
      @filter_buffer = nil
    end

    def close_haml_comment(_)
      @haml_comment = false
    end

    def close_silent_script(node)
      @script_level_stack.pop if ["if", "case", "unless"].include? node.value[:keyword]

      # Post-process case statements to normalize the nesting of "when" clauses
      return unless node.value[:keyword] == "case"
      return unless first = node.children.first
      return unless first.type == :silent_script && first.value[:keyword] == "when"
      return if first.children.empty?
      # If the case node has a "when" child with children, it's the
      # only child. Then we want to put everything nested beneath it
      # beneath the case itself (just like "if").
      node.children = [first, *first.children]
      first.children = []
    end

    alias :close_script :close_silent_script

    # This is a class method so it can be accessed from {Haml::Helpers}.
    #
    # Iterates through the classes and ids supplied through `.`
    # and `#` syntax, and returns a hash with them as attributes,
    # that can then be merged with another attributes hash.
    def self.parse_class_and_id(list)
      attributes = {}
      list.scan(/([#.])([-:_a-zA-Z0-9]+)/) do |type, property|
        case type
        when '.'
          if attributes['class']
            attributes['class'] += " "
          else
            attributes['class'] = ""
          end
          attributes['class'] += property
        when '#'; attributes['id'] = property
        end
      end
      attributes
    end

    def parse_static_hash(text)
      attributes = {}
      scanner = StringScanner.new(text)
      scanner.scan(/\s+/)
      until scanner.eos?
        return unless key = scanner.scan(LITERAL_VALUE_REGEX)
        return unless scanner.scan(/\s*=>\s*/)
        return unless value = scanner.scan(LITERAL_VALUE_REGEX)
        return unless scanner.scan(/\s*(?:,|$)\s*/)
        attributes[eval(key).to_s] = eval(value).to_s
      end
      attributes
    end

    # Parses a line into tag_name, attributes, attributes_hash, object_ref, action, value
    def parse_tag(line)
      match = line.scan(/%([-:\w]+)([-:\w\.\#]*)(.*)/)[0]
      raise SyntaxError.new(Error.message(:invalid_tag, line)) unless match

      tag_name, attributes, rest = match

      if attributes =~ /[\.#](\.|#|\z)/
        raise SyntaxError.new(Error.message(:illegal_element))
      end

      new_attributes_hash = old_attributes_hash = last_line = nil
      object_ref = "nil"
      attributes_hashes = {}
      while rest
        case rest[0]
        when ?{
          break if old_attributes_hash
          old_attributes_hash, rest, last_line = parse_old_attributes(rest)
          attributes_hashes[:old] = old_attributes_hash
        when ?(
          break if new_attributes_hash
          new_attributes_hash, rest, last_line = parse_new_attributes(rest)
          attributes_hashes[:new] = new_attributes_hash
        when ?[
          break unless object_ref == "nil"
          object_ref, rest = balance(rest, ?[, ?])
        else; break
        end
      end

      if rest
        nuke_whitespace, action, value = rest.scan(/(<>|><|[><])?([=\/\~&!])?(.*)?/)[0]
        nuke_whitespace ||= ''
        nuke_outer_whitespace = nuke_whitespace.include? '>'
        nuke_inner_whitespace = nuke_whitespace.include? '<'
      end

      if @options[:remove_whitespace]
        nuke_outer_whitespace = true
        nuke_inner_whitespace = true
      end

      value = value.to_s.strip
      [tag_name, attributes, attributes_hashes, object_ref, nuke_outer_whitespace,
       nuke_inner_whitespace, action, value, last_line || @index]
    end

    def parse_old_attributes(line)
      line = line.dup
      last_line = @index

      begin
        attributes_hash, rest = balance(line, ?{, ?})
      rescue SyntaxError => e
        if line.strip[-1] == ?, && e.message == Error.message(:unbalanced_brackets)
          line << "\n" << @next_line.text
          last_line += 1
          next_line
          retry
        end

        raise e
      end

      attributes_hash = attributes_hash[1...-1] if attributes_hash
      return attributes_hash, rest, last_line
    end

    def parse_new_attributes(line)
      line = line.dup
      scanner = StringScanner.new(line)
      last_line = @index
      attributes = {}

      scanner.scan(/\(\s*/)
      loop do
        name, value = parse_new_attribute(scanner)
        break if name.nil?

        if name == false
          text = (Haml::Util.balance(line, ?(, ?)) || [line]).first
          raise Haml::SyntaxError.new(Error.message(:invalid_attribute_list, text.inspect), last_line - 1)
        end
        attributes[name] = value
        scanner.scan(/\s*/)

        if scanner.eos?
          line << " " << @next_line.text
          last_line += 1
          next_line
          scanner.scan(/\s*/)
        end
      end

      static_attributes = {}
      dynamic_attributes = "{"
      attributes.each do |name, (type, val)|
        if type == :static
          static_attributes[name] = val
        else
          dynamic_attributes << inspect_obj(name) << " => " << val << ","
        end
      end
      dynamic_attributes << "}"
      dynamic_attributes = nil if dynamic_attributes == "{}"

      return [static_attributes, dynamic_attributes], scanner.rest, last_line
    end

    def parse_new_attribute(scanner)
      unless name = scanner.scan(/[-:\w]+/)
        return if scanner.scan(/\)/)
        return false
      end

      scanner.scan(/\s*/)
      return name, [:static, true] unless scanner.scan(/=/) #/end

      scanner.scan(/\s*/)
      unless quote = scanner.scan(/["']/)
        return false unless var = scanner.scan(/(@@?|\$)?\w+/)
        return name, [:dynamic, var]
      end

      re = /((?:\\.|\#(?!\{)|[^#{quote}\\#])*)(#{quote}|#\{)/
      content = []
      loop do
        return false unless scanner.scan(re)
        content << [:str, scanner[1].gsub(/\\(.)/, '\1')]
        break if scanner[2] == quote
        content << [:ruby, balance(scanner, ?{, ?}, 1).first[0...-1]]
      end

      return name, [:static, content.first[1]] if content.size == 1
      return name, [:dynamic,
        '"' + content.map {|(t, v)| t == :str ? inspect_obj(v)[1...-1] : "\#{#{v}}"}.join + '"']
    end

    def raw_next_line
      text = @template.shift
      return unless text

      index = @template_index
      @template_index += 1

      return text, index
    end

    def next_line
      text, index = raw_next_line
      return unless text

      # :eod is a special end-of-document marker
      line =
        if text == :eod
          Line.new '-#', '-#', '-#', index, self, true
        else
          Line.new text.strip, text.lstrip.chomp, text, index, self, false
        end

      # `flat?' here is a little outdated,
      # so we have to manually check if either the previous or current line
      # closes the flat block, as well as whether a new block is opened.
      line_defined = instance_variable_defined?('@line')
      @line.tabs if line_defined
      unless (flat? && !closes_flat?(line) && !closes_flat?(@line)) ||
          (line_defined && @line.text[0] == ?: && line.full =~ %r[^#{@line.full[/^\s+/]}\s])
        return next_line if line.text.empty?

        handle_multiline(line)
      end

      @next_line = line
    end

    def closes_flat?(line)
      line && !line.text.empty? && line.full !~ /^#{@flat_spaces}/
    end

    def un_next_line(line)
      @template.unshift line
      @template_index -= 1
    end

    def handle_multiline(line)
      return unless is_multiline?(line.text)
      line.text.slice!(-1)
      while new_line = raw_next_line.first
        break if new_line == :eod
        next if new_line.strip.empty?
        break unless is_multiline?(new_line.strip)
        line.text << new_line.strip[0...-1]
      end
      un_next_line new_line
    end

    # Checks whether or not `line` is in a multiline sequence.
    def is_multiline?(text)
      text && text.length > 1 && text[-1] == MULTILINE_CHAR_VALUE && text[-2] == ?\s && text !~ BLOCK_WITH_SPACES
    end

    def handle_ruby_multiline(text)
      text = text.rstrip
      return text unless is_ruby_multiline?(text)
      un_next_line @next_line.full
      begin
        new_line = raw_next_line.first
        break if new_line == :eod
        next if new_line.strip.empty?
        text << " " << new_line.strip
      end while is_ruby_multiline?(new_line.strip)
      next_line
      text
    end

    # `text' is a Ruby multiline block if it:
    # - ends with a comma
    # - but not "?," which is a character literal
    #   (however, "x?," is a method call and not a literal)
    # - and not "?\," which is a character literal
    #
    def is_ruby_multiline?(text)
      text && text.length > 1 && text[-1] == ?, &&
        !((text[-3..-2] =~ /\W\?/) || text[-3..-2] == "?\\")
    end

    def balance(*args)
      res = Haml::Util.balance(*args)
      return res if res
      raise SyntaxError.new(Error.message(:unbalanced_brackets))
    end

    def block_opened?
      @next_line.tabs > @line.tabs
    end

    # Same semantics as block_opened?, except that block_opened? uses Line#tabs,
    # which doesn't interact well with filter lines
    def filter_opened?
      @next_line.full =~ (@indentation ? /^#{@indentation * @template_tabs}/ : /^\s/)
    end

    def flat?
      @flat
    end
  end
end
