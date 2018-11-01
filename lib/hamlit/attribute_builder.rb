# frozen_string_literal: true
unless /java/ === RUBY_PLATFORM # exclude JRuby
  require 'hamlit/hamlit'
end
require 'hamlit/utils'
require 'hamlit/object_ref'

module Hamlit::AttributeBuilder
  BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seamless muted required
                       autofocus novalidate formnovalidate open pubdate
                       itemscope allowfullscreen default inert sortable
                       truespeed typemustmatch download].freeze
end
