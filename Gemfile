source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Specify your gem's dependencies in hamlit.gemspec
gemspec

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2')
  gem 'rack', '< 2'
end

gem 'benchmark-ips', '2.3.0'
gem 'maxitest'

if /java/ === RUBY_PLATFORM # JRuby
  gem 'pandoc-ruby'
else
  gem 'pry-byebug'
  gem 'redcarpet', github: 'vmg/redcarpet' # To resolve circular require warning

  if RUBY_PLATFORM !~ /mswin|mingw/
    gem 'faml'
    gem 'stackprof'
  end
end
