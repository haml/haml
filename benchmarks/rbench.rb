require_relative './context'
require 'rbench'

require 'erb'
require 'erubis'
require 'fast_haml'
require 'haml'
require 'slim'
require 'tenjin'
require 'tilt'

iteration = (ENV['NUM'] || 100000).to_i
RBench.run(iteration) do
  column :erubis,      title: 'erubis'
  column :tenjin,      title: 'tenjin'
  column :fast_haml,   title: 'fast_haml'
  column :fast_erubis, title: 'fast erubis'
  column :slim,        title: 'slim'
  column :temple_erb,  title: 'temple erb'
  column :erb,         title: 'erb'
  column :haml,        title: 'haml'

  @erb_code    = File.read(File.dirname(__FILE__) + '/view.erb')
  @haml_code   = File.read(File.dirname(__FILE__) + '/view.haml')
  @slim_code   = File.read(File.dirname(__FILE__) + '/view.slim')
  @rbhtml_path = File.dirname(__FILE__) + '/view.rbhtml'

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
  }

  report 'precompiled' do
    erubis      { context.run_erubis }
    tenjin      { context.run_tenjin }
    fast_haml   { context.run_fast_haml }
    fast_erubis { context.run_fast_erubis }
    slim        { context.run_slim_ugly }
    temple_erb  { context.run_temple_erb }
    erb         { context.run_erb }
    haml        { context.run_haml_ugly }
  end
end
