require 'minitest/autorun'
require 'yaml'
require 'haml'
require 'hamlit'

class HamlTest < MiniTest::Test
  contexts = YAML.load(File.read(File.expand_path('./tests.yml', __dir__)))

  contexts.each do |context|
    context[1].each do |name, test|
      [{ ugly: true }].each do |base_options|
        define_method("test_#{ base_options[:ugly] ? 'ugly' : 'pretty' }_spec: #{name} (#{context[0]})") do
          haml             = test['haml']
          locals           = Hash[(test['locals'] || {}).map {|x, y| [x.to_sym, y]}]
          options          = Hash[(test['config'] || {}).map {|x, y| [x.to_sym, y]}]
          options[:format] = options[:format].to_sym if options.key?(:format)
          options          = base_options.merge(options)
          haml_result      = Haml::Engine.new(haml, options).render(Object.new, locals)
          hamlit_result    = Hamlit::HamlEngine.new(haml, options).render(Object.new, locals)

          assert_equal haml_result, hamlit_result
        end
      end
    end
  end
end
