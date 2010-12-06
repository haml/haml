#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/../test_helper'
require 'test/unit/assertions'

class ::RDiscount
  include( Test::Unit::Assertions )

  def initialize(text, *options)
    assert(options.include?(:filter_html))
  end

  def to_html
  end
end

module Haml
  module Filters
    module Base
      def required
        'rdiscount'
      end
    end
  end
end

class MarkdownTest < Test::Unit::TestCase

  def test_markdown_options_are_empty_by_default
    assert_equal([], Haml::Template.options[:markdown])
  end

  def test_markdown_options_are_passed_to_markdown_engine
    Haml::Template.options[:markdown] = [:filter_html]

    Haml::Filters::Markdown.render(":markdown\n  <script>alert('Hello')</script>")
  end

end
