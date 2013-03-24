require "rake/clean"
require "rake/testtask"
require "rubygems/package_task"

task :default => :test

CLEAN.replace %w(pkg doc coverage .yardoc test/haml vendor)

def silence_warnings
  the_real_stderr, $stderr = $stderr, StringIO.new
  yield
ensure
  $stderr = the_real_stderr
end

desc "Benchmark Haml against ERb. TIMES=n sets the number of runs, default is 1000."
task :benchmark do
  sh "ruby benchmark.rb #{ENV['TIMES']}"
end

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  # haml-spec tests are explicitly added after other tests so they don't
  # interfere with the Haml loading process which can cause test failures
  files = Dir["test/*_test.rb"]
  files.concat(Dir['test/haml-spec/*_test.rb'])
  t.test_files = files
  t.verbose = true
end

task :set_coverage_env do
  ENV["COVERAGE"] = "true"
end

desc "Run Simplecov (only works on 1.9)"
task :coverage => [:set_coverage_env, :test]

gemspec = File.expand_path("../haml.gemspec", __FILE__)
if File.exist? gemspec
  Gem::PackageTask.new(eval(File.read(gemspec))) { |pkg| }
end

task :submodules do
  if File.exist?(File.dirname(__FILE__) + "/.git")
    sh %{git submodule sync}
    sh %{git submodule update --init --recursive}
  end
end

begin
  silence_warnings do
    require 'yard'
  end

  namespace :doc do
    desc "List all undocumented methods and classes."
    task :undocumented do
      command = 'yard --list --query '
      command << '"object.docstring.blank? && '
      command << '!(object.type == :method && object.is_alias?)"'
      sh command
    end
  end

  desc "Generate documentation"
  task(:doc) {sh "yard"}

  desc "Generate documentation incrementally"
  task(:redoc) {sh "yard -c"}

rescue LoadError
end

  desc <<END
Profile Haml.
  TIMES=n sets the number of runs. Defaults to 1000.
  FILE=str sets the file to profile. Defaults to 'standard'
  OUTPUT=str sets the ruby-prof output format.
    Can be Flat, CallInfo, or Graph. Defaults to Flat. Defaults to Flat.
END
task :profile do
  times  = (ENV['TIMES'] || '1000').to_i
  file   = ENV['FILE']

  require 'bundler/setup'
  require 'ruby-prof'
  require 'haml'

  file = File.read(File.expand_path("../test/templates/#{file || 'standard'}.haml", __FILE__))
  obj = Object.new
  Haml::Engine.new(file, :ugly => true).def_method(obj, :render)
  result = RubyProf.profile { times.times { obj.render } }

  RubyProf.const_get("#{(ENV['OUTPUT'] || 'Flat').capitalize}Printer").new(result).print
end

def gemfiles
  @gemfiles ||= begin
    Dir[File.dirname(__FILE__) + '/test/gemfiles/Gemfile.*'].
      reject {|f| f =~ /\.lock$/}.
      reject {|f| RUBY_VERSION < '1.9.3' && f =~ /Gemfile.rails-(\d+).\d+.x/ && $1.to_i > 3}
  end
end

def with_each_gemfile
  old_env = ENV['BUNDLE_GEMFILE']
  gemfiles.each do |gemfile|
    puts "Using gemfile: #{gemfile}"
    ENV['BUNDLE_GEMFILE'] = gemfile
    yield
  end
ensure
  ENV['BUNDLE_GEMFILE'] = old_env
end

namespace :test do
  namespace :bundles do
    desc "Install all dependencies necessary to test Haml."
    task :install do
      with_each_gemfile {sh "bundle"}
    end

    desc "Update all dependencies for testing Haml."
    task :update do
      with_each_gemfile {sh "bundle update"}
    end
  end

  desc "Test all supported versions of rails. This takes a while."
  task :rails_compatibility => 'test:bundles:install' do
    with_each_gemfile {sh "bundle exec rake test"}
  end
  task :rc => :rails_compatibility
end
