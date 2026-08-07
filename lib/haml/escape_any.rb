# frozen_string_literal: true
require 'haml/escape'

module Haml
  # This module allows Temple::Filter to dispatch :fescape on `#compile`.
  module EscapeanyDispathcer
    def on_escapeany(flag, exp)
      [:escapeany, flag, compile(exp)]
    end
  end
  ::Temple::Filter.include EscapeanyDispathcer

  # Unlike Haml::Escape, this calls to_s when not escaped.
  class EscapeAny < Escape
    def initialize(opts = {})
      super
      @to_s = false
    end

    def on_escapeany(flag, exp)
      old_escape, old_to_s = @escape, @to_s
      @escape = flag && !options[:disable_escape]
      @to_s = !@escape
      compile(exp)
    ensure
      @escape, @to_s = old_escape, old_to_s
    end

    # to_s is appended only inside :escapeany. Every other [:dynamic] in the tree
    # belongs to somebody else -- the Escape pass already turned it into an
    # escape_html call, or it ends up in an interpolation or in the generator's
    # own `(...).to_s` -- so wrapping it here would just duplicate that call.
    def on_dynamic(value)
      if @escape
        [:dynamic, @escape_code % value]
      else
        [:dynamic, @to_s ? "(#{value}).to_s" : value]
      end
    end
  end
end
