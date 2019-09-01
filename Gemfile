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
    gem 'faml', github: 'k0kubun/faml', ref: '7e1c84ed806d8ff2193f3d6428ae24b0e7c6b7a6', submodules: true
    gem 'stackprof'
  end
end
