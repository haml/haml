require 'bundler/gem_tasks'

desc 'Run benchmarks'
task :bench do
  exit system('bundle exec ruby benchmarks/benchmark.rb')
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
    system('bundle exec rspec spec/haml_spec.rb')
  end

  namespace :spec do
    desc 'Generate converted haml-spec'
    task :update do
      system('cd spec && rake convert')
    end
  end
end

task default: [:spec, 'rails:spec', 'haml:spec']
