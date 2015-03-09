require "bundler/gem_tasks"

task :bench do
  system('TIME=20 bundle exec ruby benchmarks/benchmark.rb')
end

task :rbench do
  system('NUM=200000 bundle exec ruby benchmarks/rbench.rb')
end
