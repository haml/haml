# Original: https://github.com/amatsuda/string_template/blob/master/benchmark.rb
require 'benchmark_driver'

Benchmark.driver(repeat_count: 8) do |x|
  x.prelude %{
    require 'rails'
    require 'action_view'
    require 'string_template'
    StringTemplate::Railtie.run_initializers
    require 'hamlit'
    Hamlit::Railtie.run_initializers
    Hamlit::RailsTemplate.set_options(escape_html: false, generator: Temple::Generators::ArrayBuffer)
    require 'action_view/base'

    (view = Class.new(ActionView::Base).new(ActionView::LookupContext.new(''))).instance_variable_set(:@world, 'world!')

    # compile template
    hello = 'benchmark/dynamic_merger/hello'
    view.render(template: hello, handlers: 'string')
    view.render(template: hello, handlers: 'haml')
  }
  x.report 'string', %{ view.render(template: hello, handlers: 'string') }
  x.report 'hamlit', %{ view.render(template: hello, handlers: 'haml') }
  x.loop_count 100_000
end
