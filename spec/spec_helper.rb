require 'hamilton'
require 'unindent'

module HamiltonSpecHelper
  def parse_string(str)
    Hamilton::Parser.new.call(str)
  end

  def render_string(str)
    eval Hamilton::Engine.new.call(str)
  end
end

RSpec.configure do |config|
  config.include HamiltonSpecHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
