# frozen_string_literal: true
module TemplateTestHelper
  TEMPLATE_PATH = File.join(__dir__, "templates")
end

module Haml::Filters::Test
  include Haml::Filters::Base

  def render(text)
    "TESTING HAHAHAHA!"
  end
end

module Haml::Helpers
  def test_partial(name, locals = {})
    Haml::Engine.new(File.read(File.join(TemplateTestHelper::TEMPLATE_PATH, "_#{name}.haml")), Haml::Template.options).render(self, locals)
  end
end

class Egocentic
  def method_missing(*args)
    self
  end
end

class DummyController
  attr_accessor :logger
  def initialize
    @logger = Egocentic.new
  end

  def self.controller_path
    ''
  end

  def controller_path
    ''
  end
end
