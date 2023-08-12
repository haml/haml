source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Specify your gem's dependencies in haml.gemspec
gemspec

gem 'benchmark-ips', '2.3.0'
gem 'maxitest'
gem 'pry'

if /java/ === RUBY_PLATFORM # JRuby
  gem 'pandoc-ruby'
else
  gem 'redcarpet'

  if RUBY_PLATFORM !~ /mswin|mingw/ && RUBY_ENGINE != 'truffleruby'
    gem 'stackprof'
  end
end

if RUBY_VERSION < '2.6'
  gem 'rake-compiler', '< 1.2.4'
end
