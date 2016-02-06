source 'https://rubygems.org'

# Specify your gem's dependencies in hamlit.gemspec
gemspec

gem 'benchmark-ips', '2.3.0'
gem 'minitest-line'
gem 'pry-byebug'

is_windows = RUBY_PLATFORM =~ /mswin|mingw|bccwin|wince/
if RUBY_VERSION >= '2.1.0' && !is_windows
  gem 'faml'
  gem 'lineprof'
  gem 'stackprof'
end
