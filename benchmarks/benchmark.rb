#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))

require_relative './context'
require 'benchmark/ips'

require 'erb'
require 'erubis'
require 'fast_haml'
require 'haml'
require 'slim'
require 'tenjin'
require 'tilt'
require 'hamlit'

class Benchmarks
  def initialize(time)
    @time    = time
    @benches = []

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
      def run_fast_haml; #{FastHaml::Engine.new.call @haml_code}; end
      def run_tenjin; _buf = ''; #{tenjin.script}; end
      def run_hamlit; #{Hamlit::Engine.new.call @haml_code}; end
    }

    bench('erubis')      { context.run_erubis }
    bench('slim')        { context.run_slim_ugly }
    bench('fast_haml')   { context.run_fast_haml }
    bench('tenjin')      { context.run_tenjin }
    bench('fast erubis') { context.run_fast_erubis }
    bench('temple erb')  { context.run_temple_erb }
    bench('erb')         { context.run_erb }
    bench('hamlit')      { context.run_hamlit }
    bench('haml')        { context.run_haml_ugly }
  end

  def run
    Benchmark.ips do |x|
      x.config(time: @time, warmup: 2)
      @benches.each do |name, block|
        x.report(name, &block)
      end
      x.compare!
    end
  end

  def bench(name, &block)
    @benches.push([name, block])
  end
end

time = (ENV['TIME'] || 5).to_i
Benchmarks.new(time).run
