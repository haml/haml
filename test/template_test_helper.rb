# frozen_string_literal: true

module TemplateTestHelper
  TEMPLATE_PATH = File.join(__dir__, "templates")
end

class Egocentic
  def method_missing(*)
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
