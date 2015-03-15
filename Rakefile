require 'bundler/gem_tasks'

desc 'Run benchmarks'
task :bench do
  system('bundle exec ruby benchmarks/benchmark.rb')
end

desc 'Run RSpec code examples'
task :spec do
  system('bundle exec rspec --pattern spec/hamlit/**{,/\*/\*\*\}/\*_spec.rb')
end

namespace :rails do
  desc 'Run Rails specs'
  task :spec do
    system('cd spec/rails && rake spec')
  end
end

namespace :haml do
  desc 'Run Haml Spec'
  task :spec do
    system('cd spec/haml-spec && rake spec')
  end
end

task default: [:spec, 'rails:spec', 'haml:spec']
