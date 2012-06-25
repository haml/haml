module Haml
  # An exception raised by Haml code.
  class Error < StandardError

    MESSAGES = {
      :illegal_nesting_header       => "Illegal nesting: nesting within a header command is illegal.",
      :illegal_nesting_plain        => "Illegal nesting: nesting within plain text is illegal.",
      :illegal_nesting_content      => "Illegal nesting: nesting within a tag that already has content is illegal.",
      :illegal_nesting_self_closing => "Illegal nesting: nesting within a self-closing tag is illegal.",
      :invalid_tag                  => 'Invalid tag: "%s".',
      :illegal_element              => "Illegal element: classes and ids must have values.",
      :no_ruby_code                 => "There's no Ruby code for %s to evaluate.",
      :self_closing_content         => "Self-closing tags can't have content.",
      :invalid_filter_name          => 'Invalid filter name ":%s".',
      :filter_not_defined           => 'Filter "%s" is not defined.',
      :indenting_at_start           => "Indenting at the beginning of the document is illegal.",
      :illegal_nesting_line         => "Illegal nesting: content can't be both given on the same line as %%%s and nested within it.",
      :invalid_attribute_list       => 'Invalid attribute list: %s.',
      :unbalanced_brackets          => 'Unbalanced brackets.',
      :install_haml_contrib         => 'To use the "%s" filter, please install the haml-contrib gem.',
      :gem_install_filter_deps      => '"%s" filter\'s %s dependency missing: try installing it or adding it to your Gemfile',
      :cant_run_filter              => 'Can\'t run "%s" filter; you must require its dependencies first',
      :no_end                       => <<-END
You don't need to use "- end" in Haml. Un-indent to close a block:
- if foo?
  %strong Foo!
- else
  Not foo.
%p This line is un-indented, so it isn't part of the "if" block
END
    }

    def self.message(key, *args)
      string = MESSAGES[key] or raise "[HAML BUG] No error messages for #{key}"
      (args.empty? ? string : string % args).rstrip
    end

    # The line of the template on which the error occurred.
    #
    # @return [Fixnum]
    attr_reader :line

    # @param message [String] The error message
    # @param line [Fixnum] See \{#line}
    def initialize(message = nil, line = nil)
      super(message)
      @line = line
    end
  end

  # SyntaxError is the type of exception raised when Haml encounters an
  # ill-formatted document.
  # It's not particularly interesting,
  # except in that it's a subclass of {Haml::Error}.
  class SyntaxError < Haml::Error; end
end
