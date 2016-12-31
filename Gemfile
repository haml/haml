source 'https://rubygems.org'

# Specify your gem's dependencies in hamlit.gemspec
gemspec

if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('2.2.2')
  gem 'rack', '< 2'
end

gem 'benchmark-ips', '2.3.0'
gem 'minitest-line'
gem 'pry-byebug'

if RUBY_PLATFORM !~ /mswin|mingw|bccwin|wince/
  gem 'faml'
  gem 'stackprof'
end
