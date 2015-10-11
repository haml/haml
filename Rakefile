require 'bundler/gem_tasks'
require 'rake/testtask'

task default: :test

Rake::TestTask.new do |t|
  t.libs << 'lib' << 'test'
  files = Dir['test/*_test.rb']
  files << 'test/haml-spec/*_test.rb'
  t.ruby_opts = %w[-rtest_helper]
  t.test_files = files
  t.verbose = true
end
