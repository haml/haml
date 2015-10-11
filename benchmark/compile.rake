$:.unshift File.expand_path('../lib', __FILE__)

require 'hamlit'
require 'faml'
require 'json'

class Benchmark
  def self.bench
    start_time = Time.now
    yield
    Time.now - start_time
  end

  def initialize
    @total = 0.0
    @times = 0
    @max   = 0.0
  end

  def capture(result)
    @max   = result if @max < result
    @total += result
    @times += 1
  end

  def report(message)
    puts "[#{message}] Count: #{@times}, Total: #{format(@total)}, Avg: #{format(@total / @times)}, Max: #{format(@max)}"
  end

  private

  def format(seconds)
    "%.2fms" % (1000 * seconds)
  end
end

namespace :benchmark do
  desc 'Benchmark compilation'
  task :compile do
    haml_benchmark   = Benchmark.new
    faml_benchmark   = Benchmark.new
    hamlit_benchmark = Benchmark.new
    json_path = File.expand_path('../test/haml-spec/tests.json', __dir__)
    contexts  = JSON.parse(File.read(json_path))

    contexts.each do |context|
      context[1].each do |name, test|
        haml             = test['haml']
        locals           = Hash[(test['locals'] || {}).map {|x, y| [x.to_sym, y]}]
        options          = Hash[(test['config'] || {}).map {|x, y| [x.to_sym, y]}]
        options[:format] = options[:format].to_sym if options.key?(:format)
        options          = { ugly: true }.merge(options)

        begin
          haml_time   = Benchmark.bench { Haml::Engine.new(haml, options).precompiled }
          faml_time   = Benchmark.bench { Faml::Engine.new(filename: '').call(haml) }
          hamlit_time = Benchmark.bench { Hamlit::HamlEngine.new(haml, options).precompiled }

          haml_benchmark.capture(haml_time)
          faml_benchmark.capture(faml_time)
          hamlit_benchmark.capture(hamlit_time)
        rescue Temple::FilterError, TypeError
        end
      end
    end

    haml_benchmark.report('Haml  ')
    faml_benchmark.report('Faml  ')
    hamlit_benchmark.report('Hamlit')
  end
end
