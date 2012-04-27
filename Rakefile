require "rake/clean"
require 'rake/testtask'
require 'rubygems/package_task'

CLEAN << %w(pkg doc coverage .yardoc)

def scope(path)
  File.join(File.dirname(__FILE__), path)
end

desc "Benchmark Haml against ERb. TIMES=n sets the number of runs, default is 1000."
task :benchmark do
  sh "ruby test/benchmark.rb #{ENV['TIMES']}"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.test_files = Dir["test/**/*_test.rb"].reject {|x| x =~ /haml-spec/}
  t.verbose = true
end

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
  require 'yard'

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

task :pages do
  puts "#{'=' * 50} Running rake pages"
  ensure_git_cleanup do
    sh %{git checkout haml-pages}
    sh %{git reset --hard origin/haml-pages}

    Dir.chdir("/var/www/haml-pages") do
      sh %{git fetch origin}

      sh %{git checkout stable}
      sh %{git reset --hard origin/stable}

      sh %{git checkout haml-pages}
      sh %{git reset --hard origin/haml-pages}
      sh %{rake build --trace}
      sh %{mkdir -p tmp}
      sh %{touch tmp/restart.txt}
    end
  end
end

# ----- Coverage -----

begin
  require 'rcov/rcovtask'

  Rcov::RcovTask.new do |t|
    t.test_files = FileList[scope('test/**/*_test.rb')]
    t.rcov_opts << '-x' << '"^\/"'
    if ENV['NON_NATIVE']
      t.rcov_opts << "--no-rcovrt"
    end
    t.verbose = true
  end
rescue LoadError; end

# ----- Profiling -----

begin
  require 'ruby-prof'

  desc <<END
Run a profile of haml.
  TIMES=n sets the number of runs. Defaults to 1000.
  FILE=str sets the file to profile. Defaults to 'standard'
  OUTPUT=str sets the ruby-prof output format.
    Can be Flat, CallInfo, or Graph. Defaults to Flat. Defaults to Flat.
END
  task :profile do
    times  = (ENV['TIMES'] || '1000').to_i
    file   = ENV['FILE']

    require 'lib/haml'

    file = File.read(scope("test/haml/templates/#{file || 'standard'}.haml"))
    obj = Object.new
    Haml::Engine.new(file).def_method(obj, :render)
    result = RubyProf.profile { times.times { obj.render } }

    RubyProf.const_get("#{(ENV['OUTPUT'] || 'Flat').capitalize}Printer").new(result).print
  end
rescue LoadError; end

# ----- Testing Multiple Rails Versions -----

rails_versions = [
  "v3.1.0",
  "v3.0.10",
  "v2.3.14",
  "v2.2.3",
  "v2.1.2",
]
rails_versions << "v2.0.5" if RUBY_VERSION =~ /^1\.8/

def test_rails_version(version)
  Dir.chdir "test/rails" do
    sh %{git checkout #{version}}
  end
  puts "Testing Rails #{version}"
  Rake::Task['test'].reenable
  Rake::Task['test'].execute
end

def gemfiles
  @gemfiles ||=
    begin
      raise 'Must install bundler to run Rails compatibility tests' if `which bundle`.empty?
      Dir[File.dirname(__FILE__) + '/test/gemfiles/Gemfile.*'].
        reject {|f| f =~ /\.lock$/}.
        reject {|f| RUBY_VERSION !~ /^1\.8/ && f =~ /Gemfile\.rails-2\.[0-2]/}
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
    `rm -rf test/rails`
    `rm -rf test/plugins`
    with_each_gemfile {sh "bundle exec rake test"}
  end
end

# ----- Handling Updates -----

def email_on_error
  yield
rescue Exception => e
  IO.popen("sendmail nex342@gmail.com", "w") do |sm|
    sm << "From: nex3@nex-3.com\n" <<
      "To: nex342@gmail.com\n" <<
      "Subject: Exception when running rake #{Rake.application.top_level_tasks.join(', ')}\n" <<
      e.message << "\n\n" <<
      e.backtrace.join("\n")
  end
ensure
  raise e if e
end

def ensure_git_cleanup
  email_on_error {yield}
ensure
  sh %{git reset --hard HEAD}
  sh %{git clean -xdf}
  sh %{git checkout master}
end

task :handle_update do
  email_on_error do
    unless ENV["REF"] =~ %r{^refs/heads/(master|stable|haml-pages)$}
      puts "#{'=' * 20} Ignoring rake handle_update REF=#{ENV["REF"].inspect}"
      next
    end
    branch = $1

    puts
    puts
    puts '=' * 150
    puts "Running rake handle_update REF=#{ENV["REF"].inspect}"

    sh %{git fetch origin}
    sh %{git checkout stable}
    sh %{git reset --hard origin/stable}
    sh %{git checkout master}
    sh %{git reset --hard origin/master}

    case branch
    when "master"
      sh %{rake release_edge --trace}
    when "stable", "haml-pages"
      sh %{rake pages --trace}
    end

    puts 'Done running handle_update'
    puts '=' * 150
  end
end
