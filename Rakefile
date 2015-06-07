require 'bundler/gem_tasks'

desc 'Run benchmarks'
task :bench do
  exit system('bundle exec ruby benchmarks/benchmark.rb')
end

desc 'Run RSpec code examples'
task :spec do
  exit system('bundle exec rspec --pattern spec/hamlit/**{,/\*/\*\*\}/\*_spec.rb')
end

namespace :spec do
  desc 'Generate converted ugly haml-spec'
  task :update do
    system('cd spec && rake ugly')
  end

  desc 'Check all specs'
  task :release do
    abort 'Spec failed!' unless system('./test.sh')
  end
end

namespace :rails do
  desc 'Run Rails specs'
  task :spec do
    exit system('cd spec/rails && rake spec')
  end
end

task default: [:spec, 'rails:spec']
task release: ['spec:release']
