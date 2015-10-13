require 'bundler/gem_tasks'
require 'rake/testtask'

begin
  origin, $stdout = $stdout, StringIO.new
  Bundler.require
ensure
  $stdout = origin
end

Dir['benchmark/*.rake'].each { |b| import(b) }

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  files = Dir['test/*_test.rb']
  files << 'test/haml-spec/*_test.rb'
  t.ruby_opts = %w[-rtest_helper]
  t.test_files = files
  t.verbose = true
end
task default: :test

Rake::TestTask.new(:spec) do |t|
  t.libs << 'lib' << 'test'
  t.ruby_opts = %w[-rtest_helper]
  t.test_files = %w[test/haml-spec/ugly_test.rb test/haml-spec/pretty_test.rb]
  t.verbose = true
end
