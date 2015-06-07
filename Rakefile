require 'bundler/gem_tasks'

desc 'Run benchmarks'
task :bench do
  exit system('bundle exec ruby benchmarks/benchmark.rb')
end

desc 'Run RSpec code examples'
task :spec do
  exit system('bundle exec rspec --pattern spec/hamlit/**{,/\*/\*\*\}/\*_spec.rb')
end

desc 'Automatically generate documents from rspec'
task :doc do
  system('AUTODOC=1 bundle exec rake spec')
end

namespace :spec do
  desc 'Generate converted ugly haml-spec'
  task :update do
    system('cd spec && rake ugly')
  end
end

namespace :rails do
  desc 'Run Rails specs'
  task :spec do
    exit system('cd spec/rails && rake spec')
  end
end

task default: [:spec, 'rails:spec']
