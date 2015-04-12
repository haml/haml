#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))

require_relative './context'
require 'benchmark/ips'

require 'erb'
require 'erubis'
require 'faml'
require 'haml'
require 'slim'
require 'tenjin'
require 'tilt'
require 'hamlit'

class Benchmarks
  def initialize(time)
    @time     = time
    @benches  = []
    @versions = {}

    @erb_code    = File.read(File.dirname(__FILE__) + '/view.erb')
    @haml_code   = File.read(File.dirname(__FILE__) + '/view.haml')
    @slim_code   = File.read(File.dirname(__FILE__) + '/view.slim')
    @rbhtml_path = File.dirname(__FILE__) + '/view.rbhtml'

    init_compiled_benches
  end

  def init_compiled_benches
    erb         = ERB.new(@erb_code)
    erubis      = Erubis::Eruby.new(@erb_code)
    fast_erubis = Erubis::FastEruby.new(@erb_code)
    haml_ugly   = Haml::Engine.new(@haml_code, format: :html5, ugly: true)
    tenjin      = Tenjin::Engine.new.get_template(@rbhtml_path)

    context = Context.new

    haml_ugly.def_method(context, :run_haml_ugly)
    context.instance_eval %{
      def run_erb; #{erb.src}; end
      def run_erubis; #{erubis.src}; end
      def run_temple_erb; #{Temple::ERB::Engine.new.call @erb_code}; end
      def run_fast_erubis; #{fast_erubis.src}; end
      def run_slim_ugly; #{Slim::Engine.new.call @slim_code}; end
      def run_faml; #{Faml::Engine.new.call @haml_code}; end
      def run_tenjin; _buf = ''; #{tenjin.script}; end
      def run_hamlit; #{Hamlit::Engine.new.call @haml_code}; end
    }

    bench('hamlit', Hamlit::VERSION) { context.run_hamlit }
    bench('erubis', Erubis::VERSION) { context.run_erubis }
    bench('slim', Slim::VERSION)     { context.run_slim_ugly }
    bench('faml', Faml::VERSION)     { context.run_faml }
    bench('haml', Haml::VERSION)     { context.run_haml_ugly }

    if ENV['ALL']
      erb_version = ERB.version.match(/\[([^ ]+)/)[1]
      bench('tenjin', Tenjin::RELEASE)      { context.run_tenjin }
      bench('fast erubis', Erubis::VERSION) { context.run_fast_erubis }
      bench('temple erb', Temple::VERSION)  { context.run_temple_erb }
      bench('erb', erb_version)             { context.run_erb }
    end
  end

  def run
    show_versions
    result = Benchmark.ips do |x|
      x.config(time: @time, warmup: 2)
      @benches.each do |name, block|
        x.report(name, &block)
      end
      x.compare!
    end
  end

  private

  def bench(name, version, &block)
    @benches.push([name, block])
    @versions[name] = version
  end

  def show_versions
    puts 'Versions ' + '-' * 40
    @versions.each do |name, version|
      printf "%20s %10s\n", name, "v#{version}"
    end
  end
end

time = (ENV['TIME'] || 5).to_i
Benchmarks.new(time).run
