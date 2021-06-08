source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Specify your gem's dependencies in hamlit.gemspec
gemspec

gem 'benchmark-ips', '2.3.0'
gem 'maxitest'
gem 'pry'

if /java/ === RUBY_PLATFORM # JRuby
  gem 'pandoc-ruby'
else
  gem 'redcarpet'

  if RUBY_PLATFORM !~ /mswin|mingw/ && RUBY_ENGINE != 'truffleruby'
    gem 'faml'
    gem 'stackprof'
  end
end
