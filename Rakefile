require 'bundler/gem_tasks'

desc 'Run benchmarks'
task :bench do
  exit system('bundle exec ruby benchmarks/benchmark.rb')
end

desc 'Run RSpec code examples'
task :spec do
  system('bundle exec rspec --pattern spec/hamlit/**{,/\*/\*\*\}/\*_spec.rb')
end

namespace :spec do
  namespace :update do
    desc 'Generate converted ugly haml-spec'
    task :ugly do
      system('cd spec && rake ugly')
    end

    desc 'Generate converted pretty haml-spec'
    task :pretty do
      system('cd spec && rake pretty')
    end
  end
end

namespace :rails do
  desc 'Run Rails specs'
  task :spec do
    system('cd spec/rails && rake spec')
  end
end

task default: [:spec, 'rails:spec']
