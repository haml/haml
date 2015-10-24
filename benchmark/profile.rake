$:.unshift File.expand_path('../lib', __FILE__)

require 'hamlit'
require 'yaml'

desc 'Profile compilation'
task :profile do
  yaml_path = File.expand_path('../test/haml/haml-spec/tests.yml', __dir__)
  contexts  = YAML.load(File.read(yaml_path))

  hamlit_engine = Hamlit::Engine.new

  Lineprof.profile(/hamlit|temple/) do
    contexts.each do |context|
      context[1].each do |name, test|
        haml             = test['haml']
        locals           = Hash[(test['locals'] || {}).map {|x, y| [x.to_sym, y]}]
        options          = Hash[(test['config'] || {}).map {|x, y| [x.to_sym, y]}]
        options[:format] = options[:format].to_sym if options.key?(:format)
        options          = { ugly: true }.merge(options)

        begin
          hamlit_engine.call(haml)
        rescue Temple::FilterError, TypeError
        end
      end
    end
  end
end
