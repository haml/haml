require 'test_helper'

module Haml
  class OptionsTest < Haml::TestCase
    def test_buffer_defaults_have_only_buffer_option_keys
      assert_equal(
        Haml::Options.buffer_option_keys.sort,
        Haml::Options.buffer_defaults.keys.sort,
      )
    end

    def test_buffer_defaults_values_are_default_options
      Haml::Options.buffer_option_keys.each do |key|
        assert_equal(
          Haml::Options.defaults[key],
          Haml::Options.buffer_defaults[key],
        )
      end
    end
  end
end
