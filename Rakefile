require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :bench do
  system('TIME=20 bundle exec ruby benchmarks/benchmark.rb')
end

task default: :spec
