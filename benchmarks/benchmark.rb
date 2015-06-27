#!/usr/bin/env ruby

$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'), File.dirname(__FILE__))

require_relative './context'
require 'benchmark/ips'

require 'erubis'
require 'faml'
require 'haml'
require 'slim'
require 'hamlit'

class Benchmarks
  def initialize(time, escape_enabled)
    @time     = time
    @benches  = []
    @versions = {}

    init_compiled_benches(escape_enabled)
    if escape_enabled
      init_escaped_benches
    else
      init_plain_benches
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

  def init_compiled_benches(escape_enabled)
    slim_path  = "/view#{'.escaped' if escape_enabled}.slim"
    @erb_code  = File.read(File.dirname(__FILE__) + '/view.erb')
    @haml_code = File.read(File.dirname(__FILE__) + '/view.haml')
    @slim_code = File.read(File.dirname(__FILE__) + slim_path)
  end

  # Totally the same as slim-template/slim's compiled bench.
  def init_plain_benches
    puts 'Compiled rendering benchmarks without HTML escape'
    context = Context.new
    define_plain_methods!(context)

    bench('hamlit', Hamlit::VERSION) { context.run_hamlit }
    bench('erubis', Erubis::VERSION) { context.run_erubis }
    bench('slim', Slim::VERSION)     { context.run_slim_ugly }
    bench('haml', Haml::VERSION)     { context.run_haml_ugly }
  end

  def define_plain_methods!(context)
    haml_ugly = Haml::Engine.new(@haml_code, format: :html5, ugly: true)
    haml_ugly.def_method(context, :run_haml_ugly)
    context.instance_eval %{
      def run_erubis; #{Erubis::Eruby.new(@erb_code).src}; end
      def run_slim_ugly; #{Slim::Engine.new.call @slim_code}; end
      def run_hamlit; #{Hamlit::Engine.new(escape_html: false).call @haml_code}; end
    }
  end

  # slim-template/slim's compiled bench with HTML escaping.
  def init_escaped_benches
    puts 'Compiled rendering benchmarks with HTML escape'
    context = Context.new
    define_escaped_methods!(context)

    bench('hamlit', Hamlit::VERSION) { context.run_hamlit }
    bench('slim', Slim::VERSION)     { context.run_slim_ugly }
    bench('faml', Faml::VERSION)     { context.run_faml }
    bench('erubis', Erubis::VERSION) { context.run_erubis }
    bench('haml', Haml::VERSION)     { context.run_haml_ugly }
  end

  def define_escaped_methods!(context)
    context.instance_eval("def header; '<script>'; end")
    haml_ugly = Haml::Engine.new(@haml_code, format: :html5, ugly: true, escape_html: true)
    haml_ugly.def_method(context, :run_haml_ugly)
    context.instance_eval %{
      def run_erubis; #{Erubis::EscapedEruby.new(@erb_code).src}; end
      def run_slim_ugly; #{Slim::Engine.new.call @slim_code}; end
      def run_faml; #{Faml::Engine.new.call @haml_code}; end
      def run_hamlit; #{Hamlit::Engine.new.call @haml_code}; end
    }
  end

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
bench = Benchmarks.new(time, ENV['HTML_ESCAPE'] == '1')
bench.run
