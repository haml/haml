require 'unindent'
require_relative 'spec_helper/document_generator'
require_relative 'spec_helper/render_helper'
require_relative 'spec_helper/test_case'

RSpec.configure do |config|
  config.include RenderHelper

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.around(:each, skipdoc: true) do |example|
    TestCase.skipdoc do
      example.run
    end
  end

  config.after(:suite) do
    if DocumentGenerator.generate_docs?
      DocumentGenerator.generate_docs!
    end
  end
end
